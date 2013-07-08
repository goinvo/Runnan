//----------------------------------------------------------------------------------
//
// CPATHSTEP : un pas de mouvement path
//
//----------------------------------------------------------------------------------
#import "CPathStep.h"
#import "CFile.h"

@implementation CPathStep

-(id)init
{
	mdName = nil;
	return self;
}
-(void)dealloc
{
	if (mdName!=nil)
	{
		[mdName release];
	}
	[super dealloc];
}
-(void)load:(CFile*)file 
{
	mdSpeed=[file readAByte];
	mdDir=[file readAByte];
	mdDx=[file readAShort];
	mdDy=[file readAShort];
	mdCosinus=[file readAShort];
	mdSinus=[file readAShort];
	mdLength=[file readAShort];
	mdPause=[file readAShort];
	NSString* name=[file readAString];
	if ([name length]>0)
		mdName=name;
	else
		[name release];
}       

@end
