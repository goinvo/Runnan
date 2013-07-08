//----------------------------------------------------------------------------------
//
// CDEFCOUNTER : valeurs de depart counter
//
//----------------------------------------------------------------------------------
#import "CDefCounter.h"
#import "CFile.h"

@implementation CDefCounter

-(void)load:(CFile*)file
{
	[file skipBytes:2];              // Taille
	ctInit=[file readAInt];
	ctMini=[file readAInt];
	ctMaxi=[file readAInt];
}
-(void)enumElements:(id)enumImages withFont:(id)enumFonts
{
}

@end
