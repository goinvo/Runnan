//----------------------------------------------------------------------------------
//
// CACTIVE : Objets actifs
//
//----------------------------------------------------------------------------------
#import "CActive.h"
#import "CRun.h"
#import "CRSpr.h"
#import "CObjectCommon.h"
#import "CMask.h"
#import "CSprite.h"
#import "CImageBank.h"
#import "CCreateObjectInfo.h"
#import "CRCom.h"
#import "CBitmap.h"
#import "CRenderer.h"

@implementation CActive

-(void)initObject:(CObjectCommon*)ocPtr withCOB:(CCreateObjectInfo*)cob
{
}

-(void)handle
{
	[ros handle];
	if (roc->rcChanged)
	{
		roc->rcChanged=NO;
		[self modif];
	}
}

-(void)modif
{
	[ros modifRoutine];
}

-(void)display
{
}

-(void)getZoneInfos
{
}

-(void)draw:(CRenderer*)renderer
{
}

-(CMask*)getCollisionMask:(int)flags
{
	return nil;
}

// IDrawable
-(void)spriteDraw:(CRenderer*)renderer withSprite:(CSprite*)spr andImageBank:(CImageBank*)bank andX:(int)x andY:(int)y
{
}
-(void)spriteKill:(CSprite*)spr
{
}

-(CMask*)spriteGetMask
{
	return nil;
}

@end
