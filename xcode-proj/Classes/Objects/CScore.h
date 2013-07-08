//----------------------------------------------------------------------------------
//
// CScore : Objet score
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

@interface CScore : CObject <IDrawable>
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
	int oldScore;
	NSString* cachedString;
	int cachedLength;
	int vInt;
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

@end
