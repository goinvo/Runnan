//----------------------------------------------------------------------------------
//
// COCBACKGROUND : un objet dÈcor normal
//
//----------------------------------------------------------------------------------
#import "COCBackground.h"
#import "CFile.h"
#import "IEnum.h"
#import "COI.h"

@implementation COCBackground

-(id)init
{
	self=[super init];
	return self;
}
-(void)dealloc
{
	[super dealloc];
}
-(void)load:(CFile*)file withType:(short)type andCOI:(COI*)pOI
{
	pCOI=pOI;
	[file skipBytes:4];		// ocDWSize
	ocObstacleType=[file readAShort];
	ocColMode=[file readAShort];
	ocCx=[file readAInt];
	ocCy=[file readAInt];
	ocImage=[file readAShort];
}

-(void)enumElements:(id)enumImages withFont:(id)enumFonts
{
	if (enumImages!=nil)
	{
		id<IEnum> pImages=enumImages;
	    short num=[pImages enumerate:ocImage];
	    if (num!=-1)
	    {
			ocImage=num;
	    }
	}
}

-(void)spriteDraw:(CBitmap*)g withSprite:(CSprite*)spr andImageBank:(CImageBank*)bank andX:(int)x andY:(int)y
{
}

-(void)spriteKill:(CSprite*)spr
{
}
-(CMask*)spriteGetMask
{
	return nil;
}

@end
