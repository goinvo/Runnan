//----------------------------------------------------------------------------------
//
// CMOVEBULLET : mouvement shoot
//
//----------------------------------------------------------------------------------
#import "CMoveBullet.h"
#import "CMove.h"
#import "CObject.h"
#import "CMoveDef.h"
#import "CRAni.h"
#import "CRMvt.h"
#import "CRCom.h"
#import "CRun.h"
#import "CEventProgram.h"
#import "CRunFrame.h"
#import "CAnim.h"
#import "CSprite.h"
#import "CRSpr.h"
#import "CRAni.h"
#import "CAnim.h"

extern BOOL bMoveChanged;
@implementation CMoveBullet

-(void)initMovement:(CObject*)ho withMoveDef:(CMoveDef*)mvPtr
{
	hoPtr=ho;
	if (hoPtr->roc->rcSprite!=nil)						// Est-il active?
	{
	    [hoPtr->roc->rcSprite setSpriteColFlag:0];		//; Pas dans les collisions
	}
	if ( hoPtr->ros!=nil )
	{
	    hoPtr->ros->rsFlags&=~RSFLAG_VISIBLE;
	    [hoPtr->ros obHide];									//; Cache pour le moment
	}
	MBul_Wait=YES;
	hoPtr->hoCalculX=0;
	hoPtr->hoCalculY=0;
	if (hoPtr->roa!=nil)
	{
	    [hoPtr->roa init_Animation:ANIMID_WALK];
	}
	hoPtr->roc->rcSpeed=0;
	hoPtr->roc->rcCheckCollides=YES;			//; Force la detection de collision
	hoPtr->roc->rcChanged=YES;
}

-(void)init2:(CObject*)parent
{
	hoPtr->roc->rcMaxSpeed=hoPtr->roc->rcSpeed;
	hoPtr->roc->rcMinSpeed=hoPtr->roc->rcSpeed;				
	MBul_ShootObject=parent;			// Met l'objet source	
}

-(void)move
{
	if (MBul_Wait)
	{
	    // Attend la fin du mouvement d'origine
	    // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	    if (MBul_ShootObject->roa!=nil)
	    {
			if (MBul_ShootObject->roa->raAnimOn==ANIMID_SHOOT) 
				return;
	    }
	    [self startBullet];
	}
	
	// Fait fonctionner la balle
	// ~~~~~~~~~~~~~~~~~~~~~~~~~
	if (hoPtr->roa!=nil)
	{
		[hoPtr->roa animate];
	}
	[self newMake_Move:hoPtr->roc->rcSpeed withDir:hoPtr->roc->rcDir];
	if (bMoveChanged)
	{
		return;
	}
	
	// Verifie que la balle ne sort pas du terrain (assez loin des bords!)
	// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	if (hoPtr->hoX<-64 || hoPtr->hoX>hoPtr->hoAdRunHeader->rhLevelSx+64 || hoPtr->hoY<-64 || hoPtr->hoY>hoPtr->hoAdRunHeader->rhLevelSy+64)
	{
	    // Detruit la balle, sans explosion!
	    // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	    hoPtr->hoCallRoutine=NO;
	    [hoPtr->hoAdRunHeader destroy_Add:hoPtr->hoNumber];
	}	
	if (hoPtr->roc->rcCheckCollides)			//; Faut-il tester les collisions?
	{
		hoPtr->roc->rcCheckCollides=NO;		//; Va tester une fois!
		[hoPtr->hoAdRunHeader newHandle_Collisions:hoPtr];
	}        
}

-(void)startBullet
{
	// Fait demarrer la balle
	// ~~~~~~~~~~~~~~~~~~~~~~
	if (hoPtr->roc->rcSprite!=nil)				//; Est-il active?
	{
	    [hoPtr->roc->rcSprite setSpriteColFlag:SF_RAMBO];
	}
	if ( hoPtr->ros!=nil )
	{
	    hoPtr->ros->rsFlags|=RSFLAG_VISIBLE;
	    [hoPtr->ros obShow];					//; Plus cache
	}
	MBul_Wait=NO; 					//; On y va!
	MBul_ShootObject=nil;
}

-(void)setXPosition:(int)x
{        
	if (hoPtr->hoX!=x)
	{
	    hoPtr->hoX=x;
	    hoPtr->rom->rmMoveFlag=YES;
	    hoPtr->roc->rcChanged=YES;
	    hoPtr->roc->rcCheckCollides=YES;					//; Force la detection de collision
	}
}

-(void)setYPosition:(int)y
{
	if (hoPtr->hoY!=y)
	{
	    hoPtr->hoY=y;
	    hoPtr->rom->rmMoveFlag=YES;
	    hoPtr->roc->rcChanged=YES;
	    hoPtr->roc->rcCheckCollides=YES;					//; Force la detection de collision
	}
}


@end
