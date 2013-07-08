//
//  CTextSurface.h
//  RuntimeIPhone
//
//  Created by Anders Riggelsen on 6/18/10.
//  Copyright 2010 Clickteam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CRect.h"

@class CBitmap;
@class CFont;
@class CImage;
@class CRenderer;


@interface CTextSurface : NSObject
{
@public
	NSString* prevText;
	short prevFlags;
	int prevColor;
	CFont* prevFont;
	CImage* textTexture;
	
	CRect rect;
	int width;
	int height;
	int effect;
	int effectParam;
	CBitmap* textBitmap;
}

-(id)initWidthWidth:(int)w andHeight:(int)h;
-(void)setText:(NSString*)s withFlags:(short)flags andColor:(int)color andFont:(CFont*)font;
-(void)draw:(CRenderer*)renderer withX:(int)x andY:(int)y andEffect:(int)inkEffect andEffectParam:(int)inkEffectParam;

-(BOOL)setSizeWithWidth:(int)w andHeight:(int)h;
-(void)manualDrawText:(NSString*)s withFlags:(short)flags andRect:(CRect)rectangle andColor:(int)color andFont:(CFont*)font;
-(void)manualUploadTexture;
-(void)manualClear:(int)color;

@end
