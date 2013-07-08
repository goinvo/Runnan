//
//  main.m
//  RuntimeIPhone
//
//  Created by Francois Lionet on 08/10/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

int main(int argc, char *argv[])
{
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    int retVal = UIApplicationMain(argc, argv, nil, @"RuntimeIPhoneAppDelegate");
    [pool release];
    return retVal;
}
