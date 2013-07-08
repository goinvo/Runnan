//----------------------------------------------------------------------------------
//
// CScore : Objet score
//
//----------------------------------------------------------------------------------
#import "CScore.h"
#import "CRun.h"
#import "CRSpr.h"
#import "CObjectCommon.h"
#import "CMask.h"
#import "CSprite.h"
#import "CImageBank.h"
#import "CCreateObjectInfo.h"
#import "CValue.h"
#import "CDefCounters.h"
#import "CRunApp.h"
#import "CFontBank.h"
#import "CRect.h"
#import "CRCom.h"
#import "CServices.h"
#import "CImage.h"
#import "CFont.h"
#import "CSpriteGen.h"
#import "CBitmap.h"
#import "CRenderer.h"
#import "CTextSurface.h"

@implementation CScore

-(void)dealloc
{
	[rsValue release];
	[textSurface release];
	[cachedString release];
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
	int* scores = [hoAdRunHeader->rhApp getScores];
	rsValue=[[CValue alloc] initWithInt:scores[rsPlayer - 1]];
	oldScore = [rsValue getInt]-1;
	
	textSurface = [[CTextSurface alloc] initWidthWidth:hoImgWidth andHeight:hoImgHeight];
	cachedString = [[NSString alloc] initWithString:@""];
	cachedLength = 0;
}

-(void)handle
{
	int* scores = [hoAdRunHeader->rhApp getScores];
	if (rsPlayer > 0 && [rsValue getInt] != scores[rsPlayer - 1])
	{
		[rsValue forceInt:scores[rsPlayer - 1]];
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

-(void)updateCachedData
{
	vInt = [rsValue getInt];
	if(vInt != oldScore)
	{
		[cachedString release];
		cachedString = [CServices intToString:vInt withFlags:displayFlags];
		cachedLength = [cachedString length];
		oldScore = vInt;
	}
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
	short img = 0;
	[self updateCachedData];
	
	switch (adCta->odDisplayType)
	{
		case 1:	    // CTA_DIGITS:
		{
			int i;
			int dx = 0;
			int dy = 0;
			for (i = 0; i < cachedLength; i++)
			{
				unichar c = [cachedString characterAtIndex:i];
				img = 0;
				switch(c)
				{
					case '-':
						img = adCta->frames[10];		// COUNTER_IMAGE_SIGN_NEG
						break;
					case '.':
						img = adCta->frames[12];		// COUNTER_IMAGE_POINT
						break;
					case '+':
						img = adCta->frames[11];	// COUNTER_IMAGE_SIGN_PLUS
						break;
					case 'e':
					case 'E':
						img = adCta->frames[13];	// COUNTER_IMAGE_EXP
						break;
					default:
						if (c >= '0' && c <= '9')
							img = adCta->frames[c - '0'];
						break;
				}
				CImage* ifo = [hoAdRunHeader->rhApp->imageBank getImageFromHandle:img];
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
			ht = [CServices drawText:nil withString:cachedString andFlags:(short)(dtflags|DT_CALCRECT) andRect:rc andColor:0 andFont:font andEffect:0 andEffectParam:0];
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

	[self updateCachedData];
	
	int x, y;
	switch (adCta->odDisplayType)
	{
		case 1:	    // CTA_DIGITS:
			x = hoRect.left;
			y = hoRect.top;
			
			int i;
			short img;
			for (i = 0; i < cachedLength; i++)
			{
				unichar c = [cachedString characterAtIndex:i];
				img = 0;
				switch(c)
				{
					case '-':
						img = adCta->frames[10];		// COUNTER_IMAGE_SIGN_NEG
						break;
					case '.':
						img = adCta->frames[12];		// COUNTER_IMAGE_POINT
						break;
					case '+':
						img = adCta->frames[11];	// COUNTER_IMAGE_SIGN_PLUS
						break;
					case 'e':
					case 'E':
						img = adCta->frames[13];	// COUNTER_IMAGE_EXP
						break;
					default:
						if (c >= '0' && c <= '9')
							img = adCta->frames[c - '0'];
						break;
				}
				[hoAdRunHeader->rhApp->spriteGen pasteSpriteEffect:renderer withImage:img andX:x andY:y andFlags:0 andInkEffect:effect andInkEffectParam:effectParam];
				CImage* ifo = [hoAdRunHeader->rhApp->imageBank getImageFromHandle:img];
				x += ifo->width;
			}
			break;
			
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
				[textSurface setText:cachedString withFlags:dtflags andColor:rsColor1 andFont:font];
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
		if (!CRectAreEqual(pRc, CRectNil()))
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
