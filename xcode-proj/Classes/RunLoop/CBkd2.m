// -----------------------------------------------------------------------------
//
// CBKD2 : objet paste dans le decor
//
// -----------------------------------------------------------------------------
#import "CBkd2.h"
#import "CRun.h"
#import "CSprite.h"
#import "CSpriteGen.h"
#import "CRunApp.h"

@implementation CBkd2

-(id)initWithCRun:(CRun*)rh
{
	rhPtr=rh;
	loHnd = oiHnd = 0; 
    x = y = 0;
	img = colMode = nLayer = obstacleType;
    pSpr[0] = pSpr[1] = pSpr[2] = pSpr[3] = nil;
	inkEffect = inkEffectParam = spriteFlag = 0;
	return self;
}
-(void)dealloc
{
	int n;
	for (n=0; n<4; n++)
	{
		if (pSpr[n]!=nil)
		{
			[rhPtr->rhApp->spriteGen delSpriteFast:pSpr[n]];
		}
	}
	[super dealloc];
}

@end
