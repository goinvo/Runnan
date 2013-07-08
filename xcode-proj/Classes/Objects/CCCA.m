//----------------------------------------------------------------------------------
//
// CCCA : Objet sub-application
//
//----------------------------------------------------------------------------------
#import "CCCA.h"
#import "CRunApp.h"
#import "CDefCCA.h"
#import "CObjectCommon.h"
#import "CRMvt.h"
#import "CRun.h"
#import "CRect.h"
#import "CSpriteGen.h"
#import "CSprite.h"
#import "CValue.h"
#import "CRunFrame.h"
#import "CRenderToTexture.h"

@implementation CCCA

-(void)startCCA:(CObjectCommon*)ocPtr withStartFrame:(int)nStartFrame
{
	CDefCCA* defCCA = (CDefCCA*) ocPtr->ocObject;
	
	hoImgWidth = defCCA->odCx;
	hoImgHeight = defCCA->odCy;
	odOptions = defCCA->odOptions;
	
	// Stretch? force custom size option
	if ((odOptions & CCAF_STRETCH) != 0)
	{
		odOptions |= CCAF_CUSTOMSIZE;
	}
	
	// Get start frame
	if (nStartFrame == -1)
	{
		nStartFrame = 0;
		if ((odOptions & CCAF_INTERNAL) != 0)
		{
			nStartFrame = defCCA->odNStartFrame;
		}
	}
	
	// Same application
	if ((odOptions & CCAF_INTERNAL) == 0)
	{
		return;
	}
	
	// Internal frame, check it exists and is different from the current one
	if (nStartFrame >= hoAdRunHeader->rhApp->gaNbFrames)
	{
		return;
	}
	if (nStartFrame == hoAdRunHeader->rhApp->currentFrame)
	{
		return;
	}
	
	// Flag visible
	bVisible=YES;
	if ((ocPtr->ocFlags2 & OCFLAGS2_VISIBLEATSTART) == 0)
	{
		bVisible=NO;
	}

	//Register itself as the modal subapp
	CRunApp* parentApp = hoAdRunHeader->rhApp;
	if(odOptions & CCAF_MODAL)
	{
		if(parentApp->modalSubapp == nil)
			hoAdRunHeader->rhApp->modalSubapp = self;
		[parentApp->run pause];
	}
	
	// Starts the application
	subApp=[[CRunApp alloc] initAsSubApp:hoAdRunHeader->rhApp];
	[subApp load];
	[subApp setParentView:hoAdRunHeader->rhApp->runView startFrame:nStartFrame options:odOptions width:hoImgWidth height:hoImgHeight];
	subApp->subApp = self;
	[subApp startApplication];
	[subApp playApplication:YES];	
}

-(void)initObject:(CObjectCommon*)ocPtr withCOB:(CCreateObjectInfo*)cob
{
	rtt = nil;
	[self startCCA:ocPtr withStartFrame:-1];
	oldX=hoX;
	oldY=hoY;
	hoRect.left=hoX-hoAdRunHeader->rhWindowX;
	hoRect.top=hoY-hoAdRunHeader->rhWindowY;
	hoRect.right=hoRect.left+hoImgWidth;
	hoRect.bottom=hoRect.top+hoImgHeight;
	int f=0;
	if (bVisible==NO)
	{
		f=SF_HIDDEN;
	}
	sprite=[hoAdRunHeader->rhApp->spriteGen addOwnerDrawSprite:hoRect.left withY1:hoRect.top andX2:hoRect.right andY2:hoRect.bottom andLayer:hoAdRunHeader->rhFrame->nLayers-1 andZOrder:10000 andBackColor:0 andFlags:f andObject:self andDrawable:self];
	[hoAdRunHeader addSubApp:self];
}

