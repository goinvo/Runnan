//----------------------------------------------------------------------------------
//
// CRUNMultipleTOuch
//
//----------------------------------------------------------------------------------
#import "CRunMultipleTouch.h"
#import "CFile.h"
#import "CRunApp.h"
#import "CBitmap.h"
#import "CCreateObjectInfo.h"
#import "CValue.h"
#import "CExtension.h"
#import "CRun.h"
#import "CCndExtension.h"
#import "CRunView.h"

#define CND_NEWTOUCH 0
#define CND_ENDTOUCH 1
#define CND_NEWTOUCHANY 2
#define CND_ENDTOUCHANY 3
#define CND_TOUCHMOVED 4
#define CND_TOUCHACTIVE 5
#define ACT_SETORIGINX 0
#define ACT_SETORIGINY 1
#define EXP_GETNUMBER 0
#define EXP_GETLAST 1
#define EXP_MTGETX 2
#define EXP_MTGETY 3
#define EXP_GETLASTNEWTOUCH 4
#define EXP_GETLASTENDTOUCH 5
#define EXP_GETORIGINX 6
#define EXP_GETORIGINY 7
#define EXP_GETDELTAX 8
#define EXP_GETDELTAY 9
#define EXP_GETTOUCHANGLE 10
#define EXP_GETDISTANCE 11

@implementation CRunMultipleTouch

-(int)getNumberOfConditions
{
	return 6;
}
-(BOOL)createRunObject:(CFile*)file withCOB:(CCreateObjectInfo*)cob andVersion:(int)version
{
	newTouchCount=-1;
	endTouchCount=-1;
	movedTouchCount=-1;
	lastNewTouch=-1;
	lastEndTouch=-1;
	lastTouch=-1;
	
	int n;
	for (n=0; n<MAX_TOUCHES; n++)
	{
		touches[n]=nil;
		touchesX[n]=-1;
		touchesY[n]=-1;
		touchesNew[n]=0;
		touchesEnd[n]=0;
		startX[n]=0;
		startY[n]=0;
		dragX[n]=0;
		dragY[n]=0;
	}
	ho->hoAdRunHeader->rhApp->touches=self;
	return YES;
}
-(void)destroyRunObject:(BOOL)bFast
{
	ho->hoAdRunHeader->rhApp->touches=nil;
}
-(int)handleRunObject
{
	int n;
	for (n=0; n<MAX_TOUCHES; n++)
	{
		if (touchesNew[n]>0)
		{
			touchesNew[n]--;
		}
		if (touchesEnd[n]>0)
		{
			touchesEnd[n]--;
		}
	}
	return 0;
}

-(void)resetTouches
{
	for (int n=0; n<MAX_TOUCHES; n++)
	{
		if(touches[n] != nil)
		{
			touches[n]=nil;
			touchesEnd[n]=2;
			lastTouch=n;
			lastEndTouch=n;
			endTouchCount=[ho getEventCount];
			[ho generateEvent:CND_ENDTOUCH withParam:0];
			[ho generateEvent:CND_ENDTOUCHANY withParam:0];
		}
	}
}

-(BOOL)touchBegan:(UITouch*)touch
{
	int n;
	for (n=0; n<MAX_TOUCHES; n++)
	{
		if (touches[n]==touch)
		{
			break;
		}
		if (touches[n]==nil)
		{
			break;
		}
	}
	if (n<MAX_TOUCHES && touches[n]==nil)
	{
		touches[n]=touch;
		CGPoint position = [touch locationInView:ho->hoAdRunHeader->rhApp->runView];
		touchesX[n]=position.x;
		touchesY[n]=position.y;
		startX[n]=position.x;
		dragX[n]=position.x;
		startY[n]=position.y;
		dragY[n]=position.y;
		touchesNew[n]=2;
		lastTouch=n;
		lastNewTouch=n;
		newTouchCount=[ho getEventCount];
		[ho generateEvent:CND_NEWTOUCH withParam:0];
		[ho generateEvent:CND_NEWTOUCHANY withParam:0];
	}
	return YES;
}
-(void)touchMoved:(UITouch*)touch
{
	int n;
	for (n=0; n<MAX_TOUCHES; n++)
	{
		if (touches[n]==touch)
		{
			CGPoint position = [touch locationInView:ho->hoAdRunHeader->rhApp->runView];
			touchesX[n]=position.x;
			touchesY[n]=position.y;
			dragX[n]=position.x;
			dragY[n]=position.y;
			lastTouch=n;
			[ho generateEvent:CND_TOUCHMOVED withParam:0];
		}
	}
}
-(void)touchEnded:(UITouch*)touch
{
	int n;
	for (n=0; n<MAX_TOUCHES; n++)
	{
		if (touches[n]==touch)
		{
			CGPoint position = [touch locationInView:ho->hoAdRunHeader->rhApp->runView];
			touchesX[n]=position.x;
			touchesY[n]=position.y;
			dragX[n]=position.x;
			dragY[n]=position.y;
			touches[n]=nil;
			touchesEnd[n]=2;
			lastTouch=n;
			lastEndTouch=n;
			endTouchCount=[ho getEventCount];
			[ho generateEvent:CND_ENDTOUCH withParam:0];
			[ho generateEvent:CND_ENDTOUCHANY withParam:0];
		}
	}	
}
-(void)touchCancelled:(UITouch*)touch
{
	[self touchEnded:touch];
}

