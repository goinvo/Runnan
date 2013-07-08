//----------------------------------------------------------------------------------
//
// CEXTENSION: Objets d'extension
//
//----------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "CObject.h"
#import "IDrawable.h"

@class CBitmap;
@class CRenderer;
@class CRunExtension;
@class CBitmap;
@class CCndExtension;
@class CActExtension;
@class CValue;
@class CImage;
@class CRunApp;

@interface CExtension : CObject <IDrawable>
{
@public
	CRunExtension* ext;
    BOOL noHandle;
    int privateData;
    int objectCount;
    int objectNumber;
}
-(void)dealloc;
-(id)initWithType:(int)type andRun:(CRun*)rhPtr;
-(void)initObject:(CObjectCommon*)ocPtr withCOB:(CCreateObjectInfo*)cob;
-(void)handle;
-(void)modif;
-(void)display;
-(BOOL)kill:(BOOL)bFast;
-(void)getZoneInfos;
-(void)draw:(CRenderer*)renderer;
-(CMask*)getCollisionMask:(int)flags;
-(void)spriteDraw:(CRenderer*)renderer withSprite:(CSprite*)spr andImageBank:(CImageBank*)bank andX:(int)x andY:(int)y;
-(void)spriteKill:(CSprite*)spr;
-(CMask*)spriteGetMask;
-(BOOL)condition:(int)num withCndExtension:(CCndExtension*)cnd;
-(void)action:(int)num withActExtension:(CActExtension*)act;
-(CValue*)expression:(int)num;
-(CRunApp*)getApplication;
-(void)loadImageList:(short*)list withLength:(int)length;
-(CImage*)getImage:(short)handle;
-(void)reHandle;
-(int)getExtUserData;
-(void)setExtUserData:(int)data;
-(void)addBackdrop:(CImage*)img withX:(int)x andY:(int)y andEffect:(int)dwEffect andEffectParam:(int)dwEffectParam andType:(int)typeObst andLayer:(int)nLayer;
-(int)getEventCount;
-(CValue*)getExpParam;
-(int)getEventParam;
-(double)callMovement:(CObject*)hoPtr withAction:(int)action andParam:(double)param;
-(CValue*)callExpression:(CObject*)hoPtrw withExpression:(int)action andParam:(int)param;
-(int)getExpressionParam;
-(CObject*)getFirstObject;
-(CObject*)getNextObject;

@end
