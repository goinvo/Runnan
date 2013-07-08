//----------------------------------------------------------------------------------
//
// CEXTLOAD Chargement des extensions
//
//----------------------------------------------------------------------------------
#import "CExtLoad.h"
#import "CFile.h"
#import "CRunExtension.h"

//F01
#import "CRunkcini.h"
#import "CRunLayer.h"
#import "CRunMultipleTouch.h"
//F01END

@implementation CExtLoad

-(void)dealloc
{
	[name release];
	[subType release];
	[super dealloc];
}
-(void)loadInfo:(CFile*)file
{
	int debut = [file getFilePointer];
	
	short size = abs([file readAShort]);
	handle = [file readAShort];
	[file skipBytes:12];
	
	name = [file readAString];
	NSRange index = [name rangeOfString:@"."];
	if (index.location!=NSNotFound)
	{
		NSString* temp=[name substringToIndex:index.location];
		[name release];
		name=temp;
		[name retain];
	}
	subType = [file readAString];
	
	[file seek:debut + size];
}

-(CRunExtension*)loadRunObject 
{
	CRunExtension* object=nil;
	
//F02 			
	
if ([name caseInsensitiveCompare:@"kcini"]==0)
{
object=[[CRunkcini alloc] init];
}

if ([name caseInsensitiveCompare:@"Layer"]==0)
{
object=[[CRunLayer alloc] init];
}

if ([name caseInsensitiveCompare:@"MultipleTouch"]==0)
{
object=[[CRunMultipleTouch alloc] init];
}
//F02END	
	
	return object;
}

@end