-(BOOL)kill:(BOOL)bFast
{
	if (subApp != nil)
	{
		// End of current frame
		switch (subApp->appRunningState)
		{
                // Frame fade-in loop
			case 2:	    // SL_FRAMEFADEINLOOP:
				if ([subApp loopFrameFadeIn]==NO)
				{
					[subApp endFrameFadeIn];
					[subApp endFrame];
				}
				break;
				
                // Frame loop
			case 3:	    // SL_FRAMELOOP:
				[subApp endFrame];
				break;
				
                // Frame fade-out loop
			case 4:	    // SL_FRAMEFADEOUTLOOP:
				[subApp endFrameFadeOut];
				break;
		}
		
		// End of application
		[subApp endApplication];
		[subApp release];
		subApp = nil;
		[rtt release];
		rtt = nil;
	}
	if (sprite!=nil)
	{
		[hoAdRunHeader->rhApp->spriteGen delSpriteFast:sprite];
		sprite=nil;		
	}
	[hoAdRunHeader removeSubApp:self];

	//Remove itself as the current modal subapp
	CRunApp* parentApp = hoAdRunHeader->rhApp;
	if(odOptions & CCAF_MODAL)
	{
		if(parentApp->modalSubapp == self)
			hoAdRunHeader->rhApp->modalSubapp = nil;
		[parentApp->run resume];
	}
	return NO;
}

-(void)handle
{
	[rom move];
	if (subApp != nil)
	{
		if (sprite!=nil && ((oldX != hoX || oldY != hoY) || (hoOEFlags & OEFLAG_SCROLLINGINDEPENDANT) == 0))
		{
			oldX = hoX;
			oldY = hoY;
			hoRect.left=hoX-hoAdRunHeader->rhWindowX;
			hoRect.top=hoY-hoAdRunHeader->rhWindowY;
			hoRect.right=hoRect.left+hoImgWidth;
			hoRect.bottom=hoRect.top+hoImgHeight;
			[hoAdRunHeader->rhApp->spriteGen modifOwnerDrawSprite:sprite withX1:hoRect.left andY1:hoRect.top andX2:hoRect.right andY2:hoRect.bottom];
		}
		if ([subApp playApplication:NO]==NO)
		{
			[subApp endApplication];
			[subApp release];
			subApp=nil;
			return;
		}
		oldLevel=level;
		level=subApp->currentFrame;
	}
}

-(void)restartApp
{
	if (subApp != nil)
	{
		if (subApp->run != nil)
		{
			subApp->run->rhQuit = LOOPEXIT_NEWGAME;
			return;
		}
		[subApp endApplication];
		[subApp release];
		subApp=nil;
	}
	[self startCCA:hoCommon withStartFrame:-1];
}

-(void)endApp
{
	if (subApp != nil)
	{
		if (subApp->run != nil)
		{
			subApp->run->rhQuit = LOOPEXIT_ENDGAME;
		}
	}
	//Remove itself as the current modal subapp
	CRunApp* parentApp = hoAdRunHeader->rhApp;
	if(odOptions & CCAF_MODAL)
	{
		if(parentApp->modalSubapp == self)
			hoAdRunHeader->rhApp->modalSubapp = nil;
		[parentApp->run resume];
	}

	hoFlags |= HOF_DESTROYED;
	[hoAdRunHeader destroy_Add:hoNumber];
}

-(void)hide
{
	if (sprite!=nil)
	{
		if (bVisible==YES)
		{
			bVisible=NO;
			[hoAdRunHeader->rhApp->spriteGen showSprite:sprite withFlag:NO];
		}
	}
}

-(void)show
{
	if (sprite!=nil)
	{
		if (bVisible==NO)
		{
			bVisible=YES;
			[hoAdRunHeader->rhApp->spriteGen showSprite:sprite withFlag:YES];
		}
	}
}

-(void)jumpFrame:(int)frame
{
	if (subApp != nil)
	{
		if (subApp->run != nil)
		{
			if (frame>=0 && frame<4096)
			{
				subApp->run->rhQuit = LOOPEXIT_GOTOLEVEL;
				subApp->run->rhQuitParam = 0x8000 | frame;
			}
		}
	}
}

-(void)nextFrame
{
	if (subApp != nil)
	{
		if (subApp->run != nil)
		{
			subApp->run->rhQuit = LOOPEXIT_NEXTLEVEL;
		}
	}
}

