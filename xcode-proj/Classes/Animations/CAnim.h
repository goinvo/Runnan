//----------------------------------------------------------------------------------
//
// CANIM : definition d'une animation
//
//----------------------------------------------------------------------------------
#import <Foundation/Foundation.h>

@class CFile;

// Definition of animation codes
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#define ANIMID_STOP 0
#define ANIMID_WALK 1
#define ANIMID_RUN 2
#define ANIMID_APPEAR 3
#define ANIMID_DISAPPEAR 4
#define ANIMID_BOUNCE 5
#define ANIMID_SHOOT 6
#define ANIMID_JUMP 7
#define ANIMID_FALL 8
#define ANIMID_CLIMB 9
#define ANIMID_CROUCH 10
#define ANIMID_UNCROUCH 11
#define ANIMID_USER1 12

@class CFile;
@class CAnimDir;

@interface CAnim : NSObject 
{
@public
	CAnimDir* anDirs[32];
    unsigned char anTrigo[32];
    unsigned char anAntiTrigo[32];
}
-(void)dealloc;
-(void)load:(CFile*)file; 
-(void)enumElements:(id)enumImages;
-(void)approximate:(int)nAnim;

@end
