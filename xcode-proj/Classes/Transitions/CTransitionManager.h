//----------------------------------------------------------------------------------
//
// CTRANSITIONMANAGER
//
//----------------------------------------------------------------------------------
#import <Foundation/Foundation.h>

@class CRunApp;
@class CBitmap;
@class CTrans;
@class CTransitionData;
@class CObject;
@class ITexture;
@class CRenderer;
@class CRenderToTexture;

@interface CTransitionManager : NSObject 
{
@public 
	CRunApp* app;	
}
-(id)initWithApp:(CRunApp*)a;
-(CTrans*)createTransition:(CTransitionData*)pData withRenderer:(CRenderer*)renderer andStart:(CRenderToTexture*)surfaceStart andEnd:(CRenderToTexture*)surfaceEnd andType:(int)type;
-(CTrans*)startObjectFade:(CObject*)hoPtr withFlag:(BOOL)bFadeOut;

@end
