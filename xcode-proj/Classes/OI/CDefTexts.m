//----------------------------------------------------------------------------------
//
// CDEFTEXTS : liste de textes
//
//----------------------------------------------------------------------------------
#import "CDefTexts.h"
#import "CFile.h"
#import "CDefText.h"

@implementation CDefTexts

-(void)dealloc
{
	int n;
	for (n=0; n<otNumberOfText; n++)
	{
		[otTexts[n] release];
	}
	free(otTexts);
	
	[super dealloc];
}
-(void)load:(CFile*)file
{
	int debut = [file getFilePointer];
	[file skipBytes:4];          // Size
	otCx = [file readAInt];
	otCy = [file readAInt];
	otNumberOfText = [file readAInt];
	
	otTexts = (CDefText**)calloc(otNumberOfText, sizeof(CDefText*));
	int* offsets = (int*)malloc(otNumberOfText*sizeof(int));
	int n;
	for (n = 0; n < otNumberOfText; n++)
	{
		offsets[n] = [file readAInt];
	}
	for (n = 0; n < otNumberOfText; n++)
	{
		otTexts[n] = [[CDefText alloc] init];
		[file seek:debut + offsets[n]];
		[otTexts[n] load:file];
	}
	free(offsets);
}
-(void)enumElements:(id)enumImages withFont:(id)enumFonts
{
	int n;
	for (n = 0; n < otNumberOfText; n++)
	{
		[otTexts[n] enumElements:enumImages withFont:enumFonts];
	}
}

@end
