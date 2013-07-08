// ---------------------------------------------------------------------------------
//
// CSaveGlobal : Sauvegarde des objets globaux
//
// ---------------------------------------------------------------------------------
#import "CSaveGlobal.h"
#import "CArrayList.h"
#import "CRVal.h"

@implementation CSaveGlobal

-(id)init
{
	name=nil;
	objects=nil;
	return self;
}
-(void)dealloc
{
	[name release];
	if (objects!=nil)
	{
		[objects clearRelease];
		[objects release];
	}
	[super dealloc];
}
@end

@implementation CSaveGlobalCounter
-(id)init
{
	pValue=nil;
	return self;
}
-(void)dealloc
{
	if (pValue!=nil)
	{
		[pValue release];
	}
	[super dealloc];
}
@end

@implementation CSaveGlobalText
-(id)init
{
	pString=nil;
	return self;
}
-(void)dealloc
{
	if (pString!=nil)
	{
		[pString release];
	}
	[super dealloc];
}
@end

@implementation CSaveGlobalValues
-(id)init
{
	pStrings=nil;
	pValues=nil;
	return self;
}
-(void)dealloc
{
	int n;
	if (pStrings!=nil)
	{
		for (n=0; n<STRINGS_NUMBEROF_ALTERABLE; n++)
		{
			if (pStrings[n]!=nil)
			{
				[pStrings[n] release];
			}
		}
		free(pStrings);
	}
	if (pValues!=nil)
	{
		for (n=0; n<VALUES_NUMBEROF_ALTERABLE; n++)
		{
			if (pValues[n]!=nil)
			{
				[pValues[n] release];
			}
		}
		free(pValues);
	}
	[super dealloc];
}
@end


