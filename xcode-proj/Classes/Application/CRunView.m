//
//  CRunView.m
//  RuntimeIPhone
//
//  Created by Francois Lionet on 08/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CRunView.h"
#import "CRunApp.h"
#import "CRunFrame.h"
#import "CRun.h"
#import "CSpriteGen.h"
#import "CJoystick.h"
#import "CServices.h"
#import "CBitmap.h"
#import "CRenderer.h"
#import "ITouches.h"
#import "CArrayList.h"
#import "CCCA.h"
#include <mach/mach_time.h>

@implementation CRunView

+ (Class)layerClass
{
    return [CAEAGLLayer class];
}

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
	return YES;
}

-(id)initWithFrame:(CGRect)rect
{
    if ((self = [super initWithFrame:rect]))
    {
		CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
	
		renderer = nil;
		appRect = rect;
		pRunApp = nil;
		
		touchesBegan = [[NSMutableArray alloc] init];
		touchesMoved = [[NSMutableArray alloc] init];
		touchesEnded = [[NSMutableArray alloc] init];
		touchesCanceled = [[NSMutableArray alloc] init];
		
		eaglLayer.opaque = YES;
		eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
										[NSNumber numberWithBool:NO],
										kEAGLDrawablePropertyRetainedBacking,
										kEAGLColorFormatRGBA8,
										kEAGLDrawablePropertyColorFormat, nil];
	
		//Attempt to create ES2 renderer, if not possible create an ES1 renderer
		renderer = [[CRenderer alloc] initWithView:self];
		if (renderer==nil)
		{
			[self release];
			return nil;
		}
	
		bTimer=NO;
		displayLink = nil;
		usesDisplayLink = NO;
		timer = nil;
		cleanTimer = nil;
		pruneTimer = nil;
    }
    return self;
}

-(void)dealloc
{
	[touchesBegan release];
	[touchesMoved release];
	[touchesEnded release];
	[touchesCanceled release];
	
	if (renderer==nil)
		[self release];

	[super dealloc];
}

-(void)setMultiTouch:(BOOL)bMulti
{
	self.multipleTouchEnabled=bMulti;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (pRunApp!=nil)
	{
		TouchEventWrapper* wrapper = [[TouchEventWrapper alloc] initWithTouches:touches andEvent:event];
		[touchesBegan addObject:wrapper];
		[wrapper release];
	}
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (pRunApp!=nil)
	{
		TouchEventWrapper* wrapper = [[TouchEventWrapper alloc] initWithTouches:touches andEvent:event];
		[touchesMoved addObject:wrapper];
		[wrapper release];
	}}

-(void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
	if (pRunApp!=nil)
	{
		TouchEventWrapper* wrapper = [[TouchEventWrapper alloc] initWithTouches:touches andEvent:event];
		[touchesEnded addObject:wrapper];
		[wrapper release];
	}
}

-(void)touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event
{
	if (pRunApp!=nil)
	{
		TouchEventWrapper* wrapper = [[TouchEventWrapper alloc] initWithTouches:touches andEvent:event];
		[touchesCanceled addObject:wrapper];
		[wrapper release];
	}
}

