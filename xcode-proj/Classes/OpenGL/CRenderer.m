//
//  CRenderer.m
//  RuntimeIPhone
//
//  Created by Anders Riggelsen on 1/14/11.
//  Copyright 2011 Clickteam. All rights reserved.
//

#import "CRenderer.h"

#import "ITexture.h"
#import "CRenderToTexture.h"
#import "Maths.h"
#import "CServices.h"
#import "CShader.h"
#import "CRunView.h"
#import "CRunApp.h"
#import "CArrayList.h"
#import "CRunFrame.h"

@implementation CRenderer

static CRenderer* sRenderer;

- (id)initWithView:(CRunView*)runView
{
    if ((self = [super init]))
    {
        context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
        if (!context || ![EAGLContext setCurrentContext:context] || ![self loadShaders])
        {
            [self release];
            return nil;
        }

		view = runView;
		windowSize = CGSizeMake(view->appRect.size.width, view->appRect.size.height);
		topLeft = CGPointMake(0, 0);
		texturesToRemove = [[CArrayList alloc] init];
		[self forgetCachedState];
		sRenderer = self;

        // Create default framebuffer object. The backing will be allocated for the current layer in -resizeFromLayer
        glGenFramebuffers(1, &defaultFramebuffer);
        glGenRenderbuffers(1, &colorRenderbuffer);
        glBindFramebuffer(GL_FRAMEBUFFER, defaultFramebuffer);
        glBindRenderbuffer(GL_RENDERBUFFER, colorRenderbuffer);
        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, colorRenderbuffer);

		glEnable(GL_BLEND);

		useClipping = NO;
		clipLeft = clipTop = clipRight = clipBottom = 0;

		usedTextures = [[NSMutableSet alloc] init];
		[CRenderer checkForError];

		glGetIntegerv(GL_MAX_TEXTURE_SIZE, &maxTextureSize);
	}

    return self;
}

+(CRenderer*)getRenderer
{
	return sRenderer;
}

-(void)dealloc
{
	[self destroyFrameBuffers];
	[defaultShader release];
	[gradientShader release];
	[gradientEllipseShader release];
	[defaultEllipseShader release];
	[texturesToRemove release];

    // Tear down context
    if ([EAGLContext currentContext] == context)
        [EAGLContext setCurrentContext:nil];
	
    [context release];
    context = nil;
    [super dealloc];
}

-(void)destroyFrameBuffers
{
    if (defaultFramebuffer)
    {
        glDeleteFramebuffersOES(1, &defaultFramebuffer);
        defaultFramebuffer = 0;
    }
    if (colorRenderbuffer)
    {
        glDeleteRenderbuffersOES(1, &colorRenderbuffer);
        colorRenderbuffer = 0;
    }
}

