//----------------------------------------------------------------------------------
//
// COI
//
//----------------------------------------------------------------------------------
#import "COI.h"
#import "COC.h"
#import "CFile.h"
#import "IEnum.h"
#import "CObjectCommon.h"
#import "COCBackground.h"
#import "COCQBackdrop.h"

@implementation COI

-(id)init
{
    oiHandle=0;
    oiType=0;
    oiFlags=0;			
    oiInkEffect=0;			
    oiInkEffectParam=0;	    
    oiOC=nil;			
    oiFileOffset=0;
    oiLoadFlags=0;
    oiLoadCount=0;
    oiCount=0;
	oiName=nil;
		
	return self;
}
-(void)dealloc
{
	if (oiName!=nil)
	{
		[oiName release];
	}
	if (oiOC!=nil)
	{
		[oiOC release];
	}
	[super dealloc];
}
-(void)loadHeader:(CFile*)file
{
	oiHandle=[file readAShort];
	oiType=[file readAShort];
	oiFlags=[file readAShort];
	[file skipBytes:2];
	oiInkEffect=[file readAInt];
	oiInkEffectParam=[file readAInt];
}
-(void)load:(CFile*)file 
{
	// Positionne au debut
	[file seek:oiFileOffset];
	
	// En fonction du type
	switch (oiType)
	{
	    case 0:		// Quick background
			oiOC=[[COCQBackdrop alloc] init];
			break;
	    case 1:
			oiOC=[[COCBackground alloc] init];
			break;
	    default:
			oiOC=[[CObjectCommon alloc] init];
			break;
	}
	[oiOC load:file withType:oiType andCOI:self];
	oiLoadFlags=0;
}
-(void)unLoad
{
	if (oiOC!=nil)
	{
		[oiOC release];
		oiOC=nil;
	}
}
-(void)enumElements:(id)enumImages withFont:(id)enumFonts
{
	[oiOC enumElements:enumImages withFont:enumFonts];
}

@end
