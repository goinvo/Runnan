//----------------------------------------------------------------------------------
//
// CCounter : Objet compteur
//
//----------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "CObject.h"
#import "IDrawable.h"
#import "CRect.h"

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

@interface CCounter : CObject <IDrawable>
{
@public
	short rsFlags;			/// Type + flags
    int rsMini;
    int rsMaxi;				// 
    CValue* rsValue;
    int rsBoxCx;			/// Dimensions box (for lives, counters, texts)
    int rsBoxCy;
    double rsMiniDouble;
    double rsMaxiDouble;
    short rsOldFrame;			/// Counter only 
    unsigned char rsHidden;
    short rsFont;				/// Temporary font for texts
    int rsColor1;			/// Bar color
    int rsColor2;			/// Gradient bar color
    int displayFlags;
	
	CTextSurface* textSurface;
	NSString* cachedString;
	int cachedLength;
	CValue* prevValue;
	CValue* tmp;
	int vInt;
	double vDouble;
}
-(void)dealloc;
-(void)initObject:(CObjectCommon*)ocPtr withCOB:(CCreateObjectInfo*)cob;
-(void)handle;
-(void)modif;
-(void)display;
-(void)getZoneInfos;
-(void)updateCachedData;
-(void)draw:(CRenderer*)renderer;
-(CMask*)getCollisionMask:(int)flags;
-(void)spriteDraw:(CRenderer*)renderer withSprite:(CSprite*)spr andImageBank:(CImageBank*)bank andX:(int)x andY:(int)y;
-(void)spriteKill:(CSprite*)spr;
-(CMask*)spriteGetMask;
-(CFontInfo*)getFont;
-(void)setFont:(CFontInfo*)info withRect:(CRect)pRc;
-(int)getFontColor;
-(void)setFontColor:(int)rgb;
-(int)cpt_GetColor2;
-(int)cpt_GetColor1;
-(void)cpt_GetMax:(CValue*)value;
-(void)cpt_GetMin:(CValue*)value;
-(CValue*)cpt_GetValue;
-(void)cpt_SetColor2:(int)rgb;
-(void)cpt_SetColor1:(int)rgb;
-(void)cpt_SetMax:(CValue*)value;
-(void)cpt_SetMin:(CValue*)value;
-(void)cpt_Sub:(CValue*)pValue;
-(void)cpt_Add:(CValue*)pValue;
-(void)cpt_Change:(CValue*)pValue;
-(void)cpt_ToFloat:(CValue*)pValue;


@end
