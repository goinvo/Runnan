//----------------------------------------------------------------------------------
//
// CDEFSTRINGS : definition des alterable strings
//
//----------------------------------------------------------------------------------
#import "CDefStrings.h"
#import "CFile.h"

@implementation CDefStrings

-(id)init
{
	strings=nil;
	return self;
}
-(void)dealloc
{
	if (strings!=nil)
	{
		int n;
		for (n=0; n<nStrings; n++)
		{
			[strings[n] release];
		}
		free(strings);
	}
	[super dealloc];
}
-(void)load:(CFile*)file
{
	nStrings=[file readAShort];
	if (nStrings>0)
	{		
		strings=(NSString**)malloc(nStrings*sizeof(NSString*));
		int n;
		for (n=0; n<nStrings; n++)
		{
			strings[n]=[file readAString];
		}
	}
}
@end
