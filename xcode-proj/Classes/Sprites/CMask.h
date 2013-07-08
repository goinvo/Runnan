//----------------------------------------------------------------------------------
//
// CMASK : un masque
//
//----------------------------------------------------------------------------------
#import <Foundation/Foundation.h>

#define SCMF_FULL 0x0000
#define SCMF_PLATFORM 0x0001
#define GCMF_OBSTACLE 0x0000
#define GCMF_PLATFORM 0x0001

@class CImage;

@interface CMask : NSObject 
{
@public
	short* mask;
    int lineWidth;
    int height;
    int width;
    int xSpot;
    int ySpot;
	
}
-(void)dealloc;
-(void)createMask:(CImage*)img withFlags:(int)nFlags;
-(BOOL)testMask:(int)yBase1 withX1:(int)x1 andY1:(int)y1 andMask:(CMask*)pMask2 andYBase:(int)yBase2 andX2:(int)x2 andY2:(int)y2;
-(BOOL)testRect:(int)yBase1 withX:(int)xx andY:(int)yy andWidth:(int)w andHeight:(int)h;
-(BOOL)testPoint:(int)x1 withY:(int)y1;
-(void)rotateRect:(int*)pWidth withPHeight:(int*)pHeight andPHX:(int*)pHX andPHY:(int*)pHY andAngle:(float)fAngle;
-(BOOL)createRotatedMask:(CMask*)pMask withAngle:(float)fAngle andScaleX:(float)fScaleX andScaleY:(float)fScaleY;

@end

typedef struct tagRM
{
	CMask* mask;
	int angle;
	double scaleX;
	double scaleY;
	int tick;
} RotatedMask;

