// --------------------------------------------------------------------------
// 
// ACCELERATOR JOYSTICK
// 
// --------------------------------------------------------------------------
#import "CJoystickAcc.h"
#import "CRunApp.h"

@implementation CJoystickAcc

-(id)initWithApp:(CRunApp*)a
{
	app=a;
	[app startAccelerometer];
	return self;
}
-(void)dealloc
{
	[app endAccelerometer];
	[super dealloc];
}

#define MAX_POSITIONX 3
#define MAX_POSITIONY 3
#define CENTER_POSITIONX 2
#define CENTER_POSITIONY 2

-(void)handle
{	
	joystick=0;
	if (app->filteredAccX < -0.1)
		joystick|=0x04;
	if (app->filteredAccX > 0.1)
		joystick|=0x08;
	if (app->filteredAccY < -0.1)
		joystick|=0x02;
	if (app->filteredAccY > 0.1)
		joystick|=0x01;
}
-(int)getJoystick
{
	return joystick;
}

@end
