//
//  MainView.h
//  RuntimeIPhone
//
//  Created by Anders Riggelsen on 3/30/11.
//  Copyright 2011 Clickteam. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CRunView;
@class CRunApp;

@interface MainView : UIView
{
@public
	CRunApp* runApp;
	CGRect screenRect;
	float viewScaleX;
	float viewScaleY;
}

-(id)initWithFrame:(CGRect)rect andRunApp:(CRunApp*)rApp;
-(void)layoutSubviews;


@end
