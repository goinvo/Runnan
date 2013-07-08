//----------------------------------------------------------------------------------
//
// CACTIVE : Objets actifs
//
//----------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "IDrawable.h"
#import "CObject.h"

@class CObjectCommon;
@class CCreateObjectInfo;
@class CImageBank;
@class CSprite;
@class CMask;
@class CBitmap;
@class CRenderer;

@interface CActive : CObject <IDrawable>
{

}
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

@end
