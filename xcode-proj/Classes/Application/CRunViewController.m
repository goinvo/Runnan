//
//  CRunViewController.m
//  RuntimeIPhone
//
//  Created by Francois Lionet on 02/04/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CRunViewController.h"
#import "CRunApp.h"

@implementation CRunViewController

-(id)initWithApp:(CRunApp*)pApp
{
	if (self=[super init])
	{
		runApp=pApp;
	}
	return self;
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
-(void)loadView
{
	appRect = CGRectMake(0, 0, runApp->gaCxWin, runApp->gaCyWin);
	screenRect = runApp->screenRect;
	
	runView = [[CRunView alloc] initWithFrame:appRect];
	
	//Smooth resizing option
	if((runApp->hdr2Options & AH2OPT_ANTIALIASED) == 0)
		runView.layer.magnificationFilter = kCAFilterNearest;
	
	runView.contentMode = UIViewContentModeScaleAspectFill;
	runView.autoresizingMask = UIViewAutoresizingNone;	
	runView.clipsToBounds = YES;
	self.view = runView;
	[runView release];
}

-(void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

-(void)dealloc 
{
	[runView release];	
    [super dealloc];
}

@end
