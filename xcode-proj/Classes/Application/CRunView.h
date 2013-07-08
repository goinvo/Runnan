//
//  CRunView.h
//  RuntimeIPhone
//
//  Created by Francois Lionet on 08/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CRenderer.h"

@class CRunApp;

@interface CRunView : UIView 
{
@public	
	CRunApp* pRunApp;
	
	NSTimer* timer;
	NSTimer* cleanTimer;
	NSTimer* pruneTimer;
	CADisplayLink* displayLink;
	BOOL usesDisplayLink;
	int frameInterval;
	
	CRenderer* renderer;
	CGRect appRect;
	CGRect screenRect;
	
	NSMutableArray* touchesBegan;
	NSMutableArray* touchesMoved;
	NSMutableArray* touchesEnded;
	NSMutableArray* touchesCanceled;
	
	BOOL bTimer;
	float viewScale;
}
-(id)initWithFrame:(CGRect)rect;
-(void)dealloc;
-(void)initApplication:(CRunApp*)pApp;
-(void)endApplication;
-(void)timerEntry;
-(void)cleanEntry;
-(void)drawNoUpdate;
-(void)clearPostponedInput;
-(void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event;
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
-(void)touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event;
-(void)setMultiTouch:(BOOL)bMulti;
-(CRenderer*)getRenderer;
-(void)resetFrameRate;
-(void)pauseTimer;
-(void)resumeTimer;


@end