-(BOOL)condition:(int)num withCndExtension:(CCndExtension*)cnd
{
	switch (num)
	{
		case CND_NEWTOUCH:
			return [self cndNewTouch:cnd];
		case CND_ENDTOUCH:
			return [self cndEndTouch:cnd];
		case CND_NEWTOUCHANY:
			return [self cndNewTouchAny:cnd];
		case CND_ENDTOUCHANY:
			return [self cndEndTouchAny:cnd];
		case CND_TOUCHMOVED:
			return [self cndTouchMoved:cnd];
		case CND_TOUCHACTIVE:
			return [self cndTouchActive:cnd];
	}
	return NO;
}

-(BOOL)cndNewTouch:(CCndExtension*)cnd
{
	int touch=[cnd getParamExpression:rh withNum:0];
	BOOL bTest=NO;
	if (touch<0)
	{
		bTest=YES;
	}
	if (touch>=0 && touch<MAX_TOUCHES)
	{
		if (touchesNew[touch]!=0)
		{
			bTest=YES;
		}
	}
	if (bTest)
	{
		if ((ho->hoFlags & HOF_TRUEEVENT) != 0)
		{
			return YES;
		}
		if ([ho getEventCount] == newTouchCount)
		{
			return YES;
		}
	}
	return NO;
}
-(BOOL)cndNewTouchAny:(CCndExtension*)cnd
{
	if ((ho->hoFlags & HOF_TRUEEVENT) != 0)
	{
		return YES;
	}
	if ([ho getEventCount] == newTouchCount)
	{
		return YES;
	}
	return NO;
}
-(BOOL)cndEndTouchAny:(CCndExtension*)cnd
{
	if ((ho->hoFlags & HOF_TRUEEVENT) != 0)
	{
		return YES;
	}
	if ([ho getEventCount] == newTouchCount)
	{
		return YES;
	}
	return NO;
}
-(BOOL)cndEndTouch:(CCndExtension*)cnd
{
	int touch=[cnd getParamExpression:rh withNum:0];
	BOOL bTest=NO;
	if (touch<0)
	{
		bTest=YES;
	}
	if (touch>=0 && touch<MAX_TOUCHES)
	{
		if (touchesEnd[touch]!=0)
		{
			bTest=YES;
		}
	}
	if (bTest)
	{
		if ((ho->hoFlags & HOF_TRUEEVENT) != 0)
		{
			return YES;
		}
		if ([ho getEventCount] == endTouchCount)
		{
			return YES; 
		}
	}
	return NO;
}
-(BOOL)cndTouchMoved:(CCndExtension*)cnd
{
	int touch=[cnd getParamExpression:rh withNum:0];
	BOOL bTest=NO;
	if (touch<0)
	{
		bTest=YES;
	}
	if (touch==lastTouch)
	{
		bTest=YES;
	}
	if (bTest)
	{
		if ((ho->hoFlags & HOF_TRUEEVENT) != 0)
		{
			return YES;
		}
		if ([ho getEventCount] == movedTouchCount)
		{
			return YES;
		}
	}
	return NO;
}
-(BOOL)cndTouchActive:(CCndExtension*)cnd
{
	int touch=[cnd getParamExpression:rh withNum:0];
	if (touch>=0 && touch<MAX_TOUCHES)
	{
		if (touches[touch]!=nil)
		{
			return YES;
		}
	}
	return NO;
}