// Clear the frame, ready for rendering
- (void)clear:(float)red green:(float)green blue:(float)blue;
{
    glClearColor(red, green, blue, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
}

-(void)clear
{
	float r,g,b;
	int background;
	if(view->pRunApp->frame != nil)
		background = inverseOpaqueColor(view->pRunApp->frame->leBackground);
	else
		background = inverseOpaqueColor(view->pRunApp->gaBorderColour);
	
	r = ((background >> 16) & 0xFF)/255.0f;
	g = ((background >> 8) & 0xFF)/255.0f;
	b = (background & 0xFF)/255.0f;
	[self clear:r green:g blue:b];
}

-(void)clearWithRunApp:(CRunApp*)app
{
	float r,g,b;
	int background;
	if(app->frame != nil)
		background = inverseOpaqueColor(app->frame->leBackground);
	else
		background = inverseOpaqueColor(app->gaBorderColour);
	
	r = ((background >> 16) & 0xFF)/255.0f;
	g = ((background >> 8) & 0xFF)/255.0f;
	b = (background & 0xFF)/255.0f;
	[self clear:r green:g blue:b];
}


- (void)swapBuffers
{
    glBindRenderbuffer(GL_RENDERBUFFER, colorRenderbuffer);
    [context presentRenderbuffer:GL_RENDERBUFFER];
}

-(void)flush
{
	glFlush();
}

+(void)checkForError
{
	GLenum err = glGetError();
	if (GL_NO_ERROR != err)
		NSLog(@"Got OpenGL Error: %i", err);
}

-(void)forgetCachedState
{
	currentTextureID = -1;
	currentBlendEquationA = currentBlendEquationB = currentBlendFunctionA = currentBlendFunctionB = -1;
	cR = cG = cB = cA = 1.0f;
}

//Renders the given image with the previously defined shaders and settings.
-(void)renderSimpleImage:(int)x andY:(int)y andWidth:(int)w andHeight:(int)h
{
	GLfloat squareVertices[] = {
        x,		y,
		x+w,	y,
        x,		y+h,
		x+w,	y+h
    };
	glVertexAttribPointer(ATTRIB_VERTEX, 2, GL_FLOAT, GL_FALSE, 0, squareVertices);
	glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
}

//The most common image rendering method.
- (void)renderImage:(ITexture*)image withX:(int)x andY:(int)y andWidth:(int)w andHeight:(int)h andInkEffect:(int)inkEffect andInkEffectParam:(int)inkEffectParam
{	
	//Make sure that the image exists on the device (if it is already uploaded, this call is ignored)
	[self uploadTexture:image];
	
	x+=originX;
	y+=originY;
	
	GLfloat squareVertices[] = {
        x,		y,
		x+w,	y,
        x,		y+h,
		x+w,	y+h
    };
	
	// Use shader program
	[self setInkEffect:inkEffect andParam:inkEffectParam andShader:nil];
	
	//Update shader information
	[currentShader setTexture:image];
	glVertexAttribPointer(ATTRIB_VERTEX, 2, GL_FLOAT, GL_FALSE, 0, squareVertices);
	glVertexAttribPointer(ATTRIB_TEXCOORD, 2, GL_FLOAT, GL_FALSE, 0, [image getTextureCoordinates]);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
}

//The most common image rendering method.
- (void)renderScaledRotatedImage:(ITexture*)image withAngle:(int)angle andScaleX:(float)sX andScaleY:(float)sY andHotSpotX:(int)hX andHotSpotY:(int)hY andX:(int)x andY:(int)y andWidth:(int)w andHeight:(int)h andInkEffect:(int)inkEffect andInkEffectParam:(int)inkEffectParam
{	
	//Avoid costly rotation maths
	if(angle == 0 && sX == 1.0 && sY == 1.0)
	{
		[self renderImage:image withX:x-hX andY:y-hY andWidth:w andHeight:h andInkEffect:inkEffect andInkEffectParam:inkEffectParam];
		return;
	}
	
	x+=originX;
	y+=originY;
	
	//Make sure that the image exists on the device (if it is already uploaded, this call is ignored)
	[self uploadTexture:image];
	
	//Optimization for scaled images (Generate mip-maps at the cost of extra memory)
	if(sX <= 0.5f && sY <= 0.5f)
		[image generateMipMaps];
	
	float radian = 3.1415926535*angle/180.0;
	float cosA = cosf(radian);
	float sinA = sinf(radian);
	
	//Scaled points
	float sp[] = {
		-hX*sX,		-hY*sY,
		(-hX+w)*sX,	-hY*sY,
		-hX*sX,		(-hY+h)*sY,
		(-hX+w)*sX,	(-hY+h)*sY
	};
	
	//Rotated points
	float rotatedPoints[] = {
		sp[0]*cosA+sp[1]*sinA+x,	-sp[0]*sinA+sp[1]*cosA+y,
		sp[2]*cosA+sp[3]*sinA+x,	-sp[2]*sinA+sp[3]*cosA+y,
		sp[4]*cosA+sp[5]*sinA+x,	-sp[4]*sinA+sp[5]*cosA+y,
		sp[6]*cosA+sp[7]*sinA+x,	-sp[6]*sinA+sp[7]*cosA+y
	};
	
	[self setInkEffect:inkEffect andParam:inkEffectParam andShader:nil];
	[currentShader setTexture:image];
	glVertexAttribPointer(ATTRIB_VERTEX, 2, GL_FLOAT, GL_FALSE, 0, rotatedPoints);
	glVertexAttribPointer(ATTRIB_TEXCOORD, 2, GL_FLOAT, GL_FALSE, 0, [image getTextureCoordinates]);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
}

//Render a scaled/rotated image with a scrolling offset of the image
-(void)renderScaledRotatedImage:(ITexture*)image withAngle:(float)angle andScaleX:(float)sX andScaleY:(float)sY andHotSpotX:(float)hX andHotSpotY:(float)hY andX:(float)x andY:(float)y andWidth:(float)w andHeight:(float)h andInkEffect:(int)inkEffect andInkEffectParam:(int)inkEffectParam andOffsetX:(float)offsetX andOffsetY:(float)offsetY andFlippedX:(BOOL)flipX andFlippedY:(BOOL)flipY usingWrap:(BOOL)wrap
{
	if(offsetX == 0 && offsetY == 0 && !flipX && !flipY)
	{
		[self renderScaledRotatedImage:image withAngle:angle andScaleX:sX andScaleY:sY andHotSpotX:hX andHotSpotY:hY andX:x andY:y andWidth:w andHeight:h andInkEffect:inkEffect andInkEffectParam:inkEffectParam];
		return;
	}
	//Make sure that the image exists on the device (if it is already uploaded, this call is ignored)
	[self uploadTexture:image];
	
	//Optimization for scaled images (Generate mip-maps at the cost of extra memory)
	if(sX <= 0.5f && sY <= 0.5f)
		[image generateMipMaps];

	float iw = [image getWidth];
	float ih = [image getHeight];
	float tw = [image getTextureWidth];
	float th = [image getTextureHeight];
	float fwidth = w/tw;
	float fheight = h/th;
	
	[self setInkEffect:inkEffect andParam:inkEffectParam andShader:nil];
	[currentShader setTexture:image];

	//Allow the texture to repeat when reading outside the border
	if(wrap && tw == w && th == h)
	{
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
	}
	else
	{
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
	}
	
	float radian = 3.1415926535*angle/180.0;
	float cosA = cosf(radian);
	float sinA = sinf(radian);
	float nHx, nHy, nW, nH;
	
	GLfloat itc[8], itcO[8];
	memcpy(itcO, [image getTextureCoordinates], sizeof(GLfloat)*8);
	
	//Offset should not scale so the inverse transformation is applied
	offsetX /= sX;
	offsetY /= sY;
	
	if(wrap == NO)
	{
		memcpy(itc, itcO, sizeof(GLfloat)*8);
		nHx = hX - maxd(offsetX, 0);
		nHy = hY - maxd(offsetY, 0);
		nW = clampd(w - absDouble(offsetX), 0, w);
		nH = clampd(h - absDouble(offsetY), 0, h);
		
		if(offsetX > 0)
			itc[2] = itc[6] = nW/tw;
		if(offsetY > 0)
			itc[5] = itc[7] = nH/th;
				
		if(offsetX < 0)
			itc[0] = itc[4] = (0-offsetX)/tw;
		if(offsetY < 0)
			itc[1] = itc[3] = (0-offsetY)/th;
		
		[self renderSubPart:itc withCosA:cosA andSinA:sinA andScaleX:sX andScaleY:sY andHotSpotX:nHx andHotSpotY:nHy andX:x andY:y andWidth:nW andHeight:nH andOffsetX:offsetX andOffsetY:offsetY andFlippedX:flipX andFlippedY:flipY andFWidth:fwidth andFHeight:fheight];
		return;
	}
	
	//WRAP
	offsetX = fmod(offsetX, iw);
	offsetY = fmod(offsetY, ih);
	if(offsetX < 0) offsetX += iw;
	if(offsetY < 0) offsetY += ih;
	
	
	//X OFFSET
	memcpy(itc, itcO, sizeof(GLfloat)*8);
	nHx = hX - offsetX;
	nHy = hY - offsetY;	
	nW = w - offsetX;
	nH = h - offsetY;
	itc[2] = itc[6] = nW/tw;
	itc[5] = itc[7] = nH/th;
	
	[self renderSubPart:itc withCosA:cosA andSinA:sinA andScaleX:sX andScaleY:sY andHotSpotX:nHx andHotSpotY:nHy andX:x andY:y andWidth:nW andHeight:nH andOffsetX:offsetX andOffsetY:offsetY andFlippedX:flipX andFlippedY:flipY andFWidth:fwidth andFHeight:fheight];
	
	memcpy(itc, itcO, sizeof(GLfloat)*8);
	nHx = hX;
	nHy = hY - offsetY;	
	nW = offsetX;
	nH = h - offsetY;
	itc[0] = itc[4] = (w-offsetX)/tw;
	itc[5] = itc[7] = nH/th;
	
	[self renderSubPart:itc withCosA:cosA andSinA:sinA andScaleX:sX andScaleY:sY andHotSpotX:nHx andHotSpotY:nHy andX:x andY:y andWidth:nW andHeight:nH andOffsetX:offsetX andOffsetY:offsetY andFlippedX:flipX andFlippedY:flipY andFWidth:fwidth andFHeight:fheight];

	//Y OFFSET
	memcpy(itc, itcO, sizeof(GLfloat)*8);
	nHx = hX - offsetX;
	nHy = hY;	
	nW = w - offsetX;
	nH = offsetY;
	itc[2] = itc[6] = nW/tw;
	itc[1] = itc[3] = (h-offsetY)/th;
	
	[self renderSubPart:itc withCosA:cosA andSinA:sinA andScaleX:sX andScaleY:sY andHotSpotX:nHx andHotSpotY:nHy andX:x andY:y andWidth:nW andHeight:nH andOffsetX:offsetX andOffsetY:offsetY andFlippedX:flipX andFlippedY:flipY andFWidth:fwidth andFHeight:fheight];
	
	memcpy(itc, itcO, sizeof(GLfloat)*8);
	nHx = hX;
	nHy = hY;	
	nW = offsetX;
	nH = offsetY;
	itc[0] = itc[4] = (w-offsetX)/tw;
	itc[1] = itc[3] = (h-offsetY)/th;
	
	[self renderSubPart:(GLfloat*)&itc withCosA:cosA andSinA:sinA andScaleX:sX andScaleY:sY andHotSpotX:nHx andHotSpotY:nHy andX:x andY:y andWidth:nW andHeight:nH andOffsetX:offsetX andOffsetY:offsetY andFlippedX:flipX andFlippedY:flipY andFWidth:fwidth andFHeight:fheight];
}

-(void)renderSubPart:(GLfloat*)itc withCosA:(float)cosA andSinA:(float)sinA andScaleX:(float)sX andScaleY:(float)sY andHotSpotX:(float)hX andHotSpotY:(float)hY andX:(float)x andY:(float)y andWidth:(float)w andHeight:(float)h andOffsetX:(float)offsetX andOffsetY:(float)offsetY  andFlippedX:(BOOL)flipX andFlippedY:(BOOL)flipY andFWidth:(float)fwidth andFHeight:(float)fheight
{
	//Scaled points
	float sp[] = {
		-hX*sX,		-hY*sY,
		(-hX+w)*sX,	-hY*sY,
		-hX*sX,		(-hY+h)*sY,
		(-hX+w)*sX,	(-hY+h)*sY
	};
	
	//Rotated points
	float rotatedPoints[] = {
		sp[0]*cosA+sp[1]*sinA+x,	-sp[0]*sinA+sp[1]*cosA+y,
		sp[2]*cosA+sp[3]*sinA+x,	-sp[2]*sinA+sp[3]*cosA+y,
		sp[4]*cosA+sp[5]*sinA+x,	-sp[4]*sinA+sp[5]*cosA+y,
		sp[6]*cosA+sp[7]*sinA+x,	-sp[6]*sinA+sp[7]*cosA+y
	};

	//Flipping the texture coordinates
	if(flipX)
	{
		itc[0] = fwidth-itc[0];
		itc[2] = fwidth-itc[2];
		itc[4] = fwidth-itc[4];
		itc[6] = fwidth-itc[6];
	}
	if(flipY)
	{
		itc[1] = fheight-itc[1];
		itc[3] = fheight-itc[3];
		itc[5] = fheight-itc[5];
		itc[7] = fheight-itc[7];
	}

	glVertexAttribPointer(ATTRIB_VERTEX, 2, GL_FLOAT, GL_FALSE, 0, rotatedPoints);
	glVertexAttribPointer(ATTRIB_TEXCOORD, 2, GL_FLOAT, GL_FALSE, 0, itc);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
}



//Renders a tiled picture with clipping.
-(void)renderPattern:(ITexture*)image withX:(int)x andY:(int)y andWidth:(int)w andHeight:(int)h andInkEffect:(int)inkEffect andInkEffectParam:(int)inkEffectParam
{
	//Limit the amount of repetitions to what only is visible
	int startX = x;
	int startY = y;
	int endX = x+w;
	int endY = y+h;
	
	//Update shader information
	[self uploadTexture:image];
	[currentShader setTexture:image];
	[self setInkEffect:inkEffect andParam:inkEffectParam andShader:nil];
	
	int iw = [image getWidth];
	int ih = [image getHeight];
	int tw = [image getTextureWidth];
	int th = [image getTextureHeight];
	
	if(startX < -iw)
		startX %= iw;
	
	if(startY < -ih)
		startY %= ih;
	
	if(endX > currentWidth)
		endX = (endX-currentWidth) % iw + currentWidth;
	
	if(endY > currentHeight)
		endY = (endY-currentHeight) % ih + currentHeight;
	
	w = endX - startX;
	h = endY - startY;
	
	int wMiW = w % iw;
	int hMiH = h % ih;
	
	int lastX = endX - wMiW;
	int lastY = endY - hMiH;
	
	BOOL xDivisible = (wMiW == 0);
	BOOL yDivisible = (hMiH == 0);
	float itc[8];
	float* otc = [image getTextureCoordinates];
	float rx, ry;
	
	BOOL recopyTexCoords = YES;
	BOOL setTexCoords = YES;
	glVertexAttribPointer(ATTRIB_TEXCOORD, 2, GL_FLOAT, GL_FALSE, 0, otc);
		
	for(int cY=startY; cY<endY; cY+=ih)
	{
		for(int cX=startX; cX<endX; cX+=iw)
		{
			int drawWidth = iw;
			int drawHeight = ih;
			
			if(recopyTexCoords){
				memcpy(itc, otc, sizeof(float)*8);
				recopyTexCoords = NO;
			}

			if(cX==lastX && !xDivisible)
			{
				drawWidth = wMiW;
				rx = drawWidth/(float)tw;
				itc[2] = rx;	//<w>,0
				itc[6] = rx;	//<w>,h
				setTexCoords = recopyTexCoords = YES;
			}
			
			if(cY==lastY && !yDivisible)
			{
				drawHeight = hMiH;
				ry = drawHeight/(float)th;
				itc[5] = ry;	//0,<h>
				itc[7] = ry;	//w,<h>
				setTexCoords = recopyTexCoords = YES;
			}
			if(setTexCoords){
				glVertexAttribPointer(ATTRIB_TEXCOORD, 2, GL_FLOAT, GL_FALSE, 0, itc);
				setTexCoords = NO;
			}
			[self renderSimpleImage:cX andY:cY andWidth:drawWidth andHeight:drawHeight];
		}
	}
}

-(void)renderSolidColor:(int)color withX:(int)x andY:(int)y andWidth:(int)w andHeight:(int)h andInkEffect:(int)inkEffect andInkEffectParam:(int)inkEffectParam
{
	color |= 0xFF000000;
	unsigned int colors[] = {color, color, color, color};
	[self renderGradient:(unsigned char *)colors withX:x andY:y andWidth:w andHeight:h andInkEffect:inkEffect andInkEffectParam:inkEffectParam];
}

- (void)setOriginX:(int)x andY:(int)y
{
	originX = x;
	originY = y;
}

//Blit wrappers for the transition system
- (void)renderBlitFull:(CRenderToTexture*)source
{
	[self renderStretch:source withXDst:0 andYDst:0 andWDst:[source getWidth] andHDst:[source getHeight] andXSrc:0 andYSrc:0 andWSrc:[source getWidth] andHSrc:[source getHeight]];
}

- (void)renderBlit:(CRenderToTexture*)source withXDst:(int)xDst andYDst:(int)yDst andXSrc:(int)xSrc andYSrc:(int)ySrc andWidth:(int)width andHeight:(int)height
{
	[self renderStretch:source withXDst:xDst andYDst:yDst andWDst:width andHDst:height andXSrc:xSrc andYSrc:ySrc andWSrc:width andHSrc:height];
}

- (void)renderFade:(CRenderToTexture*)source withCoef:(int)alpha
{
	[self renderStretch:source withXDst:0 andYDst:0 andWDst:[source getWidth] andHDst:[source getHeight] andXSrc:0 andYSrc:0 andWSrc:[source getWidth] andHSrc:[source getHeight] andInkEffect:1 andInkEffectParam:alpha/2];
}

- (void)renderStretch:(CRenderToTexture*)source withXDst:(int)xDst andYDst:(int)yDst andWDst:(int)wDst andHDst:(int)hDst andXSrc:(int)xSrc andYSrc:(int)ySrc andWSrc:(int)wSrc andHSrc:(int)hSrc
{
	[self renderStretch:source withXDst:xDst andYDst:yDst andWDst:wDst andHDst:hDst andXSrc:xSrc andYSrc:ySrc andWSrc:wSrc andHSrc:hSrc andInkEffect:0 andInkEffectParam:0];
}

- (void)renderStretch:(CRenderToTexture*)source withXDst:(int)xDst andYDst:(int)yDst andWDst:(int)wDst andHDst:(int)hDst andXSrc:(int)xSrc andYSrc:(int)ySrc andWSrc:(int)wSrc andHSrc:(int)hSrc andInkEffect:(int)inkEffect andInkEffectParam:(int)inkEffectParam
{
	[self uploadTexture:(ITexture*)source];
	
	GLint currentbuffer;
	glGetIntegerv(GL_FRAMEBUFFER_BINDING, &currentbuffer);
	
	if(currentbuffer == defaultFramebuffer)
	{
		xDst += originX;
		yDst += originY;
	}
	
	GLfloat squareVertices[] = {
        xDst,		yDst,
		xDst+wDst,	yDst,
        xDst,		yDst+hDst,
		xDst+wDst,	yDst+hDst
    };
	
	GLfloat tWidth = [source getTextureWidth];
	GLfloat tHeight = [source getTextureHeight];
	int iHeight = [source getHeight];
	
	//Coordinates are flipped here
	GLfloat leftX = xSrc/tWidth;
	GLfloat rightX = (xSrc+wSrc)/tWidth;
	GLfloat topY = (iHeight-ySrc)/tHeight;
	GLfloat bottomY = (iHeight-(ySrc+hSrc))/tHeight;
	
	GLfloat texCoord [] = 
	{
		leftX,	topY,
		rightX,	topY,
		leftX,	bottomY,
		rightX, bottomY
	};
	
	[self setInkEffect:inkEffect andParam:inkEffectParam andShader:nil];
	[currentShader setTexture:(ITexture*)source];
	glVertexAttribPointer(ATTRIB_VERTEX, 2, GL_FLOAT, GL_FALSE, 0, squareVertices);
	glVertexAttribPointer(ATTRIB_TEXCOORD, 2, GL_FLOAT, GL_FALSE, 0, texCoord);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
}

- (void)useBlending:(bool)useBlending
{
	if(useBlending)
		glEnable(GL_BLEND);
	else
		glDisable(GL_BLEND);
}

-(void)uploadTexture:(ITexture*)texture
{
	[texture incrementCount];
	
	if([texture getTextureID] != -1)
		return;
	
	textureUsage += [texture uploadTexture];
	
	//Add texture to set of used textures if it has a valid image-bank handle
	if([texture getHandle] != -1 && [usedTextures containsObject:texture] == NO)
		[usedTextures addObject:texture];
}

-(void)removeTexture:(ITexture*)texture andCleanMemory:(BOOL)cleanMemory
{
	textureUsage -= [texture deleteTexture];
    if(cleanMemory)
        [texture cleanMemory];
	
	if([usedTextures containsObject:texture] == YES)
    {
		[usedTextures removeObject:texture];	
    }
}

-(void)updateViewport
{
    glViewport(0, 0, backingWidth, backingHeight);
}

-(void)cleanMemory
{
	NSEnumerator* enumerator = [usedTextures objectEnumerator];
	id value;
	while ((value = [enumerator nextObject]))
	{
		ITexture* texture = (ITexture*)value;
		textureUsage -= [texture deleteTexture];
		[texture resetCount];
	}
	[usedTextures removeAllObjects];
}

//Generates a list of all unused textures over a timespan of 10 seconds
//The renderer will release these textures spread out over the next 10 seconds for minimal speed impact
-(void)cleanUnused
{
	//NSLog(@"Texture usage: %f MB", (textureUsage/1024.0f)/1024.0f);
	
	//Clean prune list just to be sure no textures are added twice:
	[texturesToRemove clear];
	
	NSEnumerator* enumerator = [usedTextures objectEnumerator];
	id value;
	while ((value = [enumerator nextObject]))
	{
		ITexture* texture = (ITexture*)value;
		if([texture getUsageCount] == 0)
			[texturesToRemove add:(void*)texture];
		[texture resetCount];
	}
	//NSLog(@"Generated clean list of %i entries", [texturesToRemove size]);
}

//Remove one unused texture at a time.
-(void)pruneTexture
{
	int index = [texturesToRemove size]-1;
	if(index >= 0)
	{
		ITexture* texture = (ITexture*)[texturesToRemove get:index];
		//Recheck that the texture wasn't used
		if([texture getUsageCount] == 0)
			[self removeTexture:texture andCleanMemory:YES];
		
		[texturesToRemove removeIndex:index];
		//NSLog(@"Pruned texture %@", texture);
	}
}

-(void)clearPruneList
{
	[texturesToRemove clear];
}

-(void)setClipWithX:(int)x andY:(int)y  andWidth:(int)w  andHeight:(int)h
{
	w = MIN(currentWidth,w);
	h = MIN(currentHeight,h);
	x = MAX(0,x);
	y = MAX(0,y);
	
	glEnable(GL_SCISSOR_TEST);
	glScissor(x, backingHeight-y-h, w, h);
}

-(void)resetClip
{
	glDisable(GL_SCISSOR_TEST);
}

-(void)setBlendEquation:(GLenum)equation
{
	if(currentBlendEquationA != equation)
	{
		currentBlendEquationA = equation;
		glBlendEquation(equation);
	}
}

-(void)setBlendEquationSeperate:(GLenum)equationA other:(GLenum)equationB
{
	if(currentBlendEquationA != equationA || equationB != currentBlendEquationB)
	{
		currentBlendEquationA = equationA;
		currentBlendEquationB = equationB;
		glBlendEquationSeparate(equationA, equationB);
	}
}

-(void)setBlendFunction:(GLenum)sFactor dFactor:(GLenum)dFactor
{
	if(currentBlendFunctionA != sFactor || currentBlendFunctionB != dFactor)
	{
		currentBlendFunctionA = sFactor;
		currentBlendFunctionB = dFactor;
		glBlendFunc(sFactor, dFactor);
	}
}

-(void)setBlendColorRed:(float)red green:(float)green blue:(float)blue alpha:(float)alpha
{
	if(cA != alpha || cR != red || cG != green || cB != blue)
	{
		glColor4f(red, green, blue, alpha);
		cR = red;
		cG = green;
		cB = blue;
		cA = alpha;
	}
}

-(void)bindRenderBuffer
{
	[EAGLContext setCurrentContext:context];
	glBindFramebuffer(GL_FRAMEBUFFER, defaultFramebuffer);
}

- (void)setCurrentShader:(CShader*)shader
{
	if(shader == currentShader)
		return;

	currentShader = shader;
	[currentShader bindShader];
	[currentShader setProjectionMatrix:ortho];
}

-(void)setInkEffect:(int)effect andParam:(int)effectParam andShader:(CShader*)shader
{
	bool useBasic = YES;
	CShader* useShader = defaultShader;
	unsigned int rgbaCoeff;
	float red = 1.0f, green = 1.0f, blue = 1.0f, alpha = 1.0f;

	//Ignores shader effects
	if((effect & BOP_MASK)==BOP_EFFECTEX)
	{
		effect = BOP_BLEND;
		rgbaCoeff = effectParam;
		alpha = (rgbaCoeff >> 24)/255.0f;
	}
	//Extracts the RGB Coefficient
	else if((effect & BOP_RGBAFILTER) != 0)
	{
		effect = MAX(effect & BOP_MASK, BOP_BLEND);
		useBasic = NO;

		rgbaCoeff = effectParam;
		red = ((rgbaCoeff>>16) & 0xFF) / 255.0f;
		green = ((rgbaCoeff>>8) & 0xFF) / 255.0f;
		blue = (rgbaCoeff & 0xFF) / 255.0f;
		alpha = (rgbaCoeff >> 24)/255.0f;
	}
	//Uses the generic INK-effect
	else
	{
		effect &= BOP_MASK;
		if(effectParam == -1)
			alpha = 1.0f;
		else
			alpha = 1.0f - effectParam/128.0f;
	}

	// Use shader program
	if(shader != nil)
	{
		useShader = shader;
		effect = MAX(effect & BOP_MASK, BOP_BLEND);
	}

	[self setCurrentShader:useShader];
	[currentShader setInkEffect:effect andParam:alpha];
	[currentShader setRGBCoeff:red andGreen:green andBlue:blue];
}

-(void)setProjectionMatrix:(int)x andY:(int)y andWidth:(int)width andHeight:(int)height
{
	float left = x;
	float right = x+width;
	float top = y;
	float bottom = y+height;

	float far = 1.0f;
	float near = -1.0f;

	float tx = - (right+left)/(right-left);
	float ty = - (top+bottom)/(top-bottom);
	float tz = - (far+near)/(far-near);

	float orthoMatrix[16] = {
		2/(right-left),		0,				0,				tx,
		0,					2/(top-bottom),	0,				ty,
		0,					0,				-2/(far-near),	tz,
		0,					0,				0,				1
	};

	memcpy(ortho, orthoMatrix, 16*sizeof(float));
	[currentShader setProjectionMatrix:ortho];
	glViewport(x, y, width, height);
}


-(void)renderLineWithXA:(int)xA andYA:(int)yA andXB:(int)xB andYB:(int)yB andColor:(int)color andThickness:(int)thickness
{	
	color = inverseOpaqueColor(color);
	GLfloat points[] = {xA,yA, xB,yB};
	int colors[] = {color, color};

	//Update shader information
	[self setInkEffect:0 andParam:0 andShader:gradientShader];
	glVertexAttribPointer(ATTRIB_VERTEX, 2, GL_FLOAT, GL_FALSE, 0, points);
	glVertexAttribPointer(ATTRIB_COLOR, 4, GL_UNSIGNED_BYTE, GL_TRUE, 0, (unsigned char*)colors);

    // Draw
	glLineWidth(thickness);
    glDrawArrays(GL_LINES, 0, 2);
}

-(void)renderGradientEllipse:(unsigned char*)colors withX:(int)x andY:(int)y andWidth:(int)w andHeight:(int)h andInkEffect:(int)inkEffect andInkEffectParam:(int)inkEffectParam
{
	GLfloat squareVertices[] = {
        x,		y,
		x+w,	y,
        x,		y+h,
		x+w,	y+h
    };

	//Update shader information
	[self setInkEffect:inkEffect andParam:inkEffectParam andShader:gradientEllipseShader];
	glVertexAttribPointer(ATTRIB_VERTEX, 2, GL_FLOAT, GL_FALSE, 0, squareVertices);
	[currentShader setEllipseCenterX:x+w/2 andY:y+h/2 withRadiusA:w/2 andRadiusB:h/2];
	glVertexAttribPointer(ATTRIB_COLOR, 4, GL_UNSIGNED_BYTE, GL_TRUE, 0, (unsigned char*)colors);

	// Draw
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
}

//Renders a tiled picture with clipping.
-(void)renderPatternEllipse:(ITexture*)image withX:(int)x andY:(int)y andWidth:(int)w andHeight:(int)h andInkEffect:(int)inkEffect andInkEffectParam:(int)inkEffectParam
{
	//Limit the amount of repetitions to what only is visible
	int startX = x;
	int startY = y;
	int endX = x+w;
	int endY = y+h;

	int iw = [image getWidth];
	int ih = [image getHeight];

	if(startX < -iw)
		startX %= iw;

	if(startY < -ih)
		startY %= ih;

	if(endX > backingWidth)
		endX = (endX-backingWidth) % iw + backingWidth;

	if(endY > backingHeight)
		endY = (endY-backingHeight) % ih + backingHeight;

	//Clipping is not really needed here, but can improve performance on large mosaic tiles
	[self setClipWithX:startX andY:startY andWidth:endX andHeight:endY];
	[self uploadTexture:image];

	//Update shader information
	[self setInkEffect:inkEffect andParam:inkEffectParam andShader:defaultEllipseShader];
	[currentShader setTexture:image];
	glVertexAttribPointer(ATTRIB_TEXCOORD, 2, GL_FLOAT, GL_FALSE, 0, [image getTextureCoordinates]);
	[currentShader setEllipseCenterX:x+w/2 andY:y+h/2 withRadiusA:w/2 andRadiusB:h/2];

	for(int cY=startY; cY<endY; cY+=ih)
		for(int cX=startX; cX<endX; cX+=iw)
			[self renderSimpleImage:cX andY:cY andWidth:iw andHeight:ih];

	[self resetClip];
}

-(void)renderGradient:(unsigned char*)colors withX:(int)x andY:(int)y andWidth:(int)w andHeight:(int)h andInkEffect:(int)inkEffect andInkEffectParam:(int)inkEffectParam
{
	GLfloat squareVertices[] = {
        x,		y,
		x+w,	y,
        x,		y+h,
		x+w,	y+h
    };

	//Update shader information
	[self setInkEffect:inkEffect andParam:inkEffectParam andShader:gradientShader];
	glVertexAttribPointer(ATTRIB_VERTEX, 2, GL_FLOAT, GL_FALSE, 0, squareVertices);
	glVertexAttribPointer(ATTRIB_COLOR, 4, GL_UNSIGNED_BYTE, GL_TRUE, 0, (unsigned char*)colors);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
}

- (BOOL)resizeFromLayer:(CAEAGLLayer *)layer
{
	layer.bounds = CGRectMake(layer.bounds.origin.x, layer.bounds.origin.y, windowSize.width, windowSize.height);

	// Allocate color buffer backing based on the current layer size
	[EAGLContext setCurrentContext:context];
    glBindRenderbuffer(GL_RENDERBUFFER, colorRenderbuffer);
    [context renderbufferStorage:GL_RENDERBUFFER fromDrawable:layer];
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &backingWidth);
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &backingHeight);

	currentWidth = backingWidth;
	currentHeight = backingHeight;

    if (glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE)
    {
        NSLog(@"Failed to make complete framebuffer object %x", glCheckFramebufferStatus(GL_FRAMEBUFFER));
        return NO;
    }

	[self setProjectionMatrix:topLeft.x	andY:topLeft.y andWidth:currentWidth andHeight:currentHeight];
    return YES;
}

- (BOOL)loadShaders
{
	defaultShader = [[CShader alloc] initWithRenderer:self];
	gradientShader = [[CShader alloc] initWithRenderer:self];
	defaultEllipseShader = [[CShader alloc] initWithRenderer:self];
	gradientEllipseShader = [[CShader alloc] initWithRenderer:self];
	
	[defaultShader loadShader:@"default" useTexCoord:YES useColors:NO useEllipse:NO];
	[gradientShader loadShader:@"gradient" useTexCoord:NO useColors:YES useEllipse:NO];
	[defaultEllipseShader loadShader:@"defaultEllipse" useTexCoord:YES useColors:NO useEllipse:YES];
	[gradientEllipseShader loadShader:@"gradientEllipse" useTexCoord:NO useColors:YES useEllipse:YES];
	return TRUE;
}

@end
