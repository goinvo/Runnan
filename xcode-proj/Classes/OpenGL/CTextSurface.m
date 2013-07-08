//
//  CTextSurface.m
//  RuntimeIPhone
//
//  Created by Anders Riggelsen on 6/18/10.
//  Copyright 2010 Clickteam. All rights reserved.
//

#import "CTextSurface.h"
#import "CBitmap.h"
#import "CFont.h"
#import "CRect.h"
#import "CServices.h"
#import "CImage.h"
#import "CRenderer.h"

@implementation CTextSurface


-(id)initWidthWidth:(int)w andHeight:(int)h
{
	int maxTextureSize = [CRenderer getRenderer]->maxTextureSize;
	
	width = w = clamp(w, 1, maxTextureSize);
	height = h = clamp(h, 1, maxTextureSize);
	textBitmap = [[CBitmap alloc] initWithWidth:w andHeight:h];
	prevText = [[NSString alloc] initWithString:@""];
	prevFlags = 0;
	prevFont = nil;
	textTexture = [[CImage alloc] initWithWidth:w andHeight:h];
	
	rect.top = rect.left = 0;
	rect.right = w;
	rect.bottom = h;
	
	return self;
}

-(void)dealloc
{
	[textTexture release];
	[textBitmap release];
	[prevText release];
	[super dealloc];
}

//Returns YES if the texture needs to be deleted and uploaded again, NO if it can just be reuploaded.
-(BOOL)setSizeWithWidth:(int)w andHeight:(int)h
{
	if(width == w && height == h)
		return NO;

	int maxTextureSize = [CRenderer getRenderer]->maxTextureSize;
	width = w = clamp(w, 1, maxTextureSize);
	height = h = clamp(h, 1, maxTextureSize);
	[textBitmap release];
	textBitmap = [[CBitmap alloc] initWithWidth:w andHeight:h];
	width = w;
	height = h;
	return YES;
}

-(void)manualDrawText:(NSString*)s withFlags:(short)flags andRect:(CRect)rectangle andColor:(int)color andFont:(CFont*)font
{
	[CServices drawText:textBitmap withString:s andFlags:flags andRect:rectangle andColor:color andFont:font andEffect:0 andEffectParam:0];
}

-(void)manualClear:(int)color
{
	[textBitmap fillRect:0 withY:0 andWidth:textBitmap->width andHeight:textBitmap->height andColor:color];
}

-(void)manualUploadTexture
{
	[textTexture loadBitmap:textBitmap];
}


-(void)setText:(NSString*)s withFlags:(short)flags andColor:(int)color andFont:(CFont*)font
{
	BOOL isEqual = [s isEqualToString:prevText];
	if( isEqual && color == prevColor && flags == prevFlags && prevFont == font )
		return;

	[textBitmap fillRect:0 withY:0 andWidth:width andHeight:height andColor:color];
	[prevText release];
	prevText = [[NSString alloc] initWithString:s];
	prevColor = color;
	prevFont = font;
	prevFlags = flags;
	[CServices drawText:textBitmap withString:s andFlags:flags andRect:rect andColor:color andFont:font andEffect:0 andEffectParam:0];
	
	[textTexture loadBitmap:textBitmap];

}

-(void)draw:(CRenderer*)renderer withX:(int)x andY:(int)y andEffect:(int)inkEffect andEffectParam:(int)inkEffectParam;
{
	[renderer renderImage:(ITexture*)textTexture withX:x andY:y andWidth:width andHeight:height andInkEffect:inkEffect andInkEffectParam:inkEffectParam];
}




@end
