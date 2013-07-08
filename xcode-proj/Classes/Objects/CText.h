//----------------------------------------------------------------------------------
//
// CText : Objet string
//
//----------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "CObject.h"
#import "IDrawable.h"

@class CObjectCommon;
@class CCreateObjectInfo;
@class CImageBank;
@class CSprite;
@class CMask;
@class CValue;
@class CFontInfo;
@class CBitmap;
@class CRenderer;
@class CTextSurface;

@interface CText : CObject <IDrawable>
{
@public
	short rsFlag;
    int rsBoxCx;
    int rsBoxCy;
    int rsMaxi;
    int rsMini;
    unsigned char rsHidden;
    NSString* rsTextBuffer;
    short rsFont;
    int rsTextColor;	
	CTextSurface* textSurface;
	int deltaY;
}
-(void)dealloc;
-(void)initObject:(CObjectCommon*)ocPtr withCOB:(CCreateObjectInfo*)cob;
-(void)handle;
-(void)modif;
-(void)display;
-(void)draw:(CRenderer*)renderer;
-(CMask*)getCollisionMask:(int)flags;
-(void)spriteDraw:(CRenderer*)renderer withSprite:(CSprite*)spr andImageBank:(CImageBank*)bank andX:(int)x andY:(int)y;
-(void)spriteKill:(CSprite*)spr;
-(CMask*)spriteGetMask;
-(CFontInfo*)getFont;
-(void)setFont:(CFontInfo*)info withRect:(CRect)pRc;
-(int)getFontColor;
-(void)setFontColor:(int)rgb;
-(void)txtSetString:(NSString*)s;
-(BOOL)txtChange:(int)num;

@end
