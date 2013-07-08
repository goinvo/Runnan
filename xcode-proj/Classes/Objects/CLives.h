//----------------------------------------------------------------------------------
//
// CLives : Objet lives
//
//----------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "IDrawable.h"
#import "CObject.h"
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

@interface CLives : CObject <IDrawable>
{
@public 
	short rsPlayer;
    CValue* rsValue;
    int rsBoxCx;			// Dimensions box (for lives, counters, texts)
    int rsBoxCy;
    short rsFont;				// Temporary font for texts
    int rsColor1;			// Bar color
    int displayFlags;
	CTextSurface* textSurface;
}
-(id)init;
-(void)dealloc;
-(void)initObject:(CObjectCommon*)ocPtr withCOB:(CCreateObjectInfo*)cob;
-(void)handle;
-(void)modif;
-(void)display;
-(void)getZoneInfos;
-(void)draw:(CRenderer*)renderer;
-(CMask*)getCollisionMask:(int)flags;
-(void)spriteDraw:(CRenderer*)renderer withSprite:(CSprite*)spr andImageBank:(CImageBank*)bank andX:(int)x andY:(int)y;
-(void)spriteKill:(CSprite*)spr;
-(CMask*)spriteGetMask;
-(CFontInfo*)getFont;
-(void)setFont:(CFontInfo*)info withRect:(CRect)pRc;
-(int)getFontColor;
-(void)setFontColor:(int)rgb;
@end
