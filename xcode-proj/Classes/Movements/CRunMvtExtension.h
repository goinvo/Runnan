//----------------------------------------------------------------------------------
//
// CMOVEEXTENSION : classe abstraite de mouvement extension
//
//----------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "CPoint.h"

@class CObject;
@class CRun;
@class CFile;
@interface CRunMvtExtension : NSObject 
{
@public 
	CObject* ho;
    CRun* rh;
	
}
-(void)setObject:(CObject*)hoPtr;
-(void)initialize:(CFile*)file;
-(void)kill;
-(BOOL)move;
-(void)setPosition:(int)x withY:(int)y;
-(void)setXPosition:(int)x;
-(void)setYPosition:(int)y;
-(void)stop:(BOOL)bCurrent;
-(void)bounce:(BOOL)bCurrent;
-(void)reverse;
-(void)start;
-(void)setSpeed:(int)speed;
-(void)setMaxSpeed:(int)speed;
-(void)setDir:(int)dir;
-(void)setAcc:(int)acc;
-(void)setDec:(int)dec;
-(void)setRotSpeed:(int)speed;
-(void)set8Dirs:(int)dirs;
-(void)setGravity:(int)gravity;
-(int)extension:(int)function param:(int)param;
-(double)actionEntry:(int)action;
-(int)getSpeed;
-(int)getAcceleration;
-(int)getDeceleration;
-(int)getGravity;
-(int)dirAtStart:(int)dir;
-(void)animations:(int)anm;
-(void)collisions;
-(CApproach)approachObject:(int)destX withDestY:(int)destY andOriginX:(int)originX andOriginY:(int)originY andFoot:(int)htFoot andPlane:(int)planCol;
-(BOOL)moveIt;
-(BOOL)testPosition:(int)x withY:(int)y andFoot:(int)htFoot andPlane:(int)planCol andFlag:(BOOL)flag;
-(unsigned char)getJoystick;
-(BOOL)colMaskTestRect:(int)x withY:(int)y andWidth:(int)sx andHeight:(int)sy andLayer:(int)layer andPlane:(int)plan;
-(BOOL)colMaskTestPoint:(int)x withY:(int)y andLayer:(int)layer andPlane:(int)plan;
-(double)getParamDouble;

@end
