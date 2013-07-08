//
//  CShader.h
//  RuntimeIPhone
//
//  Created by Anders Riggelsen on 6/10/10.
//  Copyright 2010 Clickteam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES2/gl.h>

@class ITexture;
@class CRenderer;

enum {
    UNIFORM_TEXTURE,
	UNIFORM_PROJECTIONMATRIX,
	UNIFORM_INKEFFECT,
	UNIFORM_INKPARAM,
	UNIFORM_ELLIPSE_CENTERPOS,
	UNIFORM_ELLIPSE_RADIUS,
	UNIFORM_RGBCOEFFICIENT,
    NUM_UNIFORMS
};

enum {
    ATTRIB_VERTEX,
	ATTRIB_COLOR,
    ATTRIB_TEXCOORD,
    NUM_ATTRIBUTES
};

@interface CShader : NSObject
{
@public
	GLuint program;
	GLuint fragmentProgram;
	GLuint vertexProgram;
	int uniforms[NUM_UNIFORMS];
	BOOL usesTexCoord;
	BOOL usesColor;
	CRenderer* render;
	
	int currentEffect;
	float currentParam;
	float currentR, currentG, currentB;
	NSString* sname;
}
-(id)initWithRenderer:(CRenderer*)renderer;
-(void)dealloc;

-(BOOL)loadShader:(NSString*)shaderName useTexCoord:(BOOL)useTexCoord useColors:(BOOL)useColors useEllipse:(BOOL)useEllipse;
-(GLuint)compileShader:(GLuint*)shader file:(NSString*)shaderName ofType:(GLint)type;
-(BOOL)linkProgram:(GLuint)prog;
-(BOOL)validateProgram:(GLuint)prog;

-(void)setTexture:(ITexture*)texture;
-(void)setRGBCoeff:(float)red andGreen:(float)green andBlue:(float)blue;
-(void)setInkEffect:(int)effect andParam:(float)effectParam;
-(void)setEllipseCenterX:(int)x andY:(int)y withRadiusA:(int)rA andRadiusB:(int)rB;

-(int)getUniformLocation:(GLchar*)name;
-(void)fetchUniform:(GLchar*)name toLocation:(int)location;
-(void)bindShader;
-(void)setProjectionMatrix:(float*)orthoMatrix;

@end


