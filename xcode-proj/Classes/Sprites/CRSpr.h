//----------------------------------------------------------------------------------
//
// CRSPR : Gestion des objets sprites
//
//----------------------------------------------------------------------------------
#import <Foundation/Foundation.h>

#define RSFLAG_HIDDEN 0x0001
#define RSFLAG_INACTIVE 0x0002
#define RSFLAG_SLEEPING 0x0004
#define RSFLAG_SCALE_RESAMPLE 0x0008
#define RSFLAG_ROTATE_ANTIA 0x0010
#define RSFLAG_VISIBLE 0x0020
#define SPRTYPE_TRUESPRITE 0
#define SPRTYPE_OWNERDRAW 1
#define SPRTYPE_QUICKDISPLAY 2

@class CObject;
@class CSpriteGen;
@class CObjectCommon;
@class CCreateObjectInfo;
@class CSprite;
@class CTrans;
@class CFadeSprite;

@interface CRSpr : NSObject 
{
@public
	CObject* hoPtr;
    CSpriteGen* spriteGen;
    int rsFlash;				/// Flash objets
    double rsFlashCpt;
    short rsLayer;				/// Layer
    int rsZOrder;			/// Z-order value
    int rsCreaFlags;			/// Creation flags
    int rsBackColor;			/// background saving color
    int rsEffect;			/// Sprite effects
    int rsEffectParam;
    short rsFlags;			/// Handling flags
    short rsFadeCreaFlags;		/// Saved during a fadein
    short rsSpriteType;
    CTrans* rsTrans;
	CFadeSprite* fadeSprite;
}
-(void)dealloc;
-(id)initWithHO:(CObject*)ho andOC:(CObjectCommon*)ocPtr andCOB:(CCreateObjectInfo*)cobPtr;
-(void)init2;
-(void)reInit_Spr:(BOOL)fast;
-(void)displayRoutine;
-(void)handle;
-(void)modifRoutine;
-(BOOL)createSprite:(CSprite*)pSprBefore;
-(BOOL)kill:(BOOL)fast;
-(void)objGetZoneInfos;
-(void)obHide;
-(void)obShow;
-(BOOL)createFadeSprite:(BOOL)bFadeOut;
-(BOOL)checkEndFadeIn;
-(BOOL)checkEndFadeOut;

@end
