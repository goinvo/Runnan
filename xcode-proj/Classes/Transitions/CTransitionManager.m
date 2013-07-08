//----------------------------------------------------------------------------------
//
// CTRANSITIONMANAGER
//
//----------------------------------------------------------------------------------
#import "CTransitionManager.h"
#import "CRunApp.h"
#import "CBitmap.h"
#import "CTrans.h"
#import "CTransitions.h"
#import "CFile.h"
#import "CTransitionData.h"
#import "CObject.h"
#import "CRun.h"
#import "CObjectCommon.h"
#import "CRunApp.h"
#import "CImageBank.h"
#import "CImage.h"
#import "CRCom.h"
#import "CSprite.h"
#import "CRenderToTexture.h"
#import "CSpriteGen.h"

//F01
//F01END

@implementation CTransitionManager

-(id)initWithApp:(CRunApp*)a
{
	app = a;
	return self;
}

-(CTrans*)createTransition:(CTransitionData*)pData withRenderer:(CRenderer*)renderer andStart:(CRenderToTexture*)surfaceStart andEnd:(CRenderToTexture*)surfaceEnd andType:(int)type
{
	CTransitions* transitions=nil;

//F02
	//F02END
	
	if (transitions!=nil)
	{
		CTrans* trans = [transitions getTrans:pData];
		[app->file seek:pData->dataOffset];
		[trans setApp:app];
		[trans initialize:pData withFile:app->file andRenderer:renderer andStart:surfaceStart andEnd:surfaceEnd andType:type];
		[transitions release];
		return trans;
	}
	return nil;
}

-(CTrans*)startObjectFade:(CObject*)hoPtr withFlag:(BOOL)bFadeOut
{
	CRunApp* runApp = hoPtr->hoAdRunHeader->rhApp;
	CRenderer* renderer = runApp->renderer;	
	CTransitionData* pData = bFadeOut ? hoPtr->hoCommon->ocFadeOut : hoPtr->hoCommon->ocFadeIn;

	int width=hoPtr->hoImgWidth;
	int height=hoPtr->hoImgHeight;
	
	CRenderToTexture* surface1 = [[CRenderToTexture alloc] initWithWidth:width andHeight:height andRunApp:runApp];
	CRenderToTexture* surface2 = [[CRenderToTexture alloc] initWithWidth:width andHeight:height andRunApp:runApp];

	CSprite* sprite = [hoPtr->roc->rcSprite retain];
	if(sprite == nil)
	{
		if((hoPtr->hoOEFlags & OEFLAG_ANIMATIONS) == 0)
			return nil;
		sprite = [[CSprite alloc] initWithBank:app->imageBank];
		sprite->sprImg = hoPtr->roc->rcImage;
	}
	else
	{
		[renderer setOriginX:-sprite->sprX1 andY:-sprite->sprY1];
	}

	//Prepare surfaces for the transition images
	if (bFadeOut)
	{
		[surface1 bindFrameBuffer];
		[app->spriteGen drawSprite:sprite withRenderer:renderer];
		[surface1 unbindFrameBuffer];
		
		if ((pData->transFlags&TRFLAG_COLOR)!=0)
		{
			[surface2 bindFrameBuffer];
			[app->spriteGen drawSprite:sprite withRenderer:renderer];
			[surface2 unbindFrameBuffer];
			[surface2 clearColorChannelWithColor:pData->transColor];
		}
	}
	else
	{
		[surface2 bindFrameBuffer];
		[app->spriteGen drawSprite:sprite withRenderer:renderer];
		[surface2 unbindFrameBuffer];
		
		if ((pData->transFlags&TRFLAG_COLOR)!=0)
		{
			[surface1 bindFrameBuffer];
			[app->spriteGen drawSprite:sprite withRenderer:renderer];
			[surface1 unbindFrameBuffer];
			[surface1 clearColorChannelWithColor:pData->transColor];
		}
	}
	[renderer setOriginX:0 andY:0];
	[sprite release];

	// Charge la transition
	CTrans* pTrans=nil;
	pTrans=[self createTransition:pData withRenderer:runApp->renderer andStart:surface1 andEnd:surface2 andType:1];
	int trFlags=0;
	if ((hoPtr->hoFlags&HOF_FADEOUT)!=0)
		trFlags |= TRFLAG_FADEOUT;
	else
		trFlags |= TRFLAG_FADEIN;

	return pTrans;
}

@end
