//----------------------------------------------------------------------------------
//
// CANIMDIR : Une direction d'animation
//
//----------------------------------------------------------------------------------
#import "CAnimDir.h"
#import "CFile.h"
#import "IEnum.h"

@implementation CAnimDir

-(void)dealloc
{
	free(adFrames);
	[super dealloc];
}
-(void)load:(CFile*)file 
{
	adMinSpeed=[file readAByte];
	adMaxSpeed=[file readAByte];
	adRepeat=[file readAShort];
	adRepeatFrame=[file readAShort];
	adNumberOfFrame=[file readAShort];
    
	adFrames=(short*)malloc(adNumberOfFrame*sizeof(short));
	int n;
	for (n=0; n<adNumberOfFrame; n++)
	{
		adFrames[n]=[file readAShort];
	}
}
-(void)enumElements:(id)enumImages
{
	int n;
	for (n=0; n<adNumberOfFrame; n++)
	{
	    if (enumImages!=nil)
	    {
			id<IEnum> pImages=enumImages;
			short num=[pImages enumerate:adFrames[n]];
			if (num!=-1)
			{
				adFrames[n]=num;
			}
	    }
	}
}

@end
