//----------------------------------------------------------------------------------
//
// COC: classe abstraite d'objectsCommon
//
//----------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "IEnum.h"
#import "IDrawable.h"

#define OBSTACLE_NONE 0
#define OBSTACLE_SOLID 1
#define OBSTACLE_PLATFORM 2
#define OBSTACLE_LADDER 3
#define OBSTACLE_TRANSPARENT4

@class CFile;
@class CMask;
@class CSprite;
@class CImageBank;
@class CRenderer;
@class COI;

@interface COC : NSObject <IDrawable>
{
@public
	short ocObstacleType;		// Obstacle type
    short ocColMode;			// Collision mode (0 = fine, 1 = box)
    int ocCx;				// Size
    int ocCy;
}
-(void)load:(CFile*)file withType:(short)type andCOI:(COI*)pOI;
-(void)enumElements:(id)enumImages withFont:(id)enumFonts;
-(void)spriteDraw:(CGContextRef)g withSprite:(CSprite*)spr andImageBank:(CImageBank*)bank andX:(int)x andY:(int)y;
-(void)spriteKill:(CSprite*)spr;
-(CMask*)spriteGetMask;

@end
