//----------------------------------------------------------------------------------
//
// CMOVEPLATFORM : Mouvement plateforme
//
//----------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "CMove.h"

#define MPJC_NOJUMP 0
#define MPJC_DIAGO 1
#define MPJC_BUTTON1 2
#define MPJC_BUTTON2 3
#define MPTYPE_WALK 0
#define MPTYPE_CLIMB 1
#define MPTYPE_JUMP 2
#define MPTYPE_FALL 3
#define MPTYPE_CROUCH 4
#define MPTYPE_UNCROUCH 5

@class CObject;
@class CMoveDef;

@interface CMovePlatform : CMove
{
@public
	int MP_Type;
    int MP_Bounce;
    int MP_BounceMu;
    int MP_XSpeed;
    int MP_Gravity;
    int MP_Jump;
    int MP_YSpeed;
    int MP_XMB;
    int MP_YMB;
    int MP_HTFOOT;
    int MP_JumpControl;
    int MP_JumpStopped;
    int MP_PreviousDir;
    CObject* MP_ObjectUnder;
    int MP_XObjectUnder;
    int MP_YObjectUnder;
    BOOL MP_NoJump;	
}
-(void)initMovement:(CObject*)ho withMoveDef:(CMoveDef*)mvPtr;
-(void)move;
-(void)mpStopIt;
-(void)stop;
-(void)bounce;
-(void)setXPosition:(int)x;
-(void)setYPosition:(int)y;
-(void)setSpeed:(int)speed;
-(void)setMaxSpeed:(int)speed;
-(void)setGravity:(int)gravity;
-(void)setDir:(int)dir;
-(void)calcMBFoot;
-(int)check_Ladder:(int)nLayer withX:(int)x andY:(int)y;
-(void)mpHandle_Background;


@end
