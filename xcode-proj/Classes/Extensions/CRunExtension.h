//----------------------------------------------------------------------------------
//
// CRUNEXTENSION: Classe abstraite run extension
//
//----------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "CRect.h"

#define REFLAG_DISPLAY 1
#define REFLAG_ONESHOT 2

@class CExtension;
@class CRun;
@class CBitmap;
@class CMask;
@class CCreateObjectInfo;
@class CActExtension;
@class CCndExtension;
@class CFontInfo;
@class CImage;
@class CFile;
@class CValue;
@class CRenderer;

@interface CRunExtension : NSObject 
{
@public
    CExtension* ho;
    CRun* rh;	
}
-(void)initialize:(CExtension*)hoPtr;
-(int)getNumberOfConditions;
-(BOOL)createRunObject:(CFile*)file withCOB:(CCreateObjectInfo*)cob andVersion:(int)version;
-(int)handleRunObject;
-(void)displayRunObject:(CRenderer*)renderer;
-(void)destroyRunObject:(BOOL)bFast;
-(void)pauseRunObject;
-(void)continueRunObject;
-(void)getZoneInfos;
-(BOOL)condition:(int)num withCndExtension:(CCndExtension*)cnd;
-(void)action:(int)num withActExtension:(CActExtension*)act;
-(CValue*)expression:(int)num;
-(CMask*)getRunObjectCollisionMask:(int)flags;
-(CImage*)getRunObjectSurface;
-(CFontInfo*)getRunObjectFont;
-(void)setRunObjectFont:(CFontInfo*)fi withRect:(CRect)rc;
-(int)getRunObjectTextColor;
-(void)setRunObjectTextColor:(int)rgb;

@end