-(void)initApplication:(CRunApp*)pApp
{
	pRunApp=pApp;
	[pRunApp setView:self];
	[pRunApp startApplication];
	[[self superview] setNeedsLayout];
}
-(void)pauseTimer
{
	if (bTimer)
	{
		bTimer=NO;
		if(usesDisplayLink)
		{
			[displayLink invalidate];
			displayLink = nil;
		}
		else
		{
			[cleanTimer invalidate];
			[timer invalidate];
			timer = nil;
			cleanTimer = nil;
		}
	}
}
-(void)resumeTimer
{
	if (bTimer==NO)
	{
		bTimer=YES;
		if(pRunApp->gaNewFlags & GANF_VSYNC)
		{
			usesDisplayLink = YES;
			frameInterval = 1;
			if(pRunApp->gaFrameRate <= 30)
				frameInterval = 2;
			if(pRunApp->gaFrameRate <= 15)
				frameInterval = 3;
		}
		else
			usesDisplayLink = NO;

		//Which timer to use
		if(usesDisplayLink)
		{
			if(displayLink != nil)
				[displayLink invalidate];
				
			displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(timerEntry)];
			displayLink.frameInterval = frameInterval;
			[displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
		}
		else
		{
			timer=[NSTimer scheduledTimerWithTimeInterval:(double)(1.0/pRunApp->gaFrameRate) target:self selector:@selector(timerEntry) userInfo:nil repeats:YES];
			[[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
		}
		
		//Texture cleaner timer:
		cleanTimer = [NSTimer scheduledTimerWithTimeInterval:15.0 target:self selector:@selector(cleanEntry) userInfo:nil repeats:YES];
		[[NSRunLoop currentRunLoop] addTimer:cleanTimer forMode:NSDefaultRunLoopMode];
	}
}
-(void)resetFrameRate
{
	[self pauseTimer];
	[self resumeTimer];
}
-(void)endApplication
{
	[self pauseTimer];
}

-(void)clearPostponedInput
{
	[touchesBegan removeAllObjects];
	[touchesMoved removeAllObjects];
	[touchesEnded removeAllObjects];
	[touchesCanceled removeAllObjects];
}

-(void)timerEntry
{
	static double bank = 0;
	uint64_t start, end;
	double elapsed, frameTime;
	if(usesDisplayLink)
	{
		frameTime = displayLink.duration * displayLink.frameInterval;
		bank -= frameTime;
		if(bank > 0)
			return;
		bank = 0;
		start = mach_absolute_time();
	}

	//Handle the postponed input events
	for(TouchEventWrapper* wrapper in touchesBegan)
		[pRunApp touchesBegan:wrapper->touches withEvent:wrapper->event];
	for(TouchEventWrapper* wrapper in touchesMoved)
		[pRunApp touchesMoved:wrapper->touches withEvent:wrapper->event];
	for(TouchEventWrapper* wrapper in touchesEnded)
		[pRunApp touchesEnded:wrapper->touches withEvent:wrapper->event];
	for(TouchEventWrapper* wrapper in touchesCanceled)
		[pRunApp touchesCancelled:wrapper->touches withEvent:wrapper->event];

	[self clearPostponedInput];
	
	//Prepare renderer
	[renderer bindRenderBuffer];
	[renderer updateViewport];
	[renderer useBlending:YES];
	
	//Run event loop
	if ( [pRunApp playApplication:NO]==NO )
	{
		[pRunApp endApplication];
		[pRunApp release];
	}
	
	if (pRunApp != nil && pRunApp->joystick!=nil && pRunApp->appRunningState == SL_FRAMELOOP)
		[pRunApp->joystick draw];

	if(usesDisplayLink)
	{
		mach_timebase_info_data_t info;
		mach_timebase_info(&info);
		end = ((mach_absolute_time()-start)*info.numer) / info.denom;
		elapsed = end / 1000000000.0;
		bank = elapsed;
		if(elapsed > frameTime)
			bank = frameTime + fmod(elapsed, frameTime);
	}
	
	[renderer swapBuffers];
}

//Routine that runs every 15 seconds to find any textures that aren't in use during that 15 second window
-(void)cleanEntry
{
	[renderer cleanUnused];
	
	if(pruneTimer != nil)
		[pruneTimer invalidate];
	
	int removeCount = [renderer->texturesToRemove size];
	NSTimeInterval pruneInterval = 15.0/(removeCount+1);
	pruneTimer = [NSTimer timerWithTimeInterval:pruneInterval target:renderer selector:@selector(pruneTexture) userInfo:nil repeats:YES];
	[[NSRunLoop currentRunLoop] addTimer:pruneTimer forMode:NSDefaultRunLoopMode];
}

-(void)drawNoUpdate
{
	[renderer bindRenderBuffer];
	[renderer updateViewport];
	[renderer useBlending:YES];
	[pRunApp->run screen_Update];
	[renderer swapBuffers];
	[renderer flush];
}

- (void)layoutSubviews
{
    [renderer resizeFromLayer:(CAEAGLLayer*)self.layer];
}
-(CRenderer*)getRenderer
{
	return renderer;
}

@end
