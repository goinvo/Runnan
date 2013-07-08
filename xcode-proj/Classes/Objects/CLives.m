//----------------------------------------------------------------------------------
//
// CLives : Objet lives
//
//----------------------------------------------------------------------------------
#import "CLives.h"
#import "CRun.h"
#import "CRSpr.h"
#import "CObjectCommon.h"
#import "CMask.h"
#import "CSprite.h"
#import "CImageBank.h"
#import "CCreateObjectInfo.h"
#import "CValue.h"
#import "CFontInfo.h"
#import "CRunFrame.h"
#import "CFontBank.h"
#import "CRect.h"
#import "CDefCounters.h"
#import "CRunApp.h"
#import "CRCom.h"
#import "CImage.h"
#import "CFont.h"
#import "CServices.h"
#import "CSpriteGen.h"
#import "CBitmap.h"
#import "CRenderer.h"
#import "CTextSurface.h"

@implementation CLives

-(id)init
{
	self=[super init];
	rsValue=[[CValue alloc] init];
	return self;
}
-(void)dealloc
{
	[rsValue release];
	[textSurface release];
	[super dealloc];
}

-(void)initObject:(CObjectCommon*)ocPtr withCOB:(CCreateObjectInfo*)cob
{
	rsFont = -1;
	rsColor1 = 0;
	hoImgWidth = hoImgHeight = 1;		// 0
	
	CDefCounters* adCta = (CDefCounters*) hoCommon->ocCounters;
	hoImgWidth = rsBoxCx = adCta->odCx;
	hoImgHeight = rsBoxCy = adCta->odCy;
	rsColor1 = adCta->ocColor1;
	rsPlayer = adCta->odPlayer;
	displayFlags = adCta->odDisplayFlags;
	[rsValue forceInt:[hoAdRunHeader->rhApp getLives][rsPlayer - 1]];
	textSurface = [[CTextSurface alloc] initWidthWidth:hoImgWidth andHeight:hoImgHeight];
}

-(void)handle
{
	int* lives = [hoAdRunHeader->rhApp getLives];
	if (rsPlayer > 0 && [rsValue getInt] != lives[rsPlayer - 1])
	{
		[rsValue forceInt:lives[rsPlayer - 1]];
		roc->rcChanged = YES;
	}
	[ros handle];
	if (roc->rcChanged)
	{
		roc->rcChanged = NO;
		[self modif];
	}
}

-(void)modif
{
	[ros modifRoutine];	
}

-(void)display
{
	[ros displayRoutine];
}

-(void)getZoneInfos
{
	// Hidden counter?
	hoImgWidth = hoImgHeight = 1;		// 0
	if (hoCommon->ocCounters == nil)
	{
		return;
	}
	CDefCounters* adCta = (CDefCounters*) hoCommon->ocCounters;
	
	int vInt = [rsValue getInt];
	
	short img;
	CImage* ifo;
	NSString* s = [NSString stringWithFormat:@"%i", vInt];
	switch (adCta->odDisplayType)
	{
		case 4:	    // CTA_ANIM:
			if (vInt != 0)
			{
				ifo = [hoAdRunHeader->rhApp->imageBank getImageFromHandle:adCta->frames[0]];
				int lg = vInt * ifo->width;
				if (lg <= rsBoxCx)
				{
					hoImgWidth = (short) lg;
					hoImgHeight = ifo->height;
				}
				else
				{
					hoImgWidth = rsBoxCx;
					hoImgHeight = ((rsBoxCx / ifo->width) + vInt - 1) * ifo->height;
				}
				break;
			}
			hoImgWidth = hoImgHeight = 1;		// 0
			break;
		case 1:	    // CTA_DIGITS:
		{
			int i;
			int dx = 0;
			int dy = 0;
			for (i = 0; i < [s length]; i++)
			{
				unichar c = [s characterAtIndex:i];
				img = 0;
				if (c == '-')
				{
					img = adCta->frames[10];		// COUNTER_IMAGE_SIGN_NEG
				}
				else if (c == '.')
				{
					img = adCta->frames[12];		// COUNTER_IMAGE_POINT
				}
				else if (c == '+')
				{
					img = adCta->frames[11];	// COUNTER_IMAGE_SIGN_PLUS
				}
				else if (c == 'e' || c == 'E')
				{
					img = adCta->frames[13];	// COUNTER_IMAGE_EXP
				}
				else if (c >= '0' && c <= '9')
				{
					img = adCta->frames[c - '0'];
				}
				ifo = [hoAdRunHeader->rhApp->imageBank getImageFromHandle:img];
				dx += ifo->width;
				dy = max(dy, ifo->height);
			}
			hoImgWidth = dx;
			hoImgHeight = dy;
			hoImgXSpot = dx;
			hoImgYSpot = dy;
			break;
		}	
		case 5:	    // CTA_TEXT:
		{
			// Rectangle
			CRect rc;			
			rc.left = hoX - hoAdRunHeader->rhWindowX;
			rc.top = hoY - hoAdRunHeader->rhWindowY;
			rc.right = rc.left + rsBoxCx;
			rc.bottom = rc.top + rsBoxCy;
			hoImgWidth = (short) (rc.right - rc.left);
			hoImgHeight = (short) (rc.bottom - rc.top);
			hoImgXSpot = hoImgYSpot = 0;
			
			// Get font
			short nFont = rsFont;
			if (nFont == -1)
			{
				nFont = adCta->odFont;
			}
			CFont* font = [hoAdRunHeader->rhApp->fontBank getFontFromHandle:nFont];
			
			// Get exact size
			int ht = 0;
			short dtflags = (short) (DT_RIGHT | DT_VCENTER | DT_SINGLELINE);
			int x2 = rc.right;
			ht = [CServices drawText:nil withString:s andFlags:(short)(dtflags|DT_CALCRECT) andRect:rc andColor:0 andFont:font andEffect:0 andEffectParam:0];
			rc.right = x2;	// keep zone width
			if (ht != 0)
			{
				hoImgXSpot = hoImgWidth = (short) (rc.right - rc.left);
				if (hoImgHeight < (rc.bottom - rc.top))
				{
					hoImgHeight = (short) (rc.bottom - rc.top);
				}
				hoImgYSpot = hoImgHeight;
			}
			break;
		}
	}
}


