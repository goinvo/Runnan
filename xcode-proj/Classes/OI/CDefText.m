//----------------------------------------------------------------------------------
//
// CDEFTEXT : un element de texte
//
//----------------------------------------------------------------------------------
#import "CDefText.h"
#import "CFile.h"
#import "IEnum.h"

@implementation CDefText

-(void)dealloc
{
	[tsText release];
	[super dealloc];
}
-(void)load:(CFile*)file
{
	tsFont = [file readAShort];
	tsFlags = [file readAShort];
	tsColor = [file readAColor];
	tsText = [file readAString];
}
-(void)enumElements:(id)enumImages withFont:(id)enumFonts
{
	if (enumFonts != nil)
	{
		id<IEnum> pFonts=enumFonts;
		short num = [pFonts enumerate:tsFont];
		if (num != -1)
		{
			tsFont = num;
		}
	}
}

@end
