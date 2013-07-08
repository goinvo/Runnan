//----------------------------------------------------------------------------------
//
// CIADVIEWCONTROLLER
//
//----------------------------------------------------------------------------------
#import "CIAdViewController.h"
#import "CRunApp.h"
#import "CRunView.h"
#import "CRunViewController.h"
#import "CRun.h"
#import "MainView.h"

@implementation CIAdViewController

-(id)initWithApp:(CRunApp*)a andView:(MainView*)rView
{
	if ((self=[super init]))
	{
		app=a;
		mainView=rView;
		adView=[[ADBannerView alloc] initWithFrame:CGRectZero];
		adView.delegate=self;
		bShown=NO;
		bAdAuthorised=NO; //Changed so no frame that isn't iAD authorized will show any adds.
		
		[self positioniAD];
		[rView addSubview:adView];
	}
	return self;
}

-(void)positioniAD
{
	CGSize ad;
	CGSize screen = [app screenSize];

#ifndef __IPHONE_6_0
	//iOS6 phases out landscape ads completely.
	//http://www.iphonedevsdk.com/forum/iphone-sdk-development/108118-landscape-iad-banners-in-ios-6-edit-landscape-phased-out-completely.html
	switch(app->actualOrientation)
	{
		case ORIENTATION_PORTRAIT:
		case ORIENTATION_PORTRAITUPSIDEDOWN:
			adView.requiredContentSizeIdentifiers=[NSSet setWithObject:ADBannerContentSizeIdentifierPortrait];
			adView.currentContentSizeIdentifier=ADBannerContentSizeIdentifierPortrait;
		break;
		case ORIENTATION_LANDSCAPERIGHT:
		case ORIENTATION_LANDSCAPELEFT:
			adView.requiredContentSizeIdentifiers=[NSSet setWithObject:ADBannerContentSizeIdentifierLandscape];
			adView.currentContentSizeIdentifier=ADBannerContentSizeIdentifierLandscape;
			break;
	}
#endif
	ad = [self getiADSize];

	if (app->hdr2Options&AH2OPT_IADBOTTOM)
	{
		outPoint = CGPointMake(screen.width/2, screen.height+ad.height/2);
		inPoint = CGPointMake(screen.width/2, screen.height-ad.height/2);
	}
	else
	{
		outPoint = CGPointMake(screen.width/2, -ad.height/2);
		inPoint = CGPointMake(screen.width/2, ad.height/2);
	}
	
	if(bShown)
		adView.center = inPoint;
	else
		adView.center = outPoint;
}

-(CGSize)getiADSize
{
	//Always get the iAD dimensions in landscape mode
	CGSize ad = adView.bounds.size;
	if(ad.height > ad.width)
		return CGSizeMake(ad.height, ad.width);
	return ad;
}


-(void)bannerViewDidLoadAd:(ADBannerView*)banner
{
	bAdOK=YES;
	if (bShown==NO && bAdAuthorised==YES)
	{
		[UIView beginAnimations:@"animateAdBannerOff" context:NULL];
		adView.center = inPoint;
		[UIView commitAnimations];
		bShown=YES;
	}
}
-(void)bannerView:(ADBannerView*)banner didFailToReceiveAdWithError:(NSError*)error
{
	bAdOK=NO;
	if (bShown)
	{
		[UIView beginAnimations:@"animateAdBannerOff" context:NULL];
		adView.center = outPoint;
		[UIView commitAnimations];
		bShown=NO;
	}
}
-(void)setAdAuthorised:(BOOL)bAuthorised
{
	if (bAuthorised!=bAdAuthorised)
	{
		bAdAuthorised=bAuthorised;
		if (bAdAuthorised)
		{
			if (bShown==NO && bAdOK==YES)
			{			
				[self bannerViewDidLoadAd:nil];
			}
		}
		else
		{
			if (bShown)
			{
				BOOL oldBAdOK=bAdOK;
				[self bannerView:nil didFailToReceiveAdWithError:nil];
				bAdOK=oldBAdOK;
			}
		}
	}
}
-(BOOL)bannerViewActionShouldBegin:(ADBannerView*)banner willLeaveApplication:(BOOL)willLeave
{
	if (!willLeave)
	{
		if (app->run!=nil)
		{
			[app->run pause];
		}
		[app->runView pauseTimer];		
	}
	return YES;
}
-(void)bannerViewActionDidFinish:(ADBannerView *)banner
{
	if (app->run!=nil)
	{
		[app->run resume];
	}
	[app->runView resumeTimer];
}
@end
