//----------------------------------------------------------------------------------
//
// CIADVIEWCONTROLLER
//
//----------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "iAd/iAd.h"

@class CRunApp;
@class CRunApp;
@class CRunView;
@class MainView;

@interface CIAdViewController : UIViewController <ADBannerViewDelegate>
{
	CRunApp* app;
	MainView* mainView;
	ADBannerView* adView;
@public 
	BOOL bShown;
	BOOL bAdOK;
	BOOL bAdAuthorised;
	CGPoint inPoint;
	CGPoint outPoint;
}
-(id)initWithApp:(CRunApp*)a andView:(MainView*)rView;
-(void)setAdAuthorised:(BOOL)bAuthorised;
-(void)positioniAD;
-(CGSize)getiADSize;

@end
