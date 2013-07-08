//----------------------------------------------------------------------------------
//
// CSYSEVENTCLICK : un evenement click
//
//----------------------------------------------------------------------------------
#import "CSysEventClick.h"
#import "CRun.h"
#import "CEventProgram.h"

@implementation CSysEventClick

-(id)initWithClick:(int)c
{
	clicks=c;
	return self; 
}

-(void)execute:(CRun*)rhPtr
{
	[rhPtr->rhEvtProg onMouseButton:clicks];
}
@end