-(void)previousFrame
{
	if (subApp != nil)
	{
		if (subApp->run != nil)
		{
			subApp->run->rhQuit = LOOPEXIT_PREVLEVEL;
		}
	}
}

-(void)restartFrame
{
	if (subApp != nil)
	{
		if (subApp->run != nil)
		{
			subApp->run->rhQuit = LOOPEXIT_RESTART;
		}
	}
}

-(void)pause
{
	if (subApp != nil)
	{
		if (subApp->run != nil)
		{
			[subApp->run pause];
		}
	}
}

-(void)resume
{
	if (subApp != nil)
	{
		if (subApp->run != nil)
		{
			[subApp->run resume];
		}
	}
}

-(void)setGlobalValue:(int)number withValue:(CValue*)value
{
	if (subApp != nil)
	{
		[subApp setGlobalValueAt:number value:value];
	}
}

-(void)setGlobalString:(int)number withString:(NSString*)value
{
	if (subApp != nil)
	{
		[subApp setGlobalStringAt:number string:value];
	}
}

-(BOOL)isPaused
{
	if (subApp != nil)
	{
		if (subApp->run != nil)
		{
			return subApp->run->rh2PauseCompteur != 0;
		}
	}
	return NO;
}

-(BOOL)appFinished
{
	return subApp == nil;
}

-(BOOL)isVisible
{
	return bVisible;
}

-(BOOL)frameChanged
{
	return level != oldLevel;
}

-(NSString*)getGlobalString:(int)num
{
	if (subApp != nil)
	{
		return [subApp getGlobalStringAt:num];
	}
	return @"";
}

-(CValue*)getGlobalValue:(int)num
{
	if (subApp != nil)
	{
		return [subApp getGlobalValueAt:num];
	}
	return [hoAdRunHeader getTempValue:0];
}

-(int)getFrameNumber
{
	return level + 1;
}

-(void)bringToFront
{
	if (sprite != nil)
	{
		[hoAdRunHeader->rhApp->spriteGen moveSpriteToFront:sprite];
	}
}

// IDrawable
-(void)spriteDraw:(CRenderer*)renderer withSprite:(CSprite*)spr andImageBank:(CImageBank*)bank andX:(int)x andY:(int)y
{
	if (subApp!=nil && subApp->run!=nil && subApp->frame != nil)
	{
		int sW = subApp->gaCxWin;
		int sH = subApp->gaCyWin;
		
		int fW = MIN(subApp->frame->leWidth, subApp->parentApp->gaCxWin);
		int fH = MIN(subApp->frame->leHeight, subApp->parentApp->gaCyWin);
		
		if((odOptions & CCAF_CUSTOMSIZE) != 0)
		{
			fW = MIN(fW, hoImgWidth);
			fH = MIN(fH, hoImgHeight);
		}
		
		//Destroy buffer if window size changes
		if(rtt != nil && (fW != [rtt getWidth] || fH != [rtt getHeight]))
		{
			[rtt release];
			rtt = nil;
		}
		
		//Create the buffer if needed 
		if(rtt == nil)
			rtt = [[CRenderToTexture alloc] initWithWidth:fW andHeight:fH andRunApp:hoAdRunHeader->rhApp];
		
		int rW = [rtt getWidth];
		int rH = [rtt getHeight];
		
		[rtt bindFrameBuffer];
		[subApp->run screen_Update];
		[rtt unbindFrameBuffer];
		
		if ((odOptions & CCAF_STRETCH) != 0)
			[renderer renderStretch:rtt withXDst:x andYDst:y andWDst:sW andHDst:sH andXSrc:0 andYSrc:0 andWSrc:rW andHSrc:rH];
		else
		{
			[renderer useBlending:NO];
			[renderer setClipWithX:x andY:y andWidth:fW andHeight:fH];
			[renderer renderStretch:rtt withXDst:x andYDst:y andWDst:fW andHDst:fH andXSrc:0 andYSrc:0 andWSrc:fW andHSrc:fH];
			[renderer resetClip];
			[renderer useBlending:YES];
		}

	}
}

-(void)spriteKill:(CSprite*)spr
{
}

-(CMask*)spriteGetMask
{
	return nil;
}

@end
