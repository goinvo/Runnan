//----------------------------------------------------------------------------------
//
// COBJECT : Classe de base d'un objet'
//
//----------------------------------------------------------------------------------
#import "CObject.h"
#import "CRun.h"
#import "CRCom.h"
#import "CRAni.h"
#import "CRMvt.h"
#import "CRVal.h"
#import "CRSpr.h"
#import "CObjInfo.h"
#import "CArrayList.h"
#import "CObjectCommon.h"
#import "CRect.h"
#import "CImage.h"
#import "CMask.h"
#import "CSprite.h"
#import "CImageBank.h"
#import "CRunApp.h"
#import "CBitmap.h"
#import "CServices.h"
#import "CRCom.h"
#import "CMove.h"
#import "CEventProgram.h"
#import "CRunApp.h"
#import "CQualToOiList.h"
#import "ObjectSelection.h"

@implementation CObject

-(void)dealloc
{
	if(replacedColors != nil)
	{
		[replacedColors freeRelease];
		[replacedColors release];
		replacedColors = nil;
	}
	if (hoPrevNoRepeat!=nil)
	{
		[hoPrevNoRepeat release];
	}
	if (hoBaseNoRepeat!=nil)
	{
		[hoBaseNoRepeat release];
	}
	if (roc!=nil)
	{
		[roc release];
		roc = nil;
	}
	if (rom!=nil)
	{
		[rom release];
		rom = nil;
	}
	if (rov!=nil)
	{
		[rov release];
		rov = nil;
	}
	if (ros!=nil)
	{
		[ros release];
		ros = nil;
	}
	if (roa!=nil)
	{
		[roa release];
		roa = nil;
	}
	[super dealloc];
}
-(void)setScale:(float)fScaleX withScaleY:(float)fScaleY andFlag:(BOOL)bResample
{
	BOOL bOldResample = NO;
	if ((ros->rsFlags & RSFLAG_SCALE_RESAMPLE) != 0)
	{
		bOldResample = YES;
	}
	
	if (roc->rcScaleX != fScaleX || roc->rcScaleY != fScaleY || bOldResample != bResample)
	{
		roc->rcScaleX = fScaleX;
		roc->rcScaleY = fScaleY;
		ros->rsFlags &= ~RSFLAG_SCALE_RESAMPLE;
		if (bResample)
		{
			ros->rsFlags |= RSFLAG_SCALE_RESAMPLE;
		}
		roc->rcChanged = YES;
		
		ImageInfo ifo = [hoAdRunHeader->rhApp->imageBank getImageInfoEx:roc->rcImage withAngle:roc->rcAngle andScaleX:roc->rcScaleX andScaleY:roc->rcScaleY];
		hoImgWidth=ifo.width;
		hoImgHeight=ifo.height;
		hoImgXSpot=ifo.xSpot;
		hoImgYSpot=ifo.ySpot;
	}
}

-(void)setBoundingBoxFromWidth:(int)cx andHeight:(int)cy andXSpot:(int)hsx andYSpot:(int)hsy
{
	int nAngle = roc->rcAngle;
	float fScaleX = roc->rcScaleX;
	float fScaleY = roc->rcScaleY;
	
	// No rotation
	if ( nAngle == 0 )
	{
		// Stretch en X
		if ( fScaleX != 1.0f )
		{
			hsx = (int)(hsx * fScaleX);
			cx = (int)(cx * fScaleX);
		}
		
		// Stretch en Y
		if ( fScaleY != 1.0f )
		{
			hsy = (int)(hsy * fScaleY);
			cy = (int)(cy * fScaleY);
		}
	}
	
	// Rotation
	else
	{
		// Calculate dimensions
		if ( fScaleX != 1.0f )
		{
			hsx = (int)(hsx * fScaleX);
			cx = (int)(cx * fScaleX);
		}
		
		if ( fScaleY != 1.0f )
		{
			hsy = (int)(hsy * fScaleY);
			cy = (int)(cy * fScaleY);
		}
		
		// Rotate
		float cosa;
		float sina;
		
		switch (nAngle) 
		{
			case 90:
				cosa = 0.0f;
				sina = 1.0f;
				break;
			case 270:
				cosa = 0.0f;
				sina = -1.0f;
				break;
			default:
			{
				float alpha = nAngle * _PI / 180.0f;
				cosa = cosf(alpha);
				sina = sinf(alpha);
				break;
			}
		}
		
		int nx2, ny2;
		int	nx4, ny4;
		
		if ( sina >= 0.0f )
		{
			nx2 = (int)(cy * sina + 0.5f);		// (1.0f-sina));		// 1-sina est ici pour l'arrondi ??
			ny4 = -(int)(cx * sina + 0.5f);		// (1.0f-sina));
		}
		else
		{
			nx2 = (int)(cy * sina - 0.5f);		// (1.0f-sina));
			ny4 = -(int)(cx * sina - 0.5f);		// (1.0f-sina));
		}
		
		if ( cosa == 0.0f )
		{
			ny2 = 0;
			nx4 = 0;
		}
		else if ( cosa > 0 )
		{
			ny2 = (int)(cy * cosa + 0.5f);		// (1.0f-cosa));
			nx4 = (int)(cx * cosa + 0.5f);		// (1.0f-cosa));
		}
		else
		{
			ny2 = (int)(cy * cosa - 0.5f);		// (1.0f-cosa));
			nx4 = (int)(cx * cosa - 0.5f);		// (1.0f-cosa));
		}
		
		int nx3 = nx2 + nx4;
		int ny3 = ny2 + ny4;
		int nhsx = (int)(hsx * cosa + hsy * sina);
		int nhsy = (int)(hsy * cosa - hsx * sina);
		
		// Faire translation par rapport au hotspot
		int nx1 = 0;	// -nhsx;
		int ny1 = 0;	// -nhsy;
		
		// Calculer la nouvelle bounding box (? optimiser ?ventuellement)
		int x1 = min(nx1, nx2);
		x1 = min(x1, nx3);
		x1 = min(x1, nx4);
		
		int x2 = max(nx1, nx2);
		x2 = max(x2, nx3);
		x2 = max(x2, nx4);
		
		int y1 = min(ny1, ny2);
		y1 = min(y1, ny3);
		y1 = min(y1, ny4);
		
		int y2 = max(ny1, ny2);
		y2 = max(y2, ny3);
		y2 = max(y2, ny4);
		
		cx = x2 - x1;
		cy = y2 - y1;
		
		hsx = -(x1 - nhsx);
		hsy = -(y1 - nhsy);
	}			

	hoImgWidth = cx;
	hoImgHeight = cy;
	hoImgXSpot = hsx;
	hoImgYSpot = hsy;
}

