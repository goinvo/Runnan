//----------------------------------------------------------------------------------
//
// CLO : un levobj
//
//----------------------------------------------------------------------------------

#import <Foundation/Foundation.h>

#define PARENT_NONE 0
#define PARENT_FRAME 1
#define PARENT_FRAMEITEM 2
#define PARENT_QUALIFIER 3

@class CSprite;
@class CFile;

@interface CLO : NSObject 
{
@public 
    short loHandle;			// Le handle
    short loOiHandle;			// HOI
    int loX;				// Coords
    int loY;
    short loParentType;			// Parent type
    short loOiParentHandle;		// HOI Parent
    short loLayer;			// Layer
    short loType;
    CSprite* loSpr[4];			// Sprite handles for backdrop objects from layers > 1	
}

-(id)init;
-(void)load:(CFile*)file;

@end
