// ------------------------------------------------------------------------------
// 
// EXTENSION conditions
// 
// ------------------------------------------------------------------------------
#import "CCndExtension.h"
#import "CRun.h"
#import "CValue.h"
#import "CServices.h"

BOOL compareTo(CValue* pValue1, CValue* pValue2, short comp);


@implementation CCndExtension

-(void)initialize:(LPEVT)evtPtr
{
	pParams[0]=EVTPARAMS(evtPtr);
	
	int n;	
	for (n=1; n<evtPtr->evtNParams; n++)
	{
		pParams[n]=EVPNEXT(pParams[n-1]);
	}
}

// Recolte des parametres
// ----------------------
-(LPEVP)getParamObject:(CRun*)rhPtr withNum:(int)num
{
	return pParams[num];
}

-(int)getParamTime:(CRun*)rhPtr withNum:(int)num
{
	if (pParams[num]->evpCode == 2)	    // PARAM_TIME
	{
		return pParams[num]->evp.evpL.evpL0;
	}
	return [rhPtr get_EventExpressionInt:pParams[num]];
}
	
-(short)getParamOi:(CRun*)rhPtr withNum:(int)num
{
	return pParams[num]->evp.evpW.evpW0;
}

-(short)getParamBorder:(CRun*)rhPtr withNum:(int)num
{
	return pParams[num]->evp.evpW.evpW0;
}

-(short)getParamAltValue:(CRun*)rhPtr withNum:(int)num
{
	return pParams[num]->evp.evpW.evpW0;
}

-(short)getParamDirection:(CRun*)rhPtr withNum:(int)num
{
	return pParams[num]->evp.evpW.evpW0;
}

-(int)getParamAnimation:(CRun*)rhPtr withNum:(int)num
{
	if (pParams[num]->evpCode == 10)	    // PARAM_TIME
	{
		return pParams[num]->evp.evpW.evpW0;
	}
	return [rhPtr get_EventExpressionInt:pParams[num]];
}

-(short)getParamPlayer:(CRun*)rhPtr withNum:(int)num
{
	return pParams[num]->evp.evpW.evpW0;
}

-(LPEVP)getParamEvery:(CRun*)rhPtrw withNum:(int)num
{
	return pParams[num];
}

-(int)getParamSpeed:(CRun*)rhPtr withNum:(int)num
{
	return [rhPtr get_EventExpressionInt:pParams[num]];
}

-(LPPOS)getParamPosition:(CRun*)rhPtr withNum:(int)num
{
	return (LPPOS)pParams[num];
}

-(short)getParamJoyDirection:(CRun*)rhPtr withNum:(int)num
{
	return pParams[num]->evp.evpW.evpW0;
}

-(int)getParamExpression:(CRun*)rhPtr withNum:(int)num
{
	return [rhPtr get_EventExpressionInt:pParams[num]];
}

-(int)getParamColour:(CRun*)rhPtr withNum:(int)num
{
	if (pParams[num]->evpCode == 24)	    // PARAM_COLOUR
	{
		return swapRGB(pParams[num]->evp.evpL.evpL0);
	}
	return swapRGB([rhPtr get_EventExpressionInt:pParams[num]]);
}

-(short)getParamFrame:(CRun*)rhPtr withNum:(int)num
{
	return pParams[num]->evp.evpW.evpW0;
}

-(int)getParamNewDirection:(CRun*)rhPtr withNum:(int)num
{
	if (pParams[num]->evpCode == 29)	    // PARAM_NEWDIRECTION
	{
		return pParams[num]->evp.evpW.evpW0;
	}
	return [rhPtr get_EventExpressionInt:pParams[num]];
}

-(short)getParamClick:(CRun*)rhPtr withNum:(int)num
{
	return pParams[num]->evp.evpW.evpW0;
}


-(NSString*)getParamFilename:(CRun*)rhPtr withNum:(int)num
{
	if (pParams[num]->evpCode == 40)	    // PARAM_FILENAME
	{
		int l=strlen((char*)&pParams[num]->evp.evpW.evpW0);
		if (rhPtr->rhTempString!=nil)
		{
			[rhPtr->rhTempString release];
		}
		rhPtr->rhTempString=[[NSString alloc] initWithBytes:&pParams[num]->evp.evpW.evpW0 length:l encoding:NSWindowsCP1252StringEncoding];
		return rhPtr->rhTempString;
	}
	return [rhPtr get_EventExpressionString:pParams[num]];
}

-(NSString*)getParamExpString:(CRun*)rhPtr withNum:(int)num
{
	return [rhPtr get_EventExpressionString:pParams[num]];
}

-(double)getParamExpDouble:(CRun*)rhPtr withNum:(int)num
{
	CValue* value = [rhPtr get_EventExpressionAny:pParams[num]];
	return [value getDouble];
}
		
-(NSString*)getParamFilename2:(CRun*)rhPtr withNum:(int)num
{
	if (pParams[num]->evpCode == 63)	    // PARAM_FILENAME2
	{
		int l=strlen((char*)&pParams[num]->evp.evpW.evpW0);
		if (rhPtr->rhTempString!=nil)
		{
			[rhPtr->rhTempString release];
		}
		rhPtr->rhTempString=[[NSString alloc] initWithBytes:&pParams[num]->evp.evpW.evpW0 length:l encoding:NSWindowsCP1252StringEncoding];
		return rhPtr->rhTempString;
	}
	return [rhPtr get_EventExpressionString:pParams[num]];
}

-(BOOL)compareValues:(CRun*)rhPtr withNum:(int)num andValue:(CValue*)value
{
	CValue* value2 = [rhPtr get_EventExpressionAny:pParams[num]];
	short comp = pParams[num]->evp.evpW.evpW0;
	return compareTo(value, value2, comp);
}

-(BOOL)compareTime:(CRun*)rhPtr withNum:(int)num andTime:(int)t
{
	CValue* value2 = [[[CValue alloc] initWithInt:pParams[num]->evp.evpL.evpL0] autorelease];
	short comp = pParams[num]->evp.evpW.evpW4;
	CValue* value = [[[CValue alloc] initWithInt:t] autorelease];
	return compareTo(value, value2, comp);
}

@end