-(void)draw:(CRenderer*)renderer
{
	if (hoCommon->ocCounters == nil)
	{
		return;
	}
	CDefCounters* adCta = (CDefCounters*) hoCommon->ocCounters;
	int effect = ros->rsEffect;
	int effectParam = ros->rsEffectParam;
	
	int vInt = [rsValue getInt];
	NSString* s = [NSString stringWithFormat:@"%i", vInt];
	int x, y;
	CImage* ifo;
	switch (adCta->odDisplayType)
	{
		case 4:	    // CTA_ANIM:
			if (vInt != 0)
			{
				ifo = [hoAdRunHeader->rhApp->imageBank getImageFromHandle:adCta->frames[0]];
				int x1 = hoRect.left;
				int y1 = hoRect.top;
				int x2 = hoRect.right;
				int y2 = hoRect.bottom;
				for (y = y1; y < y2 && vInt > 0; y += ifo->height)
				{
					for (x = x1; x < x2 && vInt > 0; x += ifo->width, vInt -= 1)
					{
						[hoAdRunHeader->rhApp->spriteGen pasteSpriteEffect:renderer withImage:adCta->frames[0] andX:x andY:y andFlags:0 andInkEffect:effect andInkEffectParam:effectParam];
					}
				}
			}
			break;
		case 1:	    // CTA_DIGITS:
		{
			x = hoRect.left;
			y = hoRect.top;
			
			int i;
			short img;
			for (i = 0; i < [s length]; i++)
			{
				unichar c = [s characterAtIndex:i];
				img = 0;
				if (c == '-')
				{
					img = adCta->frames[10];		// COUNTER_IMAGE_SIGN_NEG
				}
				else if (c == '.')
				{
					img = adCta->frames[12];		// COUNTER_IMAGE_POINT
				}
				else if (c == '+')
				{
					img = adCta->frames[11];	// COUNTER_IMAGE_SIGN_PLUS
				}
				else if (c == 'e' || c == 'E')
				{
					img = adCta->frames[13];	// COUNTER_IMAGE_EXP
				}
				else if (c >= '0' && c <= '9')
				{
					img = adCta->frames[c - '0'];
				}
				[hoAdRunHeader->rhApp->spriteGen pasteSpriteEffect:renderer withImage:img andX:x andY:y andFlags:0 andInkEffect:effect andInkEffectParam:effectParam];
				ifo = [hoAdRunHeader->rhApp->imageBank getImageFromHandle:img];
				x += ifo->width;
			}
			break;
		}	
		case 5:	// CTA_TEXT:
		{
			// Get font
			short nFont = rsFont;
			if (nFont == -1)
			{
				nFont = adCta->odFont;
			}
			CFont* font = [hoAdRunHeader->rhApp->fontBank getFontFromHandle:nFont];
			
			short dtflags = (short) (DT_RIGHT | DT_VCENTER | DT_SINGLELINE);
			if (hoRect.bottom - hoRect.top != 0)
			{
				[textSurface setText:s withFlags:dtflags andColor:rsColor1 andFont:font];
				[textSurface draw:renderer withX:hoRect.left andY:hoRect.top andEffect:effect andEffectParam:effectParam];
				
			}
			break;
		}
	}
}

-(CMask*)getCollisionMask:(int)flags
{
	return nil;
}


-(CFontInfo*)getFont
{
	CDefCounters* adCta = (CDefCounters*) hoCommon->ocCounters;
	if (adCta->odDisplayType == 5)	// CTA_TEXT
	{
		short nFont = rsFont;
		if (nFont == -1)
		{
			nFont = adCta->odFont;
		}
		return [hoAdRunHeader->rhApp->fontBank getFontInfoFromHandle:nFont];
	}
	return nil;
}

-(void)setFont:(CFontInfo*)info withRect:(CRect)pRc
{
	CDefCounters* adCta = (CDefCounters*) hoCommon->ocCounters;
	if (adCta->odDisplayType == 5)	// CTA_TEXT
	{
		rsFont = [hoAdRunHeader->rhApp->fontBank addFont:info];
		if(!CRectAreEqual(pRc, CRectNil()))
		{
			hoImgWidth = rsBoxCx = pRc.right - pRc.left;
			hoImgHeight = rsBoxCy = pRc.bottom - pRc.top;
		}
		[self modif];
		roc->rcChanged = YES;
	}
}

-(int)getFontColor
{
	return rsColor1;
}

-(void)setFontColor:(int)rgb
{
	rsColor1 = rgb;
	[self modif];
	roc->rcChanged = YES;
}

// IDrawable
-(void)spriteDraw:(CRenderer*)renderer withSprite:(CSprite*)spr andImageBank:(CImageBank*)bank andX:(int)x andY:(int)y
{
	[self draw:renderer];
}

-(void)spriteKill:(CSprite*)spr
{
	[spr->sprExtraInfo release];
}
-(CMask*)spriteGetMask
{
	return nil;
}


@end
