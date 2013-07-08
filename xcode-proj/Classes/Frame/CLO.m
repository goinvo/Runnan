//----------------------------------------------------------------------------------
//
// CLO : un levobj
//
//----------------------------------------------------------------------------------
#import "CLO.h"
#import "CFile.h"

@implementation CLO

-(id)init
{
	int i;
	for (i=0; i<4; i++)
	{
	    loSpr[i]=nil;
	}
	return self;
}

-(void)load:(CFile*)file
{
	loHandle=[file readAShort];
	loOiHandle=[file readAShort];
	loX=[file readAInt];
	loY=[file readAInt];
	loParentType=[file readAShort];
	loOiParentHandle=[file readAShort];
	loLayer=[file readAShort];
	[file skipBytes:2];
}

@end
