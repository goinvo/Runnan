//----------------------------------------------------------------------------------
//
// COCBACKGROUND : un objet dÈcor normal
//
//----------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "COC.h"
#import "IDrawable.h"

@class CFile;
@class CSprite;
@class CImageBank;
@class COI;

@interface COCBackground : COC <IDrawable> 
{
@public 
	short ocImage;			// Image
	COI* pCOI;
}
-(id)init;
-(void)dealloc;
-(void)load:(CFile*)file withType:(short)type andCOI:(COI*)pOI;
-(void)enumElements:(id)enumImages withFont:(id)enumFonts;
-(void)spriteDraw:(CBitmap*)g withSprite:(CSprite*)spr andImageBank:(CImageBank*)bank andX:(int)x andY:(int)y;
-(void)spriteKill:(CSprite*)spr;
-(CMask*)spriteGetMask;

@end
