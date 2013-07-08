//----------------------------------------------------------------------------------
//
// CIMAGEBANK : Stockage des images
//
//----------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "IEnum.h"
#import "CImage.h"

@class CRunApp;

@interface CImageBank : NSObject <IEnum>
{
	CRunApp* runApp;
    CImage** images;
    int nHandlesReel;
    int nHandlesTotal;
    int nImages;
    int* offsetsToImages;
    short* handleToIndex;
    short* useCount;
}

-(id)initWithApp:(CRunApp*)app;
-(void)dealloc;
-(void)preLoad;
-(void)cleanMemory;
-(short)enumerate:(short)num;
-(CImage*)getImageFromHandle:(short)handle;
-(CImage*)getImageFromIndex:(short)index;
-(void)resetToLoad;
-(void)setToLoad:(short)handle;
-(void)load;
-(void)delImage:(short)handle;
-(short)addImageCompare:(CImage*)img withXSpot:(short)xSpot andYSpot:(short)ySpot andXAP:(short)xAP andYAP:(short)yAP;
-(short)addImage:(CImage*)img withXSpot:(short)xSpot andYSpot:(short)ySpot andXAP:(short)xAP andYAP:(short)yAP andCount:(short)count;
-(void)loadImageList:(short*)handles withLength:(int)length;
-(ImageInfo)getImageInfoEx:(short)nImage withAngle:(int)nAngle andScaleX:(float)fScaleX andScaleY:(float)fScaleY;

@end
