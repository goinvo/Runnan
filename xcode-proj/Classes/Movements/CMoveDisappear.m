//----------------------------------------------------------------------------------
//
// CMOVEDISAPPEAR : Mouvement disparition
//
//----------------------------------------------------------------------------------
#import "CMoveDisappear.h"
#import "CMove.h"
#import "CObject.h"
#import "CMoveDef.h"
#import "CRAni.h"
#import "CRMvt.h"
#import "CRCom.h"
#import "CRun.h"
#import "CMoveDefGeneric.h"
#import "CEventProgram.h"
#import "CRunFrame.h"
#import "CAnim.h"
#import "CRAni.h"

@implementation CMoveDisappear

-(void)initMovement:(CObject*)ho withMoveDef:(CMoveDef*)mvPtr
{
	hoPtr=ho;
}

-(void)move
{
	if ((hoPtr->hoFlags&HOF_FADEOUT)==0)
	{
		if (hoPtr->roa!=nil)
		{
			[hoPtr->roa animate];
			if (hoPtr->roa->raAnimForced!=ANIMID_DISAPPEAR+1)
			{
				[hoPtr->hoAdRunHeader destroy_Add:hoPtr->hoNumber];
			}
		}
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
}

-(void)setYPosition:(int)y
{
	if (hoPtr->hoY!=y)
	{
	    hoPtr->hoY=y;
	    hoPtr->rom->rmMoveFlag=YES;
	    hoPtr->roc->rcChanged=YES;
	}
}

@end