-(void)action:(int)num withActExtension:(CActExtension*)act
{
	switch (num)
	{
		case ACT_SETORIGINX:
			[self setOriginX:act];
			break;
		case ACT_SETORIGINY:
			[self setOriginY:act];
			break;
	}
}
-(void)setOriginX:(CActExtension*)act
{
	int touch=[act getParamExpression:rh withNum:0];
	int coord=[act getParamExpression:rh withNum:1];
	
	if (touch>=0 && touch<MAX_TOUCHES)						   
	{
		startX[touch]=coord-rh->rhWindowX;
	}							   
}
-(void)setOriginY:(CActExtension*)act
{
	int touch=[act getParamExpression:rh withNum:0];
	int coord=[act getParamExpression:rh withNum:1];
	
	if (touch>=0 && touch<MAX_TOUCHES)						   
	{
		startY[touch]=coord-rh->rhWindowY;
	}							   
}

-(CValue*)expression:(int)num
{
	switch (num)
	{
		case EXP_GETNUMBER:
			return [self expGetNumber];
		case EXP_GETLAST:
			return [rh getTempValue:lastTouch];
		case EXP_MTGETX:
			return [self expGetX];
		case EXP_MTGETY:
			return [self expGetY];
		case EXP_GETLASTNEWTOUCH:
			return [rh getTempValue:lastNewTouch];
		case EXP_GETLASTENDTOUCH:
			return [rh getTempValue:lastEndTouch];
		case EXP_GETORIGINX:
			return [self expGetOriginX];
		case EXP_GETORIGINY:
			return [self expGetOriginY];
		case EXP_GETDELTAX:
			return [self expGetDeltaX];
		case EXP_GETDELTAY:
			return [self expGetDeltaY];
		case EXP_GETTOUCHANGLE:
			return [self expGetAngle];
		case EXP_GETDISTANCE:
			return [self expGetDistance];
	}
	return nil;
}

-(CValue*)expGetNumber
{
	int count=0;
	int n;
	for (n=0; n<MAX_TOUCHES; n++)
	{
		if (touches[n]!=nil)
		{
			count++;
		}
	}
	return [rh getTempValue:count];
}
-(CValue*)expGetX
{
	int touch=[[ho getExpParam] getInt];
	if (touch>=0 && touch<MAX_TOUCHES)
	{
		return [rh getTempValue:(touchesX[touch]+rh->rhWindowX)-rh->rhApp->parentX];
	}
	return [rh getTempValue:-1];
}
-(CValue*)expGetY
{
	int touch=[[ho getExpParam] getInt];
	if (touch>=0 && touch<MAX_TOUCHES)
	{
		return [rh getTempValue:(touchesY[touch]+rh->rhWindowY)-rh->rhApp->parentY];
	}
	return [rh getTempValue:-1];
}
-(CValue*)expGetOriginX
{
	int touch=[[ho getExpParam] getInt];
	if (touch>=0 && touch<MAX_TOUCHES)
	{
		return [rh getTempValue:(startX[touch]+rh->rhWindowX)-rh->rhApp->parentX];
	}
	return [rh getTempValue:-1];
}
-(CValue*)expGetOriginY
{
	int touch=[[ho getExpParam] getInt];
	if (touch>=0 && touch<MAX_TOUCHES)
	{
		return [rh getTempValue:(startY[touch]+rh->rhWindowY)-rh->rhApp->parentY];
	}
	return [rh getTempValue:-1];
}
-(CValue*)expGetDeltaX
{
	int touch=[[ho getExpParam] getInt];
	if (touch>=0 && touch<MAX_TOUCHES)
	{
		return [rh getTempValue:dragX[touch]-startX[touch]];
	}
	return [rh getTempValue:-1];
}
-(CValue*)expGetDeltaY
{
	int touch=[[ho getExpParam] getInt];
	if (touch>=0 && touch<MAX_TOUCHES)
	{
		return [rh getTempValue:dragY[touch]-startY[touch]];
	}
	return [rh getTempValue:-1];
}
-(CValue*)expGetAngle
{
	int touch=[[ho getExpParam] getInt];
	if (touch>=0 && touch<MAX_TOUCHES)
	{
		int deltaX=dragX[touch]-startX[touch];
		int deltaY=dragY[touch]-startY[touch];
		double angle=atan2(-deltaY,deltaX)*57.295779513082320876798154814105;
		if (angle<0)
		{
			angle=360.0+angle;
		}
		return [rh getTempValue:(int)angle];
	}
	return [rh getTempValue:-1];
}
-(CValue*)expGetDistance
{
	int touch=[[ho getExpParam] getInt];
	if (touch>=0 && touch<MAX_TOUCHES)
	{
		int deltaX=dragX[touch]-startX[touch];
		int deltaY=dragY[touch]-startY[touch];
		double distance=sqrt(deltaX*deltaX+deltaY*deltaY);
		return [rh getTempValue:(int)distance];
	}
	return [rh getTempValue:-1];
}



@end
