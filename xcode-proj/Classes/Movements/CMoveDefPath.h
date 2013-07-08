//----------------------------------------------------------------------------------
//
// CMOVEDEFPATH : donnÈes du mouvement path
//
//----------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "CMoveDef.h"

@class CFile;
@class CPathStep;

@interface CMoveDefPath : CMoveDef 
{
@public
    short mtNumber;				// Number of movement 
    short mtMinSpeed; 			// maxs and min speed in the movements 
    short mtMaxSpeed;
    unsigned char mtLoop;					// Loop at end
    unsigned char mtRepos;				// Reposition at end
    unsigned char mtReverse;				// Pingpong?
    CPathStep** steps;	
}
-(void)dealloc;
-(void)load:(CFile*)file withLength:(int)length;

@end
