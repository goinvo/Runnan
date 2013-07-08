//----------------------------------------------------------------------------------
//
// CRUNKCINI : objet ini
//
//----------------------------------------------------------------------------------
#import "CRunkcini.h"
#import "CIni.h"
#import "CFile.h"
#import "CRunApp.h"
#import "CBitmap.h"
#import "CCreateObjectInfo.h"
#import "CValue.h"
#import "CExtension.h"
#import "CRun.h"
#import "CActExtension.h"
#import "CCndExtension.h"
#import "CArrayList.h"
#import "CObjInfo.h"
#import "CObject.h"
#import "CRCom.h"


@implementation CRunkcini

-(int)getNumberOfConditions
{
	return 0;
}

-(BOOL)createRunObject:(CFile*)file withCOB:(CCreateObjectInfo*)cob andVersion:(int)version
{
	iniFlags=[file readAShort];
	iniName=[file readAString];
    if ([iniName length]==0)
        iniName= [[NSString alloc] initWithString:@"noname.ini"];
	
	ini=[[CIni alloc] init];
    [ini loadIni:iniName];
	saveCounter=0;
	iniCurrentGroup=[[NSString alloc] initWithString:@"Group"];
	iniCurrentItem=[[NSString alloc] initWithString:@"Item"];
	
	return NO;
}
-(void)destroyRunObject:(BOOL)bFast
{
	[ini saveIni];
	[ini release];
	[iniName release];
	[iniCurrentGroup release];
	[iniCurrentItem release];
}
-(int)handleRunObject
{
	if (saveCounter>0)
	{
		saveCounter--;
		if (saveCounter<=0)
		{
			saveCounter=0;
			[ini saveIni];
		}
	}
	return 0;
}
-(NSString*)cleanPCPath:(NSString*)srce
{
	NSRange searchRange;
	searchRange.location=0;
	searchRange.length=[srce length];
	NSRange index=[srce rangeOfString:@"\\" options:NSBackwardsSearch range:searchRange];
	if (index.location!=NSNotFound)
	{
		NSString* temp=[srce substringFromIndex:index.location+1];
		[srce release];
		return [[NSString alloc] initWithString:temp];
	}
	return srce;
}
// Actions
// -------------------------------------------------
-(void)action:(int)num withActExtension:(CActExtension*)act
{
	switch(num)
	{
	case 0:
		[self SetCurrentGroup:act];
		break;
	case 1:
		[self SetCurrentItem:act];
		break;
	case 2:
		[self SetValue:act];
		break;
	case 3:
		[self SavePosition:act];
		break;
	case 4:
		[self LoadPosition:act];
		break;        
	case 5:
		[self SetString:act];
		break;
	case 6:
		[self SetCurrentFile:act];
		break;
	case 7:
		[self SetValueItem:act];
		break;
	case 8:
		[self SetValueGroupItem:act];
		break;
	case 9:
		[self SetStringItem:act];
		break;
	case 10:
		[self SetStringGroupItem:act];
		break;
	case 11:
		[self DeleteItem:act];
		break;
	case 12:
		[self DeleteGroupItem:act];
		break;
	case 13:
		[self DeleteGroup:act];
		break;
	}	
}

