//----------------------------------------------------------------------------------
//
// CSYSEVENTCLICK : un evenement click
//
//----------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "CSysEvent.h"

@class CRun;

@interface CSysEventClick : CSysEvent 
{
@public 
    int clicks;	
}
-(id)initWithClick:(int)c;
-(void)execute:(CRun*)rhPtr;

@end
