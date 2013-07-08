//----------------------------------------------------------------------------------
//
// CANIMDIR : Une direction d'animation
//
//----------------------------------------------------------------------------------
#import <Foundation/Foundation.h>

@class CFile;

@interface CAnimDir : NSObject 
{
@public
	unsigned char adMinSpeed;					// Minimum speed
    unsigned char adMaxSpeed;					// Maximum speed
    short adRepeat;					// Number of loops
    short adRepeatFrame;				// Where to loop
    short adNumberOfFrame;			// Number of frames
    short* adFrames;	
}
-(void)dealloc;
-(void)load:(CFile*)file; 
-(void)enumElements:(id)enumImages;

@end