-(void)SetCurrentGroup:(CActExtension*)act
{   
	[iniCurrentGroup release];
	iniCurrentGroup=[[NSString alloc] initWithString:[act getParamExpString:rh withNum: 0]];
}
-(void)SetCurrentItem:(CActExtension*)act
{       
	[iniCurrentItem release];
	iniCurrentItem=[[NSString alloc] initWithString:[act getParamExpString:rh withNum:0]];
}
-(void)SetValue:(CActExtension*)act
{     
	int value=[act getParamExpression:rh withNum:0];
	NSString* s=[NSString stringWithFormat:@"%d", value];
	[ini writePrivateProfileString:iniCurrentGroup  withParam1:iniCurrentItem  andParam2:s  andParam3:iniName];
	saveCounter=50;
}
-(void)SavePosition:(CActExtension*)act
{        
	CObject* hoPtr = [act getParamObject:rh withNum:0];
	NSString* s=[NSString stringWithFormat:@"%d,%d", hoPtr->hoX, hoPtr->hoY];
	NSString* item=[NSString stringWithFormat:@"pos.%@", hoPtr->hoOiList->oilName];
	[ini writePrivateProfileString:iniCurrentGroup  withParam1:item  andParam2:s  andParam3:iniName];
	saveCounter=50;
}
-(void)LoadPosition:(CActExtension*)act
{        
	CObject* hoPtr = [act getParamObject:rh withNum:0];
	NSString* item=[NSString stringWithFormat:@"pos.%@", hoPtr->hoOiList->oilName];
	NSString* s=[ini getPrivateProfileString:iniCurrentGroup  withParam1:item  andParam2:@"X"  andParam3:iniName];
	if ([s compare:@"X"]!=0)
	{
		NSRange r=[s rangeOfString:@","];
		if (r.location!=NSNotFound)
		{
			int virgule=r.location;		
			NSString* left=[s substringToIndex:virgule];
			NSString* right=[s substringFromIndex:virgule+1];
			hoPtr->hoX=[left intValue];
			hoPtr->hoY=[right intValue];
			hoPtr->roc->rcChanged = YES;
			hoPtr->roc->rcCheckCollides = YES;
		}
	}
}
-(void)SetString:(CActExtension*)act
{        
	NSString* s=[act getParamExpString:rh withNum:0];
	[ini writePrivateProfileString:iniCurrentGroup  withParam1:iniCurrentItem  andParam2:s  andParam3:iniName];
	saveCounter=50;
}
-(void)SetCurrentFile:(CActExtension*)act
{        
	[iniName release];
	iniName=[[NSString alloc] initWithString:[act getParamExpString:rh withNum:0]];
}
-(void)SetValueItem:(CActExtension*)act
{        
	NSString* item=[act getParamExpString:rh withNum:0];
	int value=[act getParamExpression:rh withNum:1];
	NSString* s=[NSString stringWithFormat:@"%d", value];
	[ini writePrivateProfileString:iniCurrentGroup  withParam1:item  andParam2:s  andParam3:iniName];
	saveCounter=50;
}
-(void)SetValueGroupItem:(CActExtension*)act
{        
	NSString* group=[act getParamExpString:rh withNum:0];
	NSString* item=[act getParamExpString:rh withNum:1];
	int value=[act getParamExpression:rh withNum:2];
	NSString* s=[NSString stringWithFormat:@"%d", value];
	[ini writePrivateProfileString:group  withParam1:item  andParam2:s  andParam3:iniName];
	saveCounter=50;
}
-(void)SetStringItem:(CActExtension*)act
{
	NSString* item=[act getParamExpString:rh withNum:0];
	NSString* s=[act getParamExpString:rh withNum:1];
	[ini writePrivateProfileString:iniCurrentGroup  withParam1:item  andParam2:s  andParam3:iniName];
	saveCounter=50;
}
-(void)SetStringGroupItem:(CActExtension*)act
{        
	NSString* group=[act getParamExpString:rh withNum:0];
	NSString* item=[act getParamExpString:rh withNum:1];
	NSString* s=[act getParamExpString:rh withNum:2];
	[ini writePrivateProfileString:group  withParam1:item  andParam2:s  andParam3:iniName];
	saveCounter=50;
}
-(void)DeleteItem:(CActExtension*)act
{        
	[ini deleteItem:iniCurrentGroup withParam1:[act getParamExpString:rh withNum:0] andParam2:iniName];
	saveCounter=50;
}
-(void)DeleteGroupItem:(CActExtension*)act
{        
	[ini deleteItem:[act getParamExpString:rh withNum:0] withParam1:[act getParamExpString:rh withNum:1] andParam2:iniName];
	saveCounter=50;
}
-(void)DeleteGroup:(CActExtension*)act
{        
	[ini deleteGroup:[act getParamExpString:rh withNum:0] withParam1:iniName];
	saveCounter=50;
}

// Expressions
// --------------------------------------------
-(CValue*)expression:(int)num
{
	switch(num)
	{
	case 0:
		return [self GetValue];
	case 1:
		return [self GetString];
	case 2:
		return [self GetValueItem];
	case 3:
		return [self GetValueGroupItem];
	case 4:
		return [self GetStringItem];
	case 5:
		return [self GetStringGroupItem];
	}
	return nil;
}

-(CValue*)GetValue
{     
	NSString* s=[ini getPrivateProfileString:iniCurrentGroup withParam1:iniCurrentItem andParam2:@"" andParam3:iniName];
	int value=[s intValue];
	[s release];
	return [rh getTempValue:value];
}
-(CValue*)GetString
{     
	NSString* s=[ini getPrivateProfileString:iniCurrentGroup withParam1:iniCurrentItem andParam2:@"" andParam3:iniName];
	CValue* ret=[rh getTempValue:0];
	[ret forceString:s];
	[s release];
	return ret;
}
-(CValue*)GetValueItem
{     
	NSString* item=[[ho getExpParam] getString];
	NSString* s=[ini getPrivateProfileString:iniCurrentGroup  withParam1:item  andParam2:@""  andParam3:iniName];
	int value=[s intValue];
	[s release];
	return [rh getTempValue:value];
}
-(CValue*)GetValueGroupItem
{     
	NSString* group=[[ho getExpParam] getString];
	NSString* item=[[ho getExpParam] getString];
	NSString* s=[ini getPrivateProfileString:group  withParam1:item  andParam2:@""  andParam3:iniName];
	int value=[s intValue];
	[s release];
	return [rh getTempValue:value];
}
-(CValue*)GetStringItem
{     
	NSString* item=[[ho getExpParam] getString];
	NSString* s=[ini getPrivateProfileString:iniCurrentGroup  withParam1:item  andParam2:@""  andParam3:iniName];
	CValue* ret=[rh getTempValue:0];
	[ret forceString:s];
	[s release];
	return ret;
}
-(CValue*)GetStringGroupItem
{     
	NSString* group=[[ho getExpParam] getString];
	NSString* item=[[ho getExpParam] getString];
	NSString* s=[ini getPrivateProfileString:group  withParam1:item  andParam2:@""  andParam3:iniName];
	CValue* ret=[rh getTempValue:0];
	[ret forceString:s];
	[s release];
	return ret;
}

@end

