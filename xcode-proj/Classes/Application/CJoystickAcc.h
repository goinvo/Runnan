// --------------------------------------------------------------------------
// 
// ACCELERATOR JOYSTICK
// 
// --------------------------------------------------------------------------
#import <Foundation/Foundation.h>

@class CRunApp;

@interface CJoystickAcc : NSObject
{
@public
	CRunApp* app;
	double positionX;
	double positionY;
	int joystick;
}
-(id)initWithApp:(CRunApp*)app;
-(void)handle;
-(int)getJoystick;
@end
