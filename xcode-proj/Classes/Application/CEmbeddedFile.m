//----------------------------------------------------------------------------------
//
// CEMBEDDEDFILE : fichiers inclus dans l'application
//
//----------------------------------------------------------------------------------
#import "CEmbeddedFile.h"
#import "CRunApp.h"
#import "CFile.h"

@implementation CEmbeddedFile

-(id)initWithApp:(CRunApp*)app
{
	runApp=app;
	length=0;
	offset=0;
	path=nil;
	return self;
}
-(void)preLoad
{
	short l = [runApp->file readAShort];
	
	NSString* fullPath = [runApp->file readAStringWithSize:l];
	path = [[runApp getRelativePath:fullPath] retain];
	[fullPath release];
	
	length = [runApp->file readAInt];
	offset = [runApp->file getFilePointer];
	[runApp->file skipBytes:length];
}

-(NSData*)open
{
	[runApp->file seek:offset];
	return [runApp->file readNSData:length];
}


@end
