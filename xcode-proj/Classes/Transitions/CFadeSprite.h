//----------------------------------------------------------------------------------
//
// CFADESPRITE sprite pour transisions
//
//----------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "IDrawable.h"

@class CTrans;
@class CBitmap;
@class CImageBank;
@class CMask;
@class CSprite;
@class CRenderer;
@class CRenderToTexture;

@interface CFadeSprite : NSObject <IDrawable>
{
@public
	CTrans* trans;
}
-(id)initWithTrans:(CTrans*)t;
-(void)dealloc;
-(void)spriteDraw:(CRenderer*)g withSprite:(CSprite*)spr andImageBank:(CImageBank*)bank andX:(int)x andY:(int)y;
-(void)spriteKill:(CSprite*)spr;
-(CMask*)spriteGetMask;

@end
