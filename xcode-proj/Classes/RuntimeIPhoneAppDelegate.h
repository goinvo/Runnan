//
//  RuntimeIPhoneAppDelegate.h
//  RuntimeIPhone
//
//  Created by Francois Lionet on 08/10/09.
//  Copyright Clickteam 2012. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CRunView;
@class CRunApp;
@class CIAdViewController;
@class MainViewController;
@class CRunViewController;
@class CArrayList;

void uncaughtExceptionHandler(NSException *exception);

@interface RuntimeIPhoneAppDelegate : NSObject <UIApplicationDelegate>
{
	CRunApp* runApp;
    UIWindow* window;
	CRunViewController* runViewController;
	MainViewController* mainViewController;
	CIAdViewController* iAdViewController;
	NSString* appPath;

@public
	CArrayList* eventSubscribers;
}

-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
-(void)dealloc;
-(void)applicationDidReceiveMemoryWarning:(UIApplication*)application;
-(void)applicationWillResignActive:(UIApplication *)application;
-(void)applicationDidEnterBackground:(UIApplication *)application;
-(void)applicationWillEnterForeground:(UIApplication *)application;
-(void)applicationDidBecomeActive:(UIApplication *)application;
-(void)applicationWillTerminate:(UIApplication *)application;
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error;
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo;
-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification;


@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

