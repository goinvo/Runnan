//----------------------------------------------------------------------------------
//
// CDEFCCA : definitions objet CCA
//
//----------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "CDefObject.h"

@class CFile;

@interface CDefCCA : CDefObject 
{
@public
    int odCx;						// Size (ignored)
    int odCy;
    short odVersion;					// 0
    short odNStartFrame;
    int odOptions;					// Options
//    NSString* odName;	
}
-(void)load:(CFile*)file;
-(void)enumElements:(id)enumImages withFont:(id)enumFonts;

@end
