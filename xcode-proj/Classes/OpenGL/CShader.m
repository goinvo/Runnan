//
//  CShader.m
//  RuntimeIPhone
//
//  Created by Anders Riggelsen on 6/10/10.
//  Copyright 2010 Clickteam. All rights reserved.
//

#import "CShader.h"
#import "ITexture.h"
#import "CBitmap.h"
#import "CRenderer.h"

@implementation CShader

-(id)initWithRenderer:(CRenderer*)renderer
{
	if(self = [super init])
	{
		render = renderer;
		currentEffect = -1;
		currentParam = -1;
		currentR = currentG = currentB = -1;
	}
	return self;
}

-(void) dealloc
{
	glDeleteProgram(program);
	[sname release];
	[super dealloc];
}

-(BOOL)loadShader:(NSString*)shaderName useTexCoord:(BOOL)useTexCoord useColors:(BOOL)useColors useEllipse:(BOOL)useEllipse
{
	NSString *vertShaderPathname, *fragShaderPathname;
	sname = [[NSString alloc] initWithString:shaderName];
	
	program = glCreateProgram();
	usesTexCoord = useTexCoord;
	usesColor = useColors;
		
    // Create and compile vertex shader
    vertShaderPathname = [[NSBundle mainBundle] pathForResource:shaderName ofType:@"vsh" inDirectory:@""];
	if (vertShaderPathname == nil || ![self compileShader:&vertexProgram file:vertShaderPathname ofType:GL_VERTEX_SHADER])
    {
        NSLog(@"Failed to compile vertex shader");
        return FALSE;
    }
	
    // Create and compile fragment shader
    fragShaderPathname = [[NSBundle mainBundle] pathForResource:shaderName ofType:@"fsh" inDirectory:@""];
    if (fragShaderPathname == nil || ![self compileShader:&fragmentProgram file:fragShaderPathname ofType:GL_FRAGMENT_SHADER])
    {
        NSLog(@"Failed to compile fragment shader");
        return FALSE;
    }
	
	glAttachShader(program, vertexProgram);
    glAttachShader(program, fragmentProgram);

	glBindAttribLocation(program, ATTRIB_VERTEX, "position");
	if(useTexCoord)
		glBindAttribLocation(program, ATTRIB_TEXCOORD, "texCoord");
	if(useColors)
		glBindAttribLocation(program, ATTRIB_COLOR, "color");

	if (![self linkProgram:program])
    {
        NSLog(@"Failed to link program: %d", program);
		
        if (vertexProgram)
        {
            glDeleteShader(vertexProgram);
            vertexProgram = 0;
        }
        if (fragmentProgram)
        {
            glDeleteShader(fragmentProgram);
            fragmentProgram = 0;
        }
        if (program)
        {
            glDeleteProgram(program);
            program = 0;
        }
        return FALSE;
    }

	[self bindShader];
	[self fetchUniform:"projectionMatrix" toLocation:UNIFORM_PROJECTIONMATRIX];
	[self fetchUniform:"inkEffect" toLocation:UNIFORM_INKEFFECT];
	[self fetchUniform:"inkParam" toLocation:UNIFORM_INKPARAM];
	[self fetchUniform:"rgbCoeff" toLocation:UNIFORM_RGBCOEFFICIENT];

	if(useTexCoord)
	{
		[self fetchUniform:"texture" toLocation:UNIFORM_TEXTURE];
		glUniform1i(uniforms[UNIFORM_TEXTURE], 0);
		glActiveTexture(GL_TEXTURE0);
	}

	if(useColors)
	{
		unsigned char nullColors [16] = {0};
		glVertexAttribPointer(ATTRIB_COLOR, 4, GL_UNSIGNED_BYTE, GL_TRUE, 0, nullColors);
	}

	if(useEllipse)
	{
		[self fetchUniform:"centerpos" toLocation:UNIFORM_ELLIPSE_CENTERPOS];
		[self fetchUniform:"radius" toLocation:UNIFORM_ELLIPSE_RADIUS];
	}
	return TRUE;
}

-(void)fetchUniform:(GLchar*)name toLocation:(int)location
{
	uniforms[location] = glGetUniformLocation(program, name);
}

-(int)getUniformLocation:(GLchar*)name
{
	return glGetUniformLocation(program, name);
}

-(void)setTexture:(ITexture*)texture
{
	int texId = [texture getTextureID];
	if(render->currentTextureID != texId)
	{
		glBindTexture(GL_TEXTURE_2D, texId);
		render->currentTextureID = texId;
	}
}

