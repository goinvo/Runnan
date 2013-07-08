//----------------------------------------------------------------------------------
//
// CDEFCCA : definitions objet CCA
//
//----------------------------------------------------------------------------------
#import "CDefCCA.h"
#import "CFile.h"

@implementation CDefCCA

-(void)load:(CFile*)file
{
	[file skipBytes:4];
	odCx=[file readAInt];
	odCy=[file readAInt];
	odVersion=[file readAShort];
	odNStartFrame=[file readAShort];
	odOptions=[file readAInt];
//	[file skipBytes:4+4];                  // odFree+pad bytes
//	odName=[file readAString];
}
-(void)enumElements:(id)enumImages withFont:(id)enumFonts
{
}

@end
