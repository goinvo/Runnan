//----------------------------------------------------------------------------------
//
// CLAYER : classe layer
//
//----------------------------------------------------------------------------------
#import "CLayer.h"
#import "CFile.h"
#import "CArrayList.h"

@implementation CLayer

-(id)init
{
	pBkd2=nil;
	pLadders=nil;
	m_loZones = nil;
	return self;
}
-(void)dealloc
{
	[pBkd2 clearRelease];
	[pLadders clearRelease];
	[pBkd2 release];
	[pLadders release];
	[pName release];
	
	if(m_loZones != nil)
	{
		[m_loZones clearRelease];
		[m_loZones release];
	}
	[super dealloc];
}
-(void)load:(CFile*)file
{
	dwOptions=[file readAInt];
	xCoef=[file readAFloat];
	yCoef=[file readAFloat];
	nBkdLOs=[file readAInt];
	nFirstLOIndex=[file readAInt];
	pName=[file readAString];
	
	backUp_dwOptions=dwOptions;
	backUp_xCoef=xCoef;
	backUp_yCoef=yCoef;
	backUp_nBkdLOs=nBkdLOs;
	backUp_nFirstLOIndex=nFirstLOIndex;
}
@end
