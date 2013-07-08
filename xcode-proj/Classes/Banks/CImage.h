//----------------------------------------------------------------------------------
//
// CIMAGE Une image
//
//----------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import "ITexture.h"
#import "IDrawable.h"

@class CFile;
@class CMask;
@class CImage;
@class CBitmap;
@class CRunApp;
@class CArrayList;

#define MAX_ROTATEDMASKS 10

struct ImageInfo
{
	BOOL isFound;
	short width;
	short height;
	short xSpot;
	short ySpot;
	short xAP;
	short yAP;
};
typedef struct ImageInfo ImageInfo;

@interface CImage : NSObject <ITexture>
{
@public 
	CRunApp* app;
	short handle;
    short width;
    short height;
    short xSpot;
    short ySpot;
    short xAP;
    short yAP;
    short useCount;
	int chunkSize;
	CArrayList* maskRotation;
	CArrayList* replacedColors;
	
	short format;
	short flags;
	short bytesPrPixel;
	int openGLmode;
	int openGLformat;
	BOOL coordsAreSwapped;
	
	unsigned int* data;
	int dataLength;
    CMask* mask;
    CMask* maskPlatform;
	
	int lineWidth;
	int bLineWidth;
	GLuint textureId;
	int textureWidth;
	int	textureHeight;
	GLfloat textureCoordinates[8];
	BOOL bCanRelease;
	int offset;
	CFile* file;
	BOOL hasMipMaps;
	int usageCount;
	BOOL useResampling;
	BOOL isUploading;
}
-(id)initWithApp:(CRunApp*)a;
-(id)initWithWidth:(int)sx andHeight:(int)sy;
-(void)dealloc;
-(void)loadHandle:(CFile*)file;
-(void)load:(CFile*)file;
-(CMask*)getMask:(int)nFlags withAngle:(int)angle andScaleX:(double)scaleX andScaleY:(double)scaleY;
-(CMask*)getMask:(int)nFlags;
-(void)copyImage:(CImage*)image;
-(CGImageRef)getCGImage;
-(UIImage*)getUIImage;
-(void)freeCGImage:(CGImageRef)cgImage;
-(void)loadBitmap:(CBitmap*)bitmap;
-(void)calculateTextureSize;
-(void)updateFilter;

+(CImage*)createFullColorImage:(CImage*)image;
+(CImage*)loadUIImage:(UIImage*)image;
+(CImage*)loadBitmap:(CBitmap*)bitmap;
+(int)getFormatByteSize:(int)format;

-(int)getPixel:(int)x withY:(int)y;
-(void)replaceColors;
-(void)replaceColor:(ReplacedColor*)info;

//CImage extra to reupload it's image data attempting to reuse the current texture ID if possible
-(int)reUploadTexture;

// ITexture methods
-(int)getHandle;
-(int)uploadTexture;
-(int)deleteTexture;
-(int)getTextureID;
-(int)getWidth;
-(int)getHeight;
-(int)getTextureWidth;
-(int)getTextureHeight;
-(GLfloat*)getTextureCoordinates;
-(int)getUsageCount;
-(void)resetCount;
-(void)incrementCount;
-(void)cleanMemory;
-(void)cleanPixelBuffer;
+(unsigned int)getReducedColorFromRed:(unsigned int)r andGreen:(unsigned int)g andBlue:(unsigned int)b fromFormat:(int)format;

@end

//Inlined function for determining if a given pixel is transparent
//Giving the format to the function allows the compiler to optimize the inlined function even more
static inline bool pixelIsSolid(CImage* img, int x, int y)
{
	int pixel4;
	short pixel2;
	switch (img->format)
	{
		case RGBA8888:
			pixel4 = img->data[x+ y*img->width];
			return ((pixel4 & 0xFF000000) != 0);
		case RGBA4444:
			pixel2 = *(short*)((char*)img->data + img->bLineWidth*y + x*img->bytesPrPixel);
			return ((pixel2 & 0xF) != 0);
		case RGBA5551:
			pixel2 = *(short*)((char*)img->data + img->bLineWidth*y + x*img->bytesPrPixel);
			return ((pixel2 & 0x01) != 0);			
		case RGB888:
		case RGB565:
		default:
			return true;
	}
}

