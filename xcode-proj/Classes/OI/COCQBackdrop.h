//----------------------------------------------------------------------------------
//
// COBJECTCOMMON : Donn�es d'un objet normal
//
//----------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "COC.h"
#import "IDrawable.h"

#define LINEF_INVX 0x0001
#define LINEF_INVY 0x0002

@class COI;

enum {
	SHAPE_LINE = 1,
	SHAPE_RECTANGLE = 2,
	SHAPE_ELLIPSE = 3
};

enum {
	FILLTYPE_NONE = 0,
	FILLTYPE_SOLID = 1,
	FILLTYPE_GRADIENT = 2,
	FILLTYPE_MOTIF = 3
};

enum {
	GRADIENT_HORIZONTAL = 0,
	GRADIENT_VERTICAL
};

@interface COCQBackdrop : COC <IDrawable>
{
@public 
	short ocBorderSize;			// Border
    int ocBorderColor;
    short ocShape;			// Shape
    short ocFillType;
    short ocLineFlags;			// Only for lines in non filled mode
    int ocColor1;			// Gradient
    int ocColor2;
    int ocGradientFlags;
    short ocImage;				// Image
	COI* pCOI;
}
-(id)init;
-(void)dealloc;
-(void)load:(CFile*)file withType:(short)type andCOI:(COI*)pOi; 
-(void)enumElements:(id)enumImages withFont:(id)enumFonts;
-(void)spriteDraw:(CRenderer*)renderer withSprite:(CSprite*)spr andImageBank:(CImageBank*)bank andX:(int)x andY:(int)y;
-(void)spriteKill:(CSprite*)spr;
-(CMask*)spriteGetMask;

@end
