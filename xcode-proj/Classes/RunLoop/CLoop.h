// -----------------------------------------------------------------------------
//
// CLOOP une fast loop
//
// -----------------------------------------------------------------------------
#import <Foundation/Foundation.h>

#define FLFLAG_STOP 0x0001

@interface CLoop : NSObject 
{
@public 
	short flags;
    NSString* name;
    int index;	
}
-(void)dealloc;
-(NSString*)description;
@end
