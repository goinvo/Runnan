//----------------------------------------------------------------------------------
//
// COC: classe abstraite d'objectsCommon
//
//----------------------------------------------------------------------------------
#import "COC.h"
#import "CFile.h"
#import "CSprite.h"
#import "CMask.h"

@implementation COC

-(void)load:(CFile*)file withType:(short)type andCOI:(COI*)pOI
{
}
-(void)enumElements:(id)enumImages withFont:(id)enumFonts
{
}

-(void)spriteDraw:(CGContextRef)g withSprite:(CSprite*)spr andImageBank:(CImageBank*)bank andX:(int)x andY:(int)y
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
