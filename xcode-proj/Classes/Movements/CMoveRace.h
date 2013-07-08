//----------------------------------------------------------------------------------
//
// CMOVERACE : Mouvement voiture de course
//
//----------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "CMove.h"

@class CObject;
@class CMoveDef;

@interface CMoveRace : CMove
{
@public
	int MR_Bounce;
    int MR_BounceMu;
    int MR_Speed;
    int MR_RotSpeed;
    int MR_RotCpt;
    int MR_RotPos;
    int MR_RotMask;
    int MR_OkReverse;
    int MR_OldJoy;
    int MR_LastBounce;	
}
-(void)initMovement:(CObject*)ho withMoveDef:(CMoveDef*)mvPtr;
-(void)move;
-(void)stop;
-(void)start;
-(void)bounce;
-(void)setSpeed:(int)speed;
-(void)setMaxSpeed:(int)speed;
-(void)setRotSpeed:(int)speed;
-(void)setXPosition:(int)x;
-(void)setYPosition:(int)y;
-(void)setDir:(int)dir;

@end
