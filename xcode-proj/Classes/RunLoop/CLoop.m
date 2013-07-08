// -----------------------------------------------------------------------------
//
// CLOOP une fast loop
//
// -----------------------------------------------------------------------------
#import "CLoop.h"

@implementation CLoop

-(void)dealloc
{
	[name release];
	[super dealloc];
}

-(NSString*)description
{
	return [NSString stringWithFormat:@"Loop['%@':%i]", name, index];
}

@end