-(void)setRGBCoeff:(float)red andGreen:(float)green andBlue:(float)blue
{
	if(currentR != red || currentG != green || currentB != blue)
	{
		glUniform3f(uniforms[UNIFORM_RGBCOEFFICIENT], red, green, blue);
		currentR = red;
		currentG = green;
		currentB = blue;
	}
}

-(void)setEllipseCenterX:(int)x andY:(int)y withRadiusA:(int)rA andRadiusB:(int)rB
{
	glUniform2f(uniforms[UNIFORM_ELLIPSE_CENTERPOS], (float)x, (float)y);
	glUniform2f(uniforms[UNIFORM_ELLIPSE_RADIUS], (float)(rA*rA), (float)(rB*rB));
}

-(void)bindShader
{
	glUseProgram(program);
	glEnableVertexAttribArray(ATTRIB_VERTEX);
	
	if(usesTexCoord)
		glEnableVertexAttribArray(ATTRIB_TEXCOORD);
	else
		glDisableVertexAttribArray(ATTRIB_TEXCOORD);

	if(usesColor)
		glEnableVertexAttribArray(ATTRIB_COLOR);
	else
		glDisableVertexAttribArray(ATTRIB_COLOR);
}



//Sets up the blending and ink effect parameters in the currently bound shader
-(void)setInkEffect:(int)effect andParam:(float)effectParam
{
	//Set transparency based on the inkEffect
	switch (effect)
	{
		default:
		case BOP_COPY:
		case BOP_BLEND:
		case BOP_BLEND_REPLEACETRANSP:
		case BOP_BLEND_DONTREPLACECOLOR:
		case BOP_OR:
		case BOP_XOR:
		case BOP_MONO:
		case BOP_INVERT:
			[render setBlendEquation:GL_FUNC_ADD];
			[render setBlendFunction:GL_SRC_ALPHA dFactor:GL_ONE_MINUS_SRC_ALPHA];
			break;
		case BOP_ADD:
			[render setBlendEquation:GL_FUNC_ADD];
			[render setBlendFunction:GL_SRC_ALPHA dFactor:GL_ONE];
			break;
		case BOP_SUB:
			[render setBlendEquationSeperate:GL_FUNC_REVERSE_SUBTRACT other:GL_FUNC_ADD];
			[render setBlendFunction:GL_SRC_ALPHA dFactor:GL_ONE];
			break;
	}
	if(currentEffect != effect)
	{
		glUniform1i(uniforms[UNIFORM_INKEFFECT], effect);
		currentEffect = effect;
	}
	if(currentParam != effectParam)
	{
		glUniform1f(uniforms[UNIFORM_INKPARAM], effectParam);
		currentParam = effectParam;
	}
}

-(void)setProjectionMatrix:(float*)orthoMatrix
{
    glUniformMatrix4fv(uniforms[UNIFORM_PROJECTIONMATRIX], 1, GL_FALSE, orthoMatrix);
}

-(GLuint)compileShader:(GLuint*)shader file:(NSString*)shaderName ofType:(GLint)type
{
	GLint status;
    const GLchar *source;
	
    source = (GLchar *)[[NSString stringWithContentsOfFile:shaderName encoding:NSUTF8StringEncoding error:nil] UTF8String];
    if (!source)
    {
        [NSException raise:@"Failed to load shader resource" format:@""];
    }
	
    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &source, NULL);
    glCompileShader(*shader);
	
	//#if defined(DEBUG)
    GLint logLength;
    glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0)
    {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetShaderInfoLog(*shader, logLength, &logLength, log);
        NSLog(@"Shader compile log:\n%s", log);
        free(log);
    }
	//#endif
	
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    if (status == 0)
    {
        glDeleteShader(*shader);
		NSLog(@"Unable to compile shader");
        return FALSE;
    }
	
    return TRUE;
	
}

- (BOOL)linkProgram:(GLuint)prog
{
    GLint status;
	
    glLinkProgram(prog);
	
#if defined(DEBUG)
    GLint logLength;
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0)
    {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program link log:\n%s", log);
        free(log);
    }
#endif
	
    glGetProgramiv(prog, GL_LINK_STATUS, &status);
    if (status == 0)
        return FALSE;
	
    return TRUE;
}


- (BOOL)validateProgram:(GLuint)prog
{
    GLint logLength, status;
	
    glValidateProgram(prog);
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0)
    {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program validate log:\n%s", log);
        free(log);
    }
	
    glGetProgramiv(prog, GL_VALIDATE_STATUS, &status);
    if (status == 0)
        return FALSE;
	
    return TRUE;
}

-(NSString*)description
{
	return [NSString stringWithFormat:@"CShader '%@' ", sname];
}


@end
