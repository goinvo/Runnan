
#import <QuartzCore/QuartzCore.h>

#import <OpenGLES/EAGL.h>
#import <OpenGLES/EAGLDrawable.h>

#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

@class ITexture;
@class CRenderToTexture;
@class CRunView;
@class CArrayList;
@class CRunApp;
@class CShader;

@interface CRenderer : NSObject
{
@public
    EAGLContext* context;
	CRunView* view;
	
    // The pixel dimensions of the CAEAGLLayer
    GLint backingWidth;
    GLint backingHeight;
	GLint currentWidth;
	GLint currentHeight;
	
	//OpenGL capabilities
	GLint maxTextureSize;
	
	BOOL useClipping;
	GLint clipLeft, clipTop, clipRight, clipBottom;
	
	int originX, originY;
	CGPoint topLeft;
	
	int textureUsage;
	NSMutableSet* usedTextures;
	
    // The OpenGL ES names for the framebuffer and renderbuffer used to render to this view
    GLuint defaultFramebuffer, colorRenderbuffer;
	
	CAEAGLLayer* glLayer;
	CGSize windowSize;
	CArrayList* texturesToRemove;
	
	//Current OpenGL state to minimize redundant state changes
	int currentTextureID;
	int currentBlendEquationA;
	int currentBlendEquationB;
	int currentBlendFunctionA;
	int currentBlendFunctionB;
	float cR, cG, cB, cA;

	int currentEffect;
	float currentParam;


	CShader* defaultShader;
	CShader* defaultEllipseShader;
	CShader* gradientShader;
	CShader* gradientEllipseShader;
	CShader* currentShader;
	float ortho [16];
} 

-(id)initWithView:(CRunView*)runView;
-(void)dealloc;
-(void)destroyFrameBuffers;

-(BOOL)resizeFromLayer:(CAEAGLLayer *)layer;
-(void)clear:(float)red green:(float)green blue:(float)blue;
-(void)clear;
-(void)clearWithRunApp:(CRunApp*)app;
-(void)swapBuffers;
-(void)flush;
-(void)forgetCachedState;

-(BOOL)loadShaders;

-(void)bindRenderBuffer;
-(void)updateViewport;

-(void)setInkEffect:(int)effect andParam:(int)effectParam andShader:(CShader*)shader;
-(void)setProjectionMatrix:(int)x andY:(int)y andWidth:(int)width andHeight:(int)height;

-(void)renderSimpleImage:		(int)x andY:(int)y andWidth:(int)w andHeight:(int)h;
-(void)renderImage:				(ITexture*)image withX:(int)x andY:(int)y andWidth:(int)w andHeight:(int)h andInkEffect:(int)inkEffect andInkEffectParam:(int)inkEffectParam;
-(void)renderPattern:			(ITexture*)image withX:(int)x andY:(int)y andWidth:(int)w andHeight:(int)h andInkEffect:(int)inkEffect andInkEffectParam:(int)inkEffectParam;
-(void)renderPatternEllipse:	(ITexture*)image withX:(int)x andY:(int)y andWidth:(int)w andHeight:(int)h andInkEffect:(int)inkEffect andInkEffectParam:(int)inkEffectParam;
-(void)renderScaledRotatedImage:(ITexture*)image withAngle:(int)angle andScaleX:(float)sX andScaleY:(float)sY andHotSpotX:(int)hX andHotSpotY:(int)hY andX:(int)x andY:(int)y andWidth:(int)w andHeight:(int)h andInkEffect:(int)inkEffect andInkEffectParam:(int)inkEffectParam;

-(void)renderScaledRotatedImage:(ITexture*)image withAngle:(float)angle andScaleX:(float)sX andScaleY:(float)sY andHotSpotX:(float)hX andHotSpotY:(float)hY andX:(float)x andY:(float)y andWidth:(float)w andHeight:(float)h andInkEffect:(int)inkEffect andInkEffectParam:(int)inkEffectParam andOffsetX:(float)offsetX andOffsetY:(float)offsetY andFlippedX:(BOOL)flipX andFlippedY:(BOOL)flipY usingWrap:(BOOL)wrap;
-(void)renderSubPart:(GLfloat*)texCoord withCosA:(float)cosA andSinA:(float)sinA andScaleX:(float)sX andScaleY:(float)sY andHotSpotX:(float)hX andHotSpotY:(float)hY andX:(float)x andY:(float)y andWidth:(float)w andHeight:(float)h andOffsetX:(float)offsetX andOffsetY:(float)offsetY andFlippedX:(BOOL)flipX andFlippedY:(BOOL)flipY andFWidth:(float)fwidth andFHeight:(float)fheight;

-(void)renderLineWithXA:		(int)xA andYA:(int)yA andXB:(int)xB andYB:(int)yB andColor:(int)color andThickness:(int)thickness;

-(void)renderGradientEllipse:(unsigned char*)colors withX:(int)x andY:(int)y andWidth:(int)w andHeight:(int)h andInkEffect:(int)inkEffect andInkEffectParam:(int)inkEffectParam;
-(void)renderGradient:(unsigned char*)colors withX:(int)x andY:(int)y andWidth:(int)w andHeight:(int)h andInkEffect:(int)inkEffect andInkEffectParam:(int)inkEffectParam;
-(void)renderSolidColor:(int)color withX:(int)x andY:(int)y andWidth:(int)w andHeight:(int)h andInkEffect:(int)inkEffect andInkEffectParam:(int)inkEffectParam;

//For transitions
-(void)setOriginX:(int)x andY:(int)y;
-(void)renderBlitFull:	(CRenderToTexture*)source;
-(void)renderBlit:		(CRenderToTexture*)source withXDst:(int)xDst andYDst:(int)yDst andXSrc:(int)xSrc andYSrc:(int)ySrc andWidth:(int)width andHeight:(int)height;
-(void)renderStretch:	(CRenderToTexture*)source withXDst:(int)xDst andYDst:(int)yDst andWDst:(int)wDst andHDst:(int)hDst andXSrc:(int)xSrc andYSrc:(int)ySrc andWSrc:(int)wSrc andHSrc:(int)hSrc;
-(void)renderStretch:	(CRenderToTexture*)source withXDst:(int)xDst andYDst:(int)yDst andWDst:(int)wDst andHDst:(int)hDst andXSrc:(int)xSrc andYSrc:(int)ySrc andWSrc:(int)wSrc andHSrc:(int)hSrc andInkEffect:(int)inkEffect andInkEffectParam:(int)inkEffectParam;
-(void)renderFade:		(CRenderToTexture*)source withCoef:(int)alpha;

-(void)useBlending:(bool)useBlending;

-(void)setBlendEquation:(GLenum)equation;
-(void)setBlendEquationSeperate:(GLenum)equationA other:(GLenum)equationB;
-(void)setBlendFunction:(GLenum)sFactor dFactor:(GLenum)dFactor;
-(void)setBlendColorRed:(float)red green:(float)green blue:(float)blue alpha:(float)alpha;

//Clipping
-(void)setClipWithX:(int)x andY:(int)y  andWidth:(int)w  andHeight:(int)h;
-(void)resetClip;

+(void)checkForError;
+(CRenderer*)getRenderer;

-(void)uploadTexture:(ITexture*)texture;
-(void)removeTexture:(ITexture*)texture andCleanMemory:(BOOL)cleanMemory;
-(void)cleanMemory;
-(void)cleanUnused;
-(void)pruneTexture;
-(void)clearPruneList;

@end

