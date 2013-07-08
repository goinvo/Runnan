//----------------------------------------------------------------------------------
//
// CMOVEEXTENSION : classe abstraite de mouvement extension
//
//----------------------------------------------------------------------------------
#import "CRunMvtExtension.h"
#import "CObject.h"
#import "CRun.h"
#import "CFile.h"
#import "CMoveExtension.h"
#import "CAnim.h"
#import "CRAni.h"
#import "CPoint.h"
#import "CRMvt.h"
#import "CRCom.h"
#import "CRunFrame.h"

@implementation CRunMvtExtension

-(void)setObject:(CObject*)hoPtr
{
	ho=hoPtr;
	rh=ho->hoAdRunHeader;
}	

// Fonctions virtuelles
// -----------------------------------------------------------------------------------
-(void)initialize:(CFile*)file
{
}
-(void)kill
{
}
-(BOOL)move
{
	return NO;
}
-(void)setPosition:(int)x withY:(int)y
{
}
-(void)setXPosition:(int)x
{
}
-(void)setYPosition:(int)y
{
}
-(void)stop:(BOOL)bCurrent
{
}
-(void)bounce:(BOOL)bCurrent
{
}
-(void)reverse
{
}
-(void)start
{
}
-(void)setSpeed:(int)speed
{
}
-(void)setMaxSpeed:(int)speed
{
}
-(void)setDir:(int)dir
{
}
-(void)setAcc:(int)acc
{
}
-(void)setDec:(int)dec
{
}
-(void)setRotSpeed:(int)speed
{
}
-(void)set8Dirs:(int)dirs
{
}
-(void)setGravity:(int)gravity
{
}
-(int)extension:(int)function param:(int)param
{
	return 0;
}
-(double)actionEntry:(int)action
{
	return 0;
}
-(int)getSpeed
{
	return 0;
}
-(int)getAcceleration
{
	return 0;
}
-(int)getDeceleration
{
	return 0;
}
-(int)getGravity
{
	return 0;
}

// Callback routines
// -------------------------------------------------------------------------
-(int)dirAtStart:(int)dir
{
	return [ho->rom dirAtStart:ho withDirAtStart:dir andDir:32];
}
-(void)animations:(int)anm
{
	ho->roc->rcAnim=anm;
	if (ho->roa!=nil)
	{
		[ho->roa animate];
	}
}
-(void)collisions
{
	ho->hoAdRunHeader->rh3CollisionCount++;	
	ho->rom->rmMovement->rmCollisionCount=ho->hoAdRunHeader->rh3CollisionCount;
	[ho->hoAdRunHeader newHandle_Collisions:ho];
}
-(CApproach)approachObject:(int)destX withDestY:(int)destY andOriginX:(int)originX andOriginY:(int)originY andFoot:(int)htFoot andPlane:(int)planCol
{
	destX-=ho->hoAdRunHeader->rhWindowX;
	destY-=ho->hoAdRunHeader->rhWindowY;
	originX-=ho->hoAdRunHeader->rhWindowX;
	originY-=ho->hoAdRunHeader->rhWindowY;
	CApproach bRet=[ho->rom->rmMovement mpApproachSprite:destX withDestY:destY andMaxX:originX andMaxY:originY andFoot:htFoot andPlane:planCol];
		
	bRet.point.x += ho->hoAdRunHeader->rhWindowX;
	bRet.point.y += ho->hoAdRunHeader->rhWindowY;
	return bRet;	    
}	    
-(BOOL)moveIt
{
	return [ho->rom->rmMovement newMake_Move:ho->roc->rcSpeed withDir:ho->roc->rcDir];
}
-(BOOL)testPosition:(int)x withY:(int)y andFoot:(int)htFoot andPlane:(int)planCol andFlag:(BOOL)flag
{
	return [ho->rom->rmMovement tst_SpritePosition:x withY:y andFoot:htFoot andPlane:planCol andFlag:flag];
}    
-(unsigned char)getJoystick
{
	return ho->hoAdRunHeader->rhPlayer;
}
-(BOOL)colMaskTestRect:(int)x withY:(int)y andWidth:(int)sx andHeight:(int)sy andLayer:(int)layer andPlane:(int)plan
{
	return ![ho->hoAdRunHeader->rhFrame bkdCol_TestRect:x-ho->hoAdRunHeader->rhWindowX withY:y-ho->hoAdRunHeader->rhWindowY andWidth:sx andHeight:sy andLayer:layer andPlane:plan];
}
-(BOOL)colMaskTestPoint:(int)x withY:(int)y andLayer:(int)layer andPlane:(int)plan
{
	return ![ho->hoAdRunHeader->rhFrame bkdCol_TestPoint:x-ho->hoAdRunHeader->rhWindowX withY:y-ho->hoAdRunHeader->rhWindowY andLayer:layer andPlane:plan];
}
-(double)getParamDouble
{
	CMoveExtension* mvt=(CMoveExtension*)ho->rom->rmMovement;
	return mvt->callParam;
}
/*
public DataInputStream getInputStream()
{
	CMoveExtension mvt=(CMoveExtension)ho.rom.rmMovement;
	return mvt.inputStream;
}
public DataOutputStream getOutputStream()
{
	CMoveExtension mvt=(CMoveExtension)ho.rom.rmMovement;
	return mvt.outputStream;
}
*/

@end
