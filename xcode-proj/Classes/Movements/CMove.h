//----------------------------------------------------------------------------------
//
// CMOVE : Classe de base des mouvements
//
//----------------------------------------------------------------------------------
#import <Foundation/Foundation.h>


@class CObject;
@class CMoveDef;
#import "CPoint.h"

#define MVOPT_8DIR_STICK 0x01

@interface CMove : NSObject 
{
@public 
	CObject* hoPtr;
    int rmAcc;						/// Current acceleration
    int rmDec;						/// Current Decelaration 
    short rmCollisionCount;			/// Collision counter
    int rmStopSpeed;				/// If stopped: speed to take again
    int rmAccValue;					/// Acceleration calculation
    int rmDecValue;					/// Deceleration calculation
	unsigned char rmOpt;
	
}
-(BOOL)newMake_Move:(int)speed withDir:(int)angle;
-(void)moveAtStart:(CMoveDef*)mvPtr;
-(int)getAccelerator:(int)acceleration;
-(void)mv_Approach:(BOOL)bStickToObject;
-(void)mb_Approach:(BOOL)flag;
-(BOOL)tst_SpritePosition:(int)x withY:(int)y andFoot:(short)htFoot andPlane:(short)planCol andFlag:(BOOL)flag;
-(BOOL)tst_Position:(int)x withY:(int)y andFlag:(BOOL)flag;
-(CApproach)mpApproachSprite:(int)destX withDestY:(int)destY andMaxX:(int)maxX andMaxY:(int)maxY andFoot:(short)htFoot andPlane:(short)planCol;
-(CApproach)mbApproachSprite:(int)destX withDestY:(int)destY andMaxX:(int)maxX andMaxY:(int)maxY andFlag:(BOOL)flag;
+(int)getDeltaX:(int)pente withAngle:(int)angle;
+(int)getDeltaY:(int)pente withAngle:(int)angle;
-(void)setAcc:(int)acc;
-(void)setDec:(int)dec;
-(void)setRotSpeed:(int)speed;
-(void)set8Dirs:(int)dirs;
-(void)setGravity:(int)gravity;
-(int)getSpeed;
-(int)getAcc;
-(int)getDec;
-(int)getGravity;
-(void)move;
-(void)stop;
-(void)start;
-(void)bounce;
-(void)reverse;
-(void)setXPosition:(int)x;
-(void)setYPosition:(int)u;
-(void)setSpeed:(int)speed;
-(void)setMaxSpeed:(int)speed;
-(void)initMovement:(CObject*)hoPtr withMoveDef:(CMoveDef*)mvPtr;
-(void)setDir:(int)dir;
+(int)dummy;

@end
