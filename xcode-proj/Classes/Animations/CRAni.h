//----------------------------------------------------------------------------------
//
// CRANI gestion des animations
//
//----------------------------------------------------------------------------------
#import <Foundation/Foundation.h>

@class CObject;
@class CAnim;
@class CAnimDir;

@interface CRAni : NSObject 
{
@public
	CObject* hoPtr;
    int raAnimForced;				/// Flags if forced
    int raAnimDirForced;
    int raAnimSpeedForced;
    BOOL raAnimStopped;
    int raAnimOn;				/// Current animation
    CAnim* raAnimOffset;
    int raAnimDir;				/// Direction of current animation
    int raAnimPreviousDir;                       /// Previous OK direction
    CAnimDir* raAnimDirOffset;
    int raAnimSpeed;
    int raAnimMinSpeed;                          /// Minimum speed of movement
    int raAnimMaxSpeed;                          /// Maximum speed of movement
    int raAnimDeltaSpeed;
    int raAnimCounter;                           /// Animation speed counter
    int raAnimDelta;				/// Speed counter
    int raAnimRepeat;				/// Number of repeats
    int raAnimRepeatLoop;			/// Looping picture
    int raAnimFrame;				/// Current frame
    int raAnimNumberOfFrame;                     /// Number of frames
    int raAnimFrameForced;
    int raRoutineAnimation;
    int raOldAngle;	
}
-(id)initWithHO:(CObject*)ho;
-(void)kill:(BOOL)bFast;
-(void)initRAni;
-(void)init_Animation:(int)anim;
-(void)check_Animate;
-(void)extAnimations:(int)anim;
-(BOOL)animate;
-(BOOL)animations;
-(BOOL)animIn:(int)vbl;
-(BOOL)anim_Exist:(int)animId;
-(void)animation_OneLoop;
-(void)animation_Force:(int)anim;
-(void)animation_Restore;
-(void)animDir_Force:(int)dir;
-(void)animDir_Restore;
-(void)animSpeed_Force:(int)speed;
-(void)animSpeed_Restore;
-(void)anim_Restart;
-(void)animFrame_Force:(int)frame;
-(void)animFrame_Restore;
-(void)anim_Appear;
-(void)anim_Disappear;

@end
