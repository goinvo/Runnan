//----------------------------------------------------------------------------------
//
// CMOVEGENERIC : Mouvement joystick
//
//----------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "CMove.h"

@class CObject;
@class CMoveDef;

@interface CMoveGeneric : CMove
{
@public
	int MG_Bounce;
    int MG_OkDirs;
    int MG_BounceMu;
    int MG_Speed;
    int MG_LastBounce;
    int MG_DirMask;	
}
-(void)initMovement:(CObject*)ho withMoveDef:(CMoveDef*)mvPtr;
-(void)move;
-(void)bounce;
-(void)stop;
-(void)start;
-(void)setMaxSpeed:(int)speed;
-(void)setSpeed:(int)speed;
-(void)setXPosition:(int)x;
-(void)setYPosition:(int)y;
-(void)set8Dirs:(int)dirs;

@end
