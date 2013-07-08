//----------------------------------------------------------------------------------
//
// CANIMHEADER : header d'un ensemble d'animations
//
//----------------------------------------------------------------------------------
#import <Foundation/Foundation.h>

@class CFile;
@class CAnim;

@interface CAnimHeader : NSObject 
{
@public
	short ahAnimMax;
    CAnim** ahAnims;
    unsigned char* ahAnimExists;	
}
-(void)dealloc;
-(void)load:(CFile*)file; 
-(void)enumElements:(id)enumImages;

@end
