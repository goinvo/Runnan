//
//  FillViewController.h
//  RuntimeIPhone
//
//  Created by Anders Riggelsen on 3/24/11.
//  Copyright 2011 Clickteam. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CRunApp;
@class CRunView;
@class MainView;

@interface MainViewController : UIViewController
{
@public
	CRunApp* runApp;
	MainView* mainView;
	CGRect screenRect;
	CGRect appRect;
}
-(id)initWithRunApp:(CRunApp*)rApp;
-(void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag;
-(void)dismissViewControllerAnimated:(BOOL)flag;
@end
