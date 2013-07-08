//----------------------------------------------------------------------------------
//
// CMOVESTATIC : Mouvement statique
//
//----------------------------------------------------------------------------------
#import "CMoveStatic.h"
#import "CMove.h"
#import "CObject.h"
#import "CMoveDef.h"
#import "CRAni.h"
#import "CRMvt.h"
#import "CRCom.h"
#import "CRun.h"
#import "CEventProgram.h"

@implementation CMoveStatic

-(void)initMovement:(CObject*)ho withMoveDef:(CMoveDef*)mvPtr
{
	hoPtr=ho;
	hoPtr->roc->rcSpeed=0;
	hoPtr->roc->rcCheckCollides=YES;			//; Force la detection de collision
	hoPtr->roc->rcChanged=YES;
}
-(void)move
{
	if (hoPtr->roa!=nil)
	{
		if ([hoPtr->roa animate])
		{
			return;
		}
	}
	if (hoPtr->roc->rcCheckCollides)			//; Faut-il tester les collisions?
	{
		hoPtr->roc->rcCheckCollides=NO;		//; Va tester une fois!
		[hoPtr->hoAdRunHeader newHandle_Collisions:hoPtr];
	}        
}
-(void)setXPosition:(int)x
{        
	if (hoPtr->hoX!=x)
	{
	    hoPtr->hoX=x;
	    hoPtr->rom->rmMoveFlag=YES;
	    hoPtr->roc->rcChanged=YES;
	}
	hoPtr->roc->rcCheckCollides=YES;					//; Force la detection de collision
}
-(void)setYPosition:(int)y
{
	if (hoPtr->hoY!=y)
	{
	    hoPtr->hoY=y;
	    hoPtr->rom->rmMoveFlag=YES;
	    hoPtr->roc->rcChanged=YES;
	}
	hoPtr->roc->rcCheckCollides=YES;					//; Force la detection de collision
}

@end
