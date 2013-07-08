//----------------------------------------------------------------------------------
//
// IDRAWABLE : Interface pour les sprites owner draw
//
//----------------------------------------------------------------------------------

@class CSprite;
@class CImageBank;
@class CMask;
@class CBitmap;
@class CRenderer;

struct ReplacedColor
{
	unsigned char oR, oG, oB;
	unsigned char rR, rG, rB;
	BOOL replaced;
};
typedef struct ReplacedColor ReplacedColor;

@protocol IDrawable	

-(void)spriteDraw:(CRenderer*)renderer withSprite:(CSprite*)spr andImageBank:(CImageBank*)bank andX:(int)x andY:(int)y;
-(void)spriteKill:(CSprite*)spr;
-(CMask*)spriteGetMask;

@end
