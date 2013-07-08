//----------------------------------------------------------------------------------
//
// CDEFSTRINGS : definition des alterable strings
//
//----------------------------------------------------------------------------------
#import <Foundation/Foundation.h>

@class CFile;

@interface CDefStrings : NSObject 
{
@public
	short nStrings;
    NSString** strings;	
}
-(id)init;
-(void)dealloc;
-(void)load:(CFile*)file;

@end
