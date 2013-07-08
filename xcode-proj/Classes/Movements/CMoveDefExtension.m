//----------------------------------------------------------------------------------
//
// CMOVEDEFEXTENSION : donnÈes d'un movement extension
//
//----------------------------------------------------------------------------------
#import "CMoveDefExtension.h"
#import "CFile.h"

@implementation CMoveDefExtension

-(void)dealloc
{
	[moduleName release];
	free(data);
	
	[super dealloc];
}
-(void)load:(CFile*)file withLength:(int)l
{
	[file skipBytes:14];
	length=l-14;
	data=(unsigned char*)malloc(length);
	[file readACharBuffer:(char*)data withLength:length];
}
-(void)setModuleName:(NSString*)name withID:(int)id
{
	moduleName=[[NSString alloc] initWithString:name];
	mvtID=id;
}

@end
