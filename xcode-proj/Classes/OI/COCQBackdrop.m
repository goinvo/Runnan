//----------------------------------------------------------------------------------
//
// COBJECTCOMMON : Donn�es d'un objet normal
//
//----------------------------------------------------------------------------------
#import "COCQBackdrop.h"
#import "CFile.h"
#import "IEnum.h"
#import "CImage.h"
#import "CImageBank.h"
#import "CServices.h"
#import "CBitmap.h"
#import "CSprite.h"
#import "CRenderer.h"
#import "COI.h"

@implementation COCQBackdrop

-(id)init
{
	self=[super init];
	return self;
}
-(void)dealloc
{
	[super dealloc];
}
-(void)load:(CFile*)file withType:(short)type andCOI:(COI*)pOi
{
	pCOI=pOi;

	[file skipBytes:4];		// ocDWSize
	ocObstacleType = [file readAShort];
	ocColMode = [file readAShort];
	ocCx = [file readAInt];
	ocCy = [file readAInt];
	ocBorderSize = [file readAShort];
	ocBorderColor = [file readAColor];
	ocShape = [file readAShort];
	
	ocFillType = [file readAShort];
	if (ocShape == 1)		// SHAPE_LINE
	{
		ocLineFlags = [file readAShort];
	}
	else
	{
		switch (ocFillType)
		{
			case FILLTYPE_SOLID:
				ocColor1 = ocColor2 = [file readAColor];
				ocFillType = FILLTYPE_GRADIENT;	//Changes the solid-color to a gradient of the same color
				break;
			case FILLTYPE_GRADIENT:
				ocColor1 = [file readAColor];
				ocColor2 = [file readAColor];
				ocGradientFlags = [file readAInt];
				break;
			case FILLTYPE_MOTIF:
				ocImage = [file readAShort];
				break;
		}
	}
}
-(void)enumElements:(id)enumImages withFont:(id)enumFonts
{
	if (ocFillType == 3)		    // FILLTYPE_IMAGE
	{
		if (enumImages != nil)
		{
			id<IEnum> pImages=enumImages;
			short num = [pImages enumerate:ocImage];
			if (num != -1)
			{
				ocImage = num;
			}
		}
	}
}

-(void)spriteDraw:(CRenderer*)renderer withSprite:(CSprite*)spr andImageBank:(CImageBank*)bank andX:(int)x andY:(int)y
{
	//int borderWidth = ocBorderSize;
	int cx = ocCx;
	int cy = ocCy;
	//int borderWidth = 0;
	
	unsigned char aR, aG, aB, aA, bR, bG, bB, bA;
	
	CImage* image;
	BOOL bFilled=NO;
	
	// Rectangle Image : drawImage
	//CGContextRef context=bitmap->context;
	
	
	switch (ocFillType) {
		case FILLTYPE_MOTIF:
			
			switch (ocShape) {
				case SHAPE_RECTANGLE:
					image = [bank getImageFromHandle:ocImage];
					[renderer renderPattern:(ITexture*)image withX:x andY:y andWidth:cx andHeight:cy andInkEffect:pCOI->oiInkEffect andInkEffectParam:pCOI->oiInkEffectParam];
					
					bFilled=YES;					
					break;
				case SHAPE_ELLIPSE:
					image=[bank getImageFromHandle:ocImage];
					[renderer renderPatternEllipse:(ITexture*)image withX:x andY:y andWidth:cx andHeight:cy andInkEffect:pCOI->oiInkEffect andInkEffectParam:pCOI->oiInkEffectParam];
					bFilled=YES;
					break;
			}
			
			break;
		case FILLTYPE_GRADIENT:
			
			aR = (ocColor1 >> 16) & 255;
			aG = (ocColor1 >> 8)  & 255;
			aB = ocColor1 & 255;
			bR = (ocColor2 >> 16) & 255;
			bG = (ocColor2 >> 8)  & 255;
			bB = ocColor2 & 255;
			aA = bA = 255;
			
			if(ocGradientFlags == GRADIENT_HORIZONTAL)
			{
				unsigned char gcolors[] = {
					aR, aG, aB, aA,
					bR, bG, bB, bA,
					aR, aG, aB, aA,
					bR, bG, bB, bA
				};
				if(ocShape == SHAPE_RECTANGLE)
					[renderer renderGradient:gcolors withX:x andY:y andWidth:cx andHeight:cy andInkEffect:pCOI->oiInkEffect andInkEffectParam:pCOI->oiInkEffectParam];
				else if(ocShape == SHAPE_ELLIPSE)
					[renderer renderGradientEllipse:gcolors withX:x andY:y andWidth:cx andHeight:cy andInkEffect:pCOI->oiInkEffect andInkEffectParam:pCOI->oiInkEffectParam];			
			}
			else {
				//Colors in a Z pattern
				unsigned char gcolors[] = {
					aR, aG, aB, aA,
					aR, aG, aB, aA,
					bR, bG, bB, bA,
					bR, bG, bB, bA
				};	
			
				if(ocShape == SHAPE_RECTANGLE)
					[renderer renderGradient:gcolors withX:x andY:y andWidth:cx andHeight:cy andInkEffect:pCOI->oiInkEffect andInkEffectParam:pCOI->oiInkEffectParam];
				else if(ocShape == SHAPE_ELLIPSE)
					[renderer renderGradientEllipse:gcolors withX:x andY:y andWidth:cx andHeight:cy andInkEffect:pCOI->oiInkEffect andInkEffectParam:pCOI->oiInkEffectParam];
			}
			bFilled=YES;
			break;
	}
	
	/*
	// Dessine le tour
	if (borderWidth > 0)
	{
		CGContextSetLineWidth(context, borderWidth);
		setRGBStrokeColor(context, ocBorderColor);
		switch (ocShape)
		{
                // SHAPE_LINE
			case 1:
				if ((ocLineFlags & LINEF_INVX) != 0)
				{
					x += cx;
					cx = -cx;
				}
				if ((ocLineFlags & LINEF_INVY) != 0)
				{
					y += cy;
					cy = -cy;
				}
				drawLine(context, x, y, x+cx, y+cy);
				break;
                // SHAPE_RECTANGLE
			case 2:
				CGContextStrokeRect(context, CGRectMake(x, y, cx, cy));
				break;
                // SHAPE_ELLIPSE
			case 3:
				CGContextBeginPath(context);
				CGContextAddEllipseInRect(context, CGRectMake(x, y, cx, cy));
				CGContextDrawPath(context, kCGPathStroke);
				break;
		}
	}
		 */
}

-(void)spriteKill:(CSprite*)spr
{
}
-(CMask*)spriteGetMask
{
	return nil;
}

@end
