// --------------------------------------------------------------------------
// 
// VIRTUAL JOYSTICK
// 
// --------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "ITouches.h"

#define KEY_JOYSTICK 0
#define KEY_FIRE1 1
#define KEY_FIRE2 2
#define KEY_NONE -1
#define MAX_TOUCHES 3

#define JFLAG_JOYSTICK		0x0001
#define JFLAG_FIRE1			0x0002
#define JFLAG_FIRE2			0x0004
#define JFLAG_LEFTHANDED	0x0008
#define PI 3.141592654
#define JPOS_NOTDEFINED 0x80000000

@class CRunApp;
@class CImage;
@interface CJoystick : NSObject <ITouches>
{
@public
	CRunApp* app;
	UIImage* joyBack;
	UIImage* joyFront;
	UIImage* fire1U;
	UIImage* fire2U;
	UIImage* fire1D;
	UIImage* fire2D;
	UITouch* touches[3];
	BOOL bLandScape;	
	int imagesX[3];
	int imagesY[3];
	int joystickX;
	int joystickY;
	int joystick;
	int flags;
    double zoom;
	
	CImage* joyBackTex;
	CImage* joyFrontTex;
	CImage* fire1UTex;
	CImage* fire2UTex;
	CImage* fire1DTex;
	CImage* fire2DTex;
}
-(id)initWithApp:(CRunApp*)a;
-(void)dealloc;
-(BOOL)touchBegan:(UITouch*)touch;
-(void)touchMoved:(UITouch*)touch;
-(void)touchEnded:(UITouch*)touch;
-(void)touchCancelled:(UITouch*)touch;
-(void)draw;
-(int)getKey:(int)x withY:(int)y;
-(void)setPositions;
-(unsigned char)getJoystick;
-(void)reset:(int)flag;
-(void)setXPosition:(int)flags withPos:(int)p;
-(void)setYPosition:(int)flags withPos:(int)p;
@end