-(int)fixedValue
{
	return (hoCreationId << 16) + (((int)hoNumber) & 0xFFFF);
}

-(int)getX
{
	return hoX;
}

-(int)getY
{
	return hoY;
}

-(int)getWidth
{
	return hoImgWidth;
}

-(int)getHeight
{
	return hoImgHeight;
}

-(void)setX:(int)x
{
	if (rom != nil)
	{
		[rom->rmMovement setXPosition:x];
	}
	else
	{
		hoX = x;
		if (roc != nil)
		{
			roc->rcChanged = YES;
			roc->rcCheckCollides = YES;
		}
	}
}

-(void)setY:(int)y
{
	if (rom != nil)
	{
		[rom->rmMovement setYPosition:y];
	}
	else
	{
		hoY = y;
		if (roc != nil)
		{
			roc->rcChanged = YES;
			roc->rcCheckCollides = YES;
		}
	}
}

-(void)setWidth:(int)width
{
	hoImgWidth = width;
	hoRect.right = hoRect.left + width;
}

-(void)setHeight:(int)height
{
	hoImgHeight = height;
	hoRect.bottom = hoRect.top + height;
}

-(void)generateEvent:(int)code withParam:(int)param
{
	if (hoAdRunHeader->rh2PauseCompteur == 0)
	{
		int p0 = hoAdRunHeader->rhEvtProg->rhCurParam[0];
		hoAdRunHeader->rhEvtProg->rhCurParam[0] = param;
		
		code = (-(code + EVENTS_EXTBASE + 1) << 16);
		code |= (((int) hoType) & 0xFFFF);
		[hoAdRunHeader->rhEvtProg handle_Event:self withCode:code];
		
		hoAdRunHeader->rhEvtProg->rhCurParam[0] = p0;
	}
}

-(void)pushEvent:(int)code withParam:(int)param
{
	if (hoAdRunHeader->rh2PauseCompteur == 0)
	{
		code = (-(code + EVENTS_EXTBASE + 1) << 16);
		code |= (((int) hoType) & 0xFFFF);
		[hoAdRunHeader->rhEvtProg push_Event:1 withCode:code andParam:param andObject:self andOI:hoOi];
	}
}

-(void)pause
{
	[hoAdRunHeader pause];
}

-(void)resume
{
	[hoAdRunHeader resume];
}

-(void)redisplay
{
	[hoAdRunHeader ohRedrawLevel:YES];
}

-(void)redraw
{
	[self modif];
	if ((hoOEFlags & (OEFLAG_ANIMATIONS | OEFLAG_MOVEMENTS | OEFLAG_SPRITES)) != 0)
	{
		roc->rcChanged = YES;
	}
}

-(void)destroy
{
	[hoAdRunHeader destroy_Add:hoNumber];
}

-(void)setPosition:(int)x withY:(int)y
{
	if (rom != nil)
	{
		[rom->rmMovement setXPosition:x];
		[rom->rmMovement setYPosition:y];
	}
	else
	{
		hoX = x;
		hoY = y;
		if (roc != nil)
		{
			roc->rcChanged = YES;
			roc->rcCheckCollides = YES;
		}
	}
}

-(void)initObject:(CObjectCommon*)ocPtr withCOB:(CCreateObjectInfo*)cob
{
}

-(void)handle
{
}

-(void)modif
{
}

-(void)display
{
}

-(BOOL)kill:(BOOL)bFast
{
	return NO;
}

-(void)getZoneInfos
{
}

-(void)saveBack:(CBitmap*)bitmap
{
}

-(void)restoreBack:(CBitmap*)bitmap
{
}

-(void)killBack
{
}

-(void)draw:(CRenderer*)bitmap
{
}

-(CMask*)getCollisionMask:(int)flags
{
	return nil;
}

// IDrawable
-(void)spriteDraw:(CRenderer*)renderer withSprite:(CSprite*)spr andImageBank:(CImageBank*)bank andX:(int)x andY:(int)y
{
}
-(void)spriteKill:(CSprite*)spr
{
}

-(CMask*)spriteGetMask
{
	return nil;
}
-(NSString*)description
{
	return [NSString stringWithFormat:@"%@ [%i,%i]", hoOiList->oilName, hoX, hoY];
}

-(CObject*)getObjectFromFixed:(int)fixed
{
	int index = 0x0000FFFF & fixed;
	if (index >= hoAdRunHeader->rhMaxObjects)
		return nil;
	return hoAdRunHeader->rhObjectList[index];
}

-(BOOL)isOfType:(short)OiList
{
	return [hoAdRunHeader->objectSelection objectIsOfType:self type:OiList];
}

@end
