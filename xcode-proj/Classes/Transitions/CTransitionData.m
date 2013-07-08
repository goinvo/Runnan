//----------------------------------------------------------------------------------
//
// CTRANSITIONDATA : donnÈes transitions
//
//----------------------------------------------------------------------------------
#import "CTransitionData.h"
#import "CFile.h"

@implementation CTransitionData

-(void)dealloc
{
	[dllName release];
	[super dealloc];
}
-(void)load:(CFile*)file
{
	int debut=[file getFilePointer];
	
	[file skipBytes:4];
	transID=[file readAInt];
	transDuration=[file readAInt];
	transFlags=[file readAInt];
	transColor=[file readAColor];
	
	int nameOffset=[file readAInt];
	int paramOffset=[file readAInt];
	[file seek:debut+nameOffset];

	dllName=[file readAString];
	NSRange index = [dllName rangeOfString:@"."];
	if (index.location!=NSNotFound)
	{
		NSString* temp=[dllName substringToIndex:index.location];
		[dllName release];
		dllName=temp;
		[dllName retain];
	}
	dataOffset=(int)(debut+paramOffset);
}

@end
