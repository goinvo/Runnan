//----------------------------------------------------------------------------------
//
// CPATHSTEP : un pas de mouvement path
//
//----------------------------------------------------------------------------------
#import <Foundation/Foundation.h>

@class CFile;

@interface CPathStep : NSObject 
{
@public
	unsigned char mdSpeed;
    unsigned char mdDir;
    short mdDx;
    short mdDy;
    short mdCosinus;
    short mdSinus;
    short mdLength;
    short mdPause;
    NSString* mdName;	
}
-(void)dealloc;
-(void)load:(CFile*)file; 

@end
