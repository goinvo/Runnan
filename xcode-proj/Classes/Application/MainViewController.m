//
//  FillViewController.m
//  RuntimeIPhone
//
//  Created by Anders Riggelsen on 3/24/11.
//  Copyright 2011 Clickteam. All rights reserved.
//

#import "MainViewController.h"
#import "CRunApp.h"
#import "CRunView.h"
#import "MainView.h"

@implementation MainViewController

-(id)initWithRunApp:(CRunApp*)rApp
{
	if(self = [super init])
	{
		runApp = rApp;
	}
	return self;
}

- (void)loadView
{
	screenRect = runApp->screenRect;
	appRect = CGRectMake(0, 0, runApp->gaCxWin, runApp->gaCyWin);
	
	mainView = [[MainView alloc] initWithFrame:screenRect andRunApp:runApp];

	mainView.contentMode = UIViewContentModeScaleAspectFill;
	mainView.autoresizingMask = UIViewAutoresizingNone;
	mainView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
	mainView.opaque = YES;
	
	self.view = mainView;
	[mainView release];
}

-(NSUInteger)supportedInterfaceOrientations
{
	return [runApp supportedOrientations];
}

-(BOOL)shouldAutorotate
{
	return YES;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	return [runApp supportsOrientation:toInterfaceOrientation];
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	UIInterfaceOrientation uiOrientation = [UIApplication sharedApplication].statusBarOrientation;
	switch (uiOrientation) {
		default:
		case UIInterfaceOrientationPortrait:
			runApp->actualOrientation = ORIENTATION_PORTRAIT;
			break;
		case UIInterfaceOrientationLandscapeLeft:
			runApp->actualOrientation = ORIENTATION_LANDSCAPELEFT;
			break;
		case UIInterfaceOrientationLandscapeRight:
			runApp->actualOrientation = ORIENTATION_LANDSCAPERIGHT;
			break;
		case UIInterfaceOrientationPortraitUpsideDown:
			runApp->actualOrientation = ORIENTATION_PORTRAITUPSIDEDOWN;
			break;
	}
}

-(void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag
{
	if([self respondsToSelector:@selector(presentViewController:animated:completion:)])
		[self presentViewController:viewControllerToPresent animated:flag completion:nil];
	else if([self respondsToSelector:@selector(presentModalViewController:animated:)])
		[self presentModalViewController:viewControllerToPresent animated:flag];
}

-(void)dismissViewControllerAnimated:(BOOL)flag
{
	if([self respondsToSelector:@selector(dismissViewControllerAnimated:completion:)])
		[self dismissViewControllerAnimated:flag completion:nil];
	else if([self respondsToSelector:@selector(dismissModalViewControllerAnimated:)])
		[self dismissModalViewControllerAnimated:flag];
}

@end
