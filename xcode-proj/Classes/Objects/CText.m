//----------------------------------------------------------------------------------
//
// CText : Objet string
//
//----------------------------------------------------------------------------------
#import "CText.h"
#import "CRun.h"
#import "CRSpr.h"
#import "CObjectCommon.h"
#import "CMask.h"
#import "CSprite.h"
#import "CImageBank.h"
#import "CCreateObjectInfo.h"
#import "CValue.h"
#import "CDefTexts.h"
#import "CRunApp.h"
#import "CFontBank.h"
#import "CRect.h"
#import "CFontInfo.h"
#import "CRCom.h"
#import "CDefText.h"
#import "CServices.h"
#import "CBitmap.h"
#import "CRenderer.h"
#import "CTextSurface.h"

@implementation CText

-(void)dealloc
{
	if (rsTextBuffer!=nil)
	{
		[rsTextBuffer release];
	}
	[textSurface release];
	[super dealloc];
}

-(void)initObject:(CObjectCommon*)ocPtr withCOB:(CCreateObjectInfo*)cob
{
	rsFlag = 0;										// ???? adlo->loFlags;
	CDefTexts* txt = (CDefTexts*) ocPtr->ocObject;
	hoImgWidth = txt->otCx;
	hoImgHeight = txt->otCy;
	rsBoxCx = txt->otCx;
	rsBoxCy = txt->otCy;
	
	// Recuperer la couleur et le nombre de phrases
	rsMaxi = txt->otNumberOfText;
	rsTextColor=0;
	if (txt->otNumberOfText>0)
	{
		rsTextColor = txt->otTexts[0]->tsColor;
	}
	rsHidden = (unsigned char) cob->cobFlags;					// A Toujours?
	rsTextBuffer = @"";
	rsFont = -1;
	rsMini = 0;
	if ((rsHidden & COF_FIRSTTEXT) != 0)
	{
		if (txt->otNumberOfText>0)
		{
			rsTextBuffer = [[NSString alloc] initWithString:txt->otTexts[0]->tsText];
		}
		else
		{
			rsTextBuffer=[[NSString alloc] init];
		}
	}
	
	textSurface = [[CTextSurface alloc] initWidthWidth:hoImgWidth andHeight:hoImgHeight];
}

-(void)handle
{
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

-(void)draw:(CRenderer*)renderer
{
	CDefTexts* txt = (CDefTexts*) hoCommon->ocObject;
	if(txt->otNumberOfText == 0)
		return;	
	short flags = txt->otTexts[0]->tsFlags;
	
	int effect = ros->rsEffect;
	int effectParam = ros->rsEffectParam;
	
	// Get font
	short nFont = rsFont;
	if (nFont == -1)
	{
		if (txt->otNumberOfText>0)
		{
			nFont = txt->otTexts[0]->tsFont;
		}
	}
	CFont* font = [hoAdRunHeader->rhApp->fontBank getFontFromHandle:nFont];
	
	// Affichage
	NSString* s = nil;
	if (rsMini >= 0)
	{
		s = txt->otTexts[rsMini]->tsText;
	}
	else
	{
		s = rsTextBuffer;
		if (s == nil)
		{
			s = @"";
		}
	}
	
	// Allow only the following flags
	short dtflags = (short) (flags & (DT_LEFT | DT_CENTER | DT_RIGHT | DT_TOP | DT_BOTTOM | DT_VCENTER | DT_SINGLELINE));
	// Adjust rectangle
	CRect rc;
	rc.left = hoX - hoAdRunHeader->rhWindowX;
	rc.top = hoY - hoAdRunHeader->rhWindowY;
	rc.right = rc.left + rsBoxCx;
	rc.bottom = rc.top + rsBoxCy;
	
	[textSurface setText:s withFlags:dtflags andColor:rsTextColor andFont:font];
	[textSurface draw:renderer withX:rc.left andY:rc.top+deltaY andEffect:effect andEffectParam:effectParam];
}

-(CMask*)getCollisionMask:(int)flags
{
	return nil;
}

-(CFontInfo*)getFont
{
	short nFont = rsFont;
	if (nFont == -1)
	{
		CDefTexts* txt = (CDefTexts*) hoCommon->ocObject;
		if(txt->otNumberOfText == 0)
			return nil;
		nFont = txt->otTexts[0]->tsFont;
	}
	return [hoAdRunHeader->rhApp->fontBank getFontInfoFromHandle:nFont];
}

-(void)setFont:(CFontInfo*)info withRect:(CRect)pRc
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

-(int)getFontColor
{
	return rsTextColor;
}

-(void)setFontColor:(int)rgb
{
	rsTextColor = rgb;
	[self modif];
	roc->rcChanged = YES;
}

-(BOOL)txtChange:(int)num
{
	if (num < -1)
	{
		num = -1;							// -1==chaine stockee...
	}
	if (num >= rsMaxi)
	{
		num = rsMaxi - 1;
	}
	if (num == rsMini)
	{
		return NO;
	}
	
	rsMini = num;
	
	// -------------------------------
	// Recopie le texte dans la chaine
	// -------------------------------
	if (num >= 0)
	{
		CDefTexts* txt = (CDefTexts*) hoCommon->ocObject;
		[self txtSetString:txt->otTexts[rsMini]->tsText];
	}
	
	// Reafficher ou pas?
	// ------------------
	if ((ros->rsFlags & RSFLAG_HIDDEN) != 0)
	{
		return NO;
	}
	return YES;
}

-(void)txtSetString:(NSString*)s
{
	if (rsTextBuffer!=nil)
	{
		[rsTextBuffer release];
	}
	rsTextBuffer = [[NSString alloc] initWithString:s];
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
