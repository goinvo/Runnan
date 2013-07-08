//
//  CRenderToTexture.h
//  RuntimeIPhone
//
//  Created by Anders Riggelsen on 8/10/10.
//  Copyright 2010 Clickteam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import "ITexture.h"
#import "CRect.h"

@class CBitmap;
@class CFont;
@class CImage;
@class CRenderer;
@class CRunApp;

@interface CRenderToTexture : NSObject <ITexture>
{
@public
	GLuint framebuffer;
	int width, height;
	int textureWidth, textureHeight;
	GLuint textureID;
	CRunApp* app;
	CRenderer* renderer;
	GLfloat textureCoordinates[8];
	GLint previousBuffer;
	GLint prevWidth;
	GLint prevHeight;
	BOOL isUploaded;
	BOOL useResampling;
}
 
- (id)initWithWidth:(int)w andHeight:(int)h andRunApp:(CRunApp*)runApp;
- (void)dealloc;

- (GLuint)newEmptyTextureWithWidth:(int)w andHeight:(int)h;
- (void)bindFrameBuffer;
- (void)unbindFrameBuffer;

- (void)fillWithColor:(int)color;
- (void)fillWithColor:(int)color andAlpha:(unsigned char)alpha;
- (void)clearColorChannelWithColor:(int)color;
- (void)clearWithAlpha:(float)alpha;
- (void)clearAlphaChannel:(float)alpha;
- (void)copyAlphaFrom:(CRenderToTexture*)rtt;

// ITexture methods
-(int)getHandle;
-(int)uploadTexture;
-(int)deleteTexture;
-(int)getTextureID;
-(int)getWidth;
-(int)getHeight;
-(int)getTextureWidth;
-(int)getTextureHeight;
-(float*)getTextureCoordinates;
-(int)getUsageCount;
-(void)resetCount;
-(void)incrementCount;
-(void)cleanMemory;
-(void)setResampling:(BOOL)resample;
-(BOOL)getResampling;

@end
