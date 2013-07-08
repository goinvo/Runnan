//----------------------------------------------------------------------------------
//
// CQUALTOOI : qualifiers
//
//----------------------------------------------------------------------------------
#import "CQualToOiList.h"


@implementation CQualToOiList

-(id)init
{
	if(self = [super init])
	{
		qoiList = nil;
	}
	return self;
}

-(void)dealloc
{
	if (qoiList!=nil)
	{
		free(qoiList);
	}
	[super dealloc];
}

@end
