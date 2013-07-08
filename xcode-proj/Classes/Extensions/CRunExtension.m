//----------------------------------------------------------------------------------
//
// CRUNEXTENSION: Classe abstraite run extension
//
//----------------------------------------------------------------------------------
#import "CRunExtension.h"
#import "CExtension.h"
#import "CRun.h"
#import "CFile.h"
#import "CCreateObjectInfo.h"
#import "CBitmap.h"
#import "CMask.h"
#import "CActExtension.h"
#import "CCndExtension.h"
#import "CFontInfo.h"
#import "CRect.h"
#import "CImage.h"
#import "CValue.h"
#import "CObjectCommon.h"

@implementation CRunExtension

-(void)initialize:(CExtension*)hoPtr
{
	ho = hoPtr;
	rh = hoPtr->hoAdRunHeader;
}

-(int)getNumberOfConditions
{
	return 0;
}

-(BOOL)createRunObject:(CFile*)file withCOB:(CCreateObjectInfo*)cob andVersion:(int)version
{
	return false;
}

-(int)handleRunObject
{
	return REFLAG_ONESHOT;
}

-(void)displayRunObject:(CRenderer*)renderer
{
}

-(void)destroyRunObject:(BOOL)bFast
{
}

-(void)pauseRunObject
{
}

-(void)continueRunObject
{
}

-(void)getZoneInfos
{	
}

-(BOOL)condition:(int)num withCndExtension:(CCndExtension*)cnd
{
	return false;
}

-(void)action:(int)num withActExtension:(CActExtension*)act
{
}

-(CValue*)expression:(int)num
{
	return nil;
}

-(CMask*)getRunObjectCollisionMask:(int)flags
{
	return nil;
}

-(CImage*)getRunObjectSurface
{
	return nil;
}

-(CFontInfo*)getRunObjectFont
{
	return nil;
}

-(void)setRunObjectFont:(CFontInfo*)fi withRect:(CRect)rc
{	
}

-(int)getRunObjectTextColor
{
	return 0;
}

-(void)setRunObjectTextColor:(int)rgb
{
}

-(NSString*)description
{
	return [NSString stringWithString:ho->hoCommon->pCOI->oiName];
}

@end
