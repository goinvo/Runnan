//
//  CRenderToTexture.m
//  RuntimeIPhone
//
//  Created by Anders Riggelsen on 8/10/10.
//  Copyright 2010 Clickteam. All rights reserved.
//

#import "CRenderToTexture.h"
#import "CRunApp.h"
#import "CServices.h"
#import "CRenderer.h"
#import "CRunView.h"

@implementation CRenderToTexture

- (id)initWithWidth:(int)w andHeight:(int)h andRunApp:(CRunApp*)runApp
{
	app = runApp;
	renderer = app->renderer;
	
	width = w;
	height = h;
	
	int nW = 16;
	int nH = 16;
	
	while(nW < w)
		nW *= 2;
	
	while(nH < h)
		nH *= 2;
	
	textureWidth = nW;
	textureHeight = nH;

	textureID = [self newEmptyTextureWithWidth:textureWidth	andHeight:textureHeight];
	
	GLint prevbuff;
	//Generate the render-to-texture framebuffer

	glGetIntegerv(GL_FRAMEBUFFER_BINDING, &prevbuff);
	glGenFramebuffers(1, &framebuffer);
	glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
	glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, textureID, 0);
	int status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
	if(status != GL_FRAMEBUFFER_COMPLETE)
		NSLog(@"Error: Could not create framebuffer!");
	glClearColor(0, 0, 0, 0);
	glClear(GL_COLOR_BUFFER_BIT);
	glBindFramebuffer(GL_FRAMEBUFFER, prevbuff);

	//Update the texture coordinates
	GLfloat texcWidth = w/(GLfloat)textureWidth;
	GLfloat texcHeight = h/(GLfloat)textureHeight;
	
	const GLfloat texCoords[8] = {
        0,			0,
		texcWidth,	0,
        0,			texcHeight,
		texcWidth,	texcHeight
    };
	memcpy(textureCoordinates, texCoords, sizeof(GLfloat)*8);
	
	return self;
}

- (void)dealloc
{
	glDeleteTextures(1, &textureID);
	glDeleteFramebuffers(1, &framebuffer);
	[super dealloc];
}

- (GLuint)newEmptyTextureWithWidth:(int)w andHeight:(int)h
{
	GLuint texId;
	glGenTextures(1, &texId);
	glBindTexture(GL_TEXTURE_2D, texId);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, w, h, 0, GL_RGBA, GL_UNSIGNED_BYTE, NULL);	
	return texId;
}

- (void)bindFrameBuffer
{
	prevWidth = app->renderer->currentWidth;
	prevHeight = app->renderer->currentHeight;

	glGetIntegerv(GL_FRAMEBUFFER_BINDING, &previousBuffer);
	glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);

	renderer->currentWidth = width;
	renderer->currentHeight = height;
	[renderer setProjectionMatrix:0 andY:0 andWidth:width andHeight:height];
	[renderer forgetCachedState];
}

- (void)unbindFrameBuffer
{
	glBindFramebuffer(GL_FRAMEBUFFER, previousBuffer);

	renderer->currentWidth = prevWidth;
	renderer->currentHeight = prevHeight;
	[renderer setProjectionMatrix:renderer->topLeft.x andY:renderer->topLeft.y andWidth:renderer->currentWidth andHeight:renderer->currentHeight];
	[renderer forgetCachedState];
}

- (void)fillWithColor:(int)color
{
	GLint prevbuff;
	glGetIntegerv(GL_FRAMEBUFFER_BINDING, &prevbuff);
	glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
	glClearColor(getR(color)/255.0f, getG(color)/255.0f, getB(color)/255.0f, 1.0f);
	glClear(GL_COLOR_BUFFER_BIT);
	glBindFramebuffer(GL_FRAMEBUFFER, prevbuff);
}

- (void)copyAlphaFrom:(CRenderToTexture*)rtt
{
	GLint prevbuff;
	glGetIntegerv(GL_FRAMEBUFFER_BINDING, &prevbuff);
	glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
	glColorMask(GL_FALSE, GL_FALSE, GL_FALSE, GL_TRUE);
	[renderer renderBlitFull:rtt];
	glColorMask(GL_TRUE, GL_TRUE, GL_TRUE, GL_TRUE);
	glBindFramebuffer(GL_FRAMEBUFFER, prevbuff);
}


- (void)clearColorChannelWithColor:(int)color
{
	GLint prevbuff;
	glGetIntegerv(GL_FRAMEBUFFER_BINDING, &prevbuff);
	glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
	
	glColorMask(GL_TRUE, GL_TRUE, GL_TRUE, GL_FALSE);
	glClearColor(getR(color)/255.0f, getG(color)/255.0f, getB(color)/255.0f, 1.0f);
	glClear(GL_COLOR_BUFFER_BIT);
	glColorMask(GL_TRUE, GL_TRUE, GL_TRUE, GL_TRUE);
	
	glBindFramebuffer(GL_FRAMEBUFFER, prevbuff);
}







- (void)fillWithColor:(int)color andAlpha:(unsigned char)alpha
{
	GLint prevbuff;
	glGetIntegerv(GL_FRAMEBUFFER_BINDING, &prevbuff);
	glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
	glClearColor(getR(color)/255.0f, getG(color)/255.0f, getB(color)/255.0f, alpha/255.0f);
	glClear(GL_COLOR_BUFFER_BIT);
	glBindFramebuffer(GL_FRAMEBUFFER, prevbuff);
}

//Clears the texture and sets the alpha to the specified value
-(void) clearWithAlpha:(float)alpha
{
	GLint prevbuff;
	glGetIntegerv(GL_FRAMEBUFFER_BINDING, &prevbuff);
	glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
	glClearColor(0,0,0,alpha);
	glClear(GL_COLOR_BUFFER_BIT);
	glBindFramebuffer(GL_FRAMEBUFFER, prevbuff);
}

//Sets the contents of the alpha channel without modifying the contents of the texture
-(void) clearAlphaChannel:(float)alpha
{
	GLint prevbuff;
	glGetIntegerv(GL_FRAMEBUFFER_BINDING, &prevbuff);
	glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
	glColorMask(false, false, false, true);
	glClearColor(0,0,0,alpha);
	glClear(GL_COLOR_BUFFER_BIT);
	glColorMask(true, true, true, true);
	glBindFramebuffer(GL_FRAMEBUFFER, prevbuff);
} 


-(int)uploadTexture
{
	// No need to upload the texture as a rendertarget in itself is a graphics card only texture.
	isUploaded = YES;
	return 0;
}

-(int)deleteTexture
{
	// No deletion of the texture. Waits to the object is released.
	isUploaded = NO;
	return 0;
}

-(int)getHandle
{
	return -1;
}

-(int)getTextureID
{
	return textureID;
}

-(int)getWidth
{
	return width;
}

-(int)getHeight
{
	return height;
}

-(int)getTextureWidth
{
	return textureWidth;
}


-(int)getTextureHeight
{
	return textureHeight;
}

-(GLfloat*)getTextureCoordinates
{
	return textureCoordinates;
}

-(int)getUsageCount{return 1;}
-(void)resetCount{}
-(void)incrementCount{}

//Mipmaps not supported by RenderToTextures as it could
//cause massive slowdowns for often updated textures
-(void)generateMipMaps
{
}

-(void)cleanMemory
{
	//No resources to clean (done in dealloc)
}

-(void)setResampling:(BOOL)resample
{
	useResampling = resample;
}

-(BOOL)getResampling
{
	return useResampling;
}

@end
