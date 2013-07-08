//----------------------------------------------------------------------------------
//
// CObjInfo informations sur un objet
//
//----------------------------------------------------------------------------------
#import "CObjInfo.h"
#import "COI.h"
#import "CObjectCommon.h"

@implementation CObjInfo

-(id)init
{
	oilColList=nil;
	return self;
}

-(void)dealloc
{
	if (oilName!=nil)
	{
		[oilName release];
	}
    if (oilColList!=nil)
    {
        free(oilColList);
    }
	[super dealloc];
}
-(void)copyData:(COI*)oiPtr
{
	// Met dans l'OiList
	oilOi = oiPtr->oiHandle;
	oilType = oiPtr->oiType;
	
	oilOIFlags = oiPtr->oiFlags;
	CObjectCommon* ocPtr = (CObjectCommon*) oiPtr->oiOC;
	oilOCFlags2 = ocPtr->ocFlags2;
	oilInkEffect = oiPtr->oiInkEffect;
	oilEffectParam = oiPtr->oiInkEffectParam;
	oilOEFlags = ocPtr->ocOEFlags;
	oilBackColor = ocPtr->ocBackColor;
	oilEventCount = 0;
	oilObject = -1;
	oilLimitFlags = (short) OILIMITFLAGS_ALL;
    oilName=nil;
	if (oiPtr->oiName != nil)
	{
		oilName = [[NSString alloc] initWithString:oiPtr->oiName];
	}
	int q;
	for (q = 0; q < 8; q++)
	{
		oilQualifiers[q] = ocPtr->ocQualifiers[q];
	}
}

-(NSString*)description
{
	return [NSString stringWithFormat:@"CObjInfo: Name: '%@' oi: %i  nObjects: %i", oilName, oilOi, oilNObjects];
}

@end
