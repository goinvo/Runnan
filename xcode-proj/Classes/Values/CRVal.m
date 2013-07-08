//----------------------------------------------------------------------------------
//
// CRVAL : Alterable values et strings
//
//----------------------------------------------------------------------------------
#import "CRVal.h"
#import "CValue.h"
#import "CObjectCommon.h"
#import "CCreateObjectInfo.h"
#import "CDefValues.h"
#import "CDefStrings.h"

@implementation CRVal

-(void)dealloc
{
	int n;
	for (n=0; n<VALUES_NUMBEROF_ALTERABLE; n++)
	{
		if (rvValues[n]!=nil)
		{
			[rvValues[n] release];
		}
	}
	free(rvValues);
	for (n=0; n<STRINGS_NUMBEROF_ALTERABLE; n++)
	{
		if (rvStrings[n]!=nil)
		{
			[rvStrings[n] release];
		}
	}
	free(rvStrings);
	[super dealloc];
}
-(id)initWithHO:(CObject*)ho andOC:(CObjectCommon*)ocPtr andCOB:(CCreateObjectInfo*)cob
{
	self=[super init];
	
	// Creation des tableaux
	rvValueFlags=0;
	rvValues=(CValue**)calloc(VALUES_NUMBEROF_ALTERABLE, sizeof(CValue*));
	rvStrings=(NSString**)calloc(STRINGS_NUMBEROF_ALTERABLE, sizeof(NSString*));
	
	// Initialisation des valeurs
	int n;
	if (ocPtr->ocValues!=nil)
	{
	    CValue* value;
	    for (n=0; n<ocPtr->ocValues->nValues; n++)
	    {
			value=[self getValue:n];
			[value forceInt:ocPtr->ocValues->values[n]];
	    }
	}
	if (ocPtr->ocStrings!=nil)
	{
	    for (n=0; n<ocPtr->ocStrings->nStrings; n++)
	    {
			rvStrings[n]=[[NSString alloc] initWithString:ocPtr->ocStrings->strings[n]];
	    }
	}
	
	return self;
}
			
-(void)kill:(BOOL)bFast
{
}

-(CValue*)getValue:(int)n
{
	if (rvValues[n]==nil)
	{
	    rvValues[n]=[[CValue alloc] init];
	}
	return rvValues[n];
}

-(NSString*)getString:(int)n
{
	if (rvStrings[n]==nil)
	{
	    rvStrings[n]=[NSString string];
	}
	return rvStrings[n];
}
-(void)setString:(int)n withString:(NSString*)s
{
	if (rvStrings[n]!=nil)
	{
		[rvStrings[n] release];
	}
	rvStrings[n]=[[NSString alloc] initWithString:s];
}

@end
