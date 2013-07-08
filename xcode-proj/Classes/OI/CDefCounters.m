//----------------------------------------------------------------------------------
//
// CDEFCOUNTERS : DonnÈes d'un objet score / vies / counter
//
//----------------------------------------------------------------------------------
#import "CDefCounters.h"
#import "CFile.h"
#import "IEnum.h"

@implementation CDefCounters

-(id)init
{
	frames=nil;
	return self;
}
-(void)dealloc
{
	if (frames!=nil)
	{
		free(frames);
	}
	[super dealloc];
}

-(void)load:(CFile*)file
{
	[file skipBytes:4];          // size
	odCx=[file readAInt];
	odCy=[file readAInt];
	odPlayer=[file readAShort];
	odDisplayType=[file readAShort];
	odDisplayFlags=[file readAShort];
	odFont=[file readAShort];
	
	switch (odDisplayType)
	{
		case 0:             // CTA_HIDDEN
			break;
		case 1:             // CTA_DIGITS
		case 4:             // CTA_ANIM
			nFrames=[file readAShort];
			frames=(short*)malloc(nFrames*sizeof(short));
			int n;
			for (n=0; n<nFrames; n++)
			{
				frames[n]=[file readAShort];
			}
			break;
		case 2:             // CTA_VBAR
		case 3:             // CTA_HBAR
		case 5:             // CTA_TEXT
			ocBorderSize=[file readAShort];
			ocBorderColor=[file readAColor];
			ocShape=[file readAShort];
			ocFillType=[file readAShort];
			if (ocShape==1)		// SHAPE_LINE
			{
				ocLineFlags=[file readAShort];
			}
			else
			{
				switch (ocFillType)
				{
					case 1:			    // FILLTYPE_SOLID
						ocColor1=[file readAColor];
						break;
					case 2:			    // FILLTYPE_GRADIENT
						ocColor1=[file readAColor];
						ocColor2=[file readAColor];
						ocGradientFlags=[file readAInt];
						break;
					case 3:			    // FILLTYPE_IMAGE
						break;
				}
			}
			break;
	}
}
-(void)enumElements:(id)enumImages withFont:(id)enumFonts
{
	short num;
	int n;
	switch(odDisplayType)
	{
		case 1:             // CTA_DIGITS
		case 4:             // CTA_ANIM
			for (n=0; n<nFrames; n++)
			{
				if (enumImages!=nil)
				{
					id<IEnum> pImages=enumImages;
					num=[pImages enumerate:frames[n]]; 
					if (num!=-1)
					{
						frames[n]=num;
					}
				}
			}
			break;
		case 5:             // CTA_TEXT
			if (enumFonts!=nil)
			{
				id<IEnum> pFonts=enumFonts;
				num=[pFonts enumerate:odFont];
				if (num!=-1)
				{
					odFont=num;
				}
			}
			break;
	}
}

@end
