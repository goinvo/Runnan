//----------------------------------------------------------------------------------
//
// CMOVEEXTENSION : Mouvement extension
//
//----------------------------------------------------------------------------------
#import "CMoveExtension.h"
#import "CMoveDefExtension.h"
#import "CRunMvtExtension.h"
#import "CFile.h"
#import "CObject.h"
#import "CRunApp.h"
#import "CRunFrame.h"
#import "CRun.h"
#import "CRCom.h"

@implementation CMoveExtension

-(id)initWithObject:(CRunMvtExtension*)m
{
	movement = m;
	return self;
}

-(void)initMovement:(CObject*)ho withMoveDef:(CMoveDef*)mvPtr
{
	hoPtr = ho;
	
	CMoveDefExtension* mdExt = (CMoveDefExtension*) mvPtr;
	CFile* file = [[CFile alloc] initWithBytes:mdExt->data length:mdExt->length];
	[file setUnicode:ho->hoAdRunHeader->rhApp->bUnicode];	
	[movement initialize:file];
	[file release];
	
	hoPtr->roc->rcCheckCollides = YES;			//; Force la detection de collision
	hoPtr->roc->rcChanged = YES;
}

-(void)dealloc
{
	if(movement != nil)
		[movement release];
	[super dealloc];
}

-(void)kill
{
	[movement kill];
}

-(void)move
{
    if ([movement move])
    {
        hoPtr->roc->rcChanged = YES;
    }
}

-(void)stop
{
	[movement stop:rmCollisionCount == hoPtr->hoAdRunHeader->rh3CollisionCount];	    // Sprite courant?
}

-(void)start
{
	[movement start];
}

-(void)bounce
{
	[movement bounce:rmCollisionCount == hoPtr->hoAdRunHeader->rh3CollisionCount];    // Sprite courant?
}

-(void)setSpeed:(int)speed
{
	[movement setSpeed:speed];
}

-(void)setMaxSpeed:(int)speed
{
	[movement setMaxSpeed:speed];
}

-(void)reverse
{
	[movement reverse];
}

-(void)setXPosition:(int)x
{
	[movement setXPosition:x];
	hoPtr->roc->rcChanged = YES;
	hoPtr->roc->rcCheckCollides = YES;
}

-(void)setYPosition:(int)y
{
	[movement setYPosition:y];
	hoPtr->roc->rcChanged = YES;
	hoPtr->roc->rcCheckCollides = YES;
}

-(void)setDir:(int)dir
{
	[movement setDir:dir];
	hoPtr->roc->rcChanged = YES;
	hoPtr->roc->rcCheckCollides = YES;
}

-(double)callMovement:(int)function param:(double)param
{
	callParam = param;
	return [movement actionEntry:function];
}

/*
public int callSavePosition(DataOutputStream stream)
{
	outputStream = stream;
	return (int) movement.actionEntry(0x1010);
}

public int callLoadPosition(DataInputStream stream)
{
	inputStream = stream;
	return (int) movement.actionEntry(0x1011);
}
*/
@end
