//----------------------------------------------------------------------------------
//
// CRCOM : Structure commune aux objets animes
//
//----------------------------------------------------------------------------------
#import <Foundation/Foundation.h>


@class CSprite;

@interface CRCom : NSObject 
{
@public
	int rcPlayer;					// Player who controls
    int rcMovementType;				// Number of the current movement
    CSprite* rcSprite;					// Sprite ID if defined
    int rcAnim;						// Wanted animation
    short rcImage;					// Current frame
    float rcScaleX;					
    float rcScaleY;
    int rcAngle;
    int rcDir;						// Current direction
    int rcSpeed;					// Current speed
    int rcMinSpeed;					// Minimum speed
    int rcMaxSpeed;					// Maximum speed
    BOOL rcChanged;					// Flag: modified object
    BOOL rcCheckCollides;			// For static objects
	
    int rcOldX;            			// Previous coordinates
    int rcOldY;
    short rcOldImage;
    int rcOldAngle;
    int rcOldDir;
    int rcOldX1;					// For zone detections
    int rcOldY1;
    int rcOldX2;
    int rcOldY2;
	
    int rcFadeIn;
    int rcFadeOut;
	
	BOOL rcCMoveChanged;
	
}
-(id)init;
-(void)kill:(BOOL)bFast;

@end
