//----------------------------------------------------------------------------------
//
// CRCOM : Structure commune aux objets animes
//
//----------------------------------------------------------------------------------
#import "CRCom.h"

@implementation CRCom

-(id)init
{
	rcImage=-1;
	rcOldImage=-1;
	rcScaleX = 1.0f;
	rcScaleY = 1.0f;
	rcAngle=0;
	rcMovementType = -1;
	return self;
}
-(void)kill:(BOOL)bFast
{
}

@end
