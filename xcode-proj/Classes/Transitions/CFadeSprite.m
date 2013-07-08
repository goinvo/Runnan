//----------------------------------------------------------------------------------
//
// CFADESPRITE sprite pour transisions
//
//----------------------------------------------------------------------------------
#import "CFadeSprite.h"
#import "CTrans.h"
#import "CRSpr.h"
#import "CSprite.h"
#import "CImageBank.h"
#import "CObject.h"
#import "CImage.h"
#import "CBitmap.h"
#import "CRenderer.h"
#import "CRenderToTexture.h"

@implementation CFadeSprite

-(id)initWithTrans:(CTrans*)t
{
	trans=t;
	return self;
}
-(void)dealloc
{
	if (trans!=nil)
	{
		[trans release];
	}
	[super dealloc];
}
-(void)spriteDraw:(CRenderer*)renderer withSprite:(CSprite*)spr andImageBank:(CImageBank*)bank andX:(int)x andY:(int)y
{
	int trFlags = 0;
	if ((spr->sprExtraInfo->hoFlags&HOF_FADEOUT)!=0)
		trFlags |= TRFLAG_FADEOUT;
	else
		trFlags |= TRFLAG_FADEIN;
	
	[renderer setOriginX:x andY:y];
	[trans stepDraw:trFlags];
	[renderer setOriginX:0 andY:0];
}

-(void)spriteKill:(CSprite*)spr
{
	if (trans!=nil)
	{
		if ((spr->sprExtraInfo->hoFlags & HOF_FADEOUT) != 0)
		{
			[spr->sprExtraInfo release];
			spr->sprExtraInfo = nil;
		}
	}
}
-(CMask*)spriteGetMask
{
	return nil;
}

-(NSString*)description
{
	return [NSString stringWithFormat:@"FadeSprite: %@", trans];
}

@end
