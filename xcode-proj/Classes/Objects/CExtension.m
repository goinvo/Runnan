//----------------------------------------------------------------------------------
//
// CEXTENSION: Objets d'extension
//
//----------------------------------------------------------------------------------
#import "CExtension.h"
#import "CRun.h"
#import "CRSpr.h"
#import "CObjectCommon.h"
#import "CMask.h"
#import "CSprite.h"
#import "CImageBank.h"
#import "CCreateObjectInfo.h"
#import "CBitmap.h"
#import "CRenderer.h"
#import "CRCom.h"
#import "CRMvt.h"
#import "CRAni.h"
#import "CRSpr.h"
#import "CBitmap.h"
#import "CValue.h"
#import "CColMask.h"
#import "CRunApp.h"
#import "CExtLoader.h"
#import "CRunExtension.h"
#import "CFile.h"
#import "CRect.h"
#import "CMove.h"
#import "CEventProgram.h"
#import "CValue.h"
#import "CEvents.h"
#import "CMoveDef.h"
#import "CMoveExtension.h"

@implementation CExtension

-(void)dealloc
{
	[ext release];
	[super dealloc];
}

-(id)initWithType:(int)type andRun:(CRun*)rhPtr
{
	ext = [rhPtr->rhApp->extLoader loadRunObject:type];	
	return [super init];
}

-(void)initObject:(CObjectCommon*)ocPtr withCOB:(CCreateObjectInfo*)cob
{
	// Initialisation des pointeurs
	[ext initialize:self];
	
	// Initialisation de l'objet
	CFile* file=nil;
	if (ocPtr->ocExtension != nil)
	{
		file=[[CFile alloc] initWithBytes:ocPtr->ocExtension length:ocPtr->ocExtLength];
		[file setUnicode:hoAdRunHeader->rhApp->bUnicode];
	}
	privateData = ocPtr->ocPrivate;
	[ext createRunObject:file withCOB:cob andVersion:ocPtr->ocVersion];
	if (file!=nil)
	{
		[file release];
	}
}

-(void)handle
{
	// Routines standard;
	if ((hoOEFlags & 0x0200) != 0)	// OEFLAG_SPRITE
	{
		[ros handle];
	}
	else if ((hoOEFlags & 0x0030) == 0x0010 || (hoOEFlags & 0x0030) == 0x0030) // OEFLAG_MOVEMENTS / OEFLAG_ANIMATIONS|OEFLAG_MOVEMENTS
	{
		[rom move];
	}
	else if ((hoOEFlags & 0x0030) == 0x0020)	// OEFLAG_ANIMATION
	{
		[roa animate];
	}
	
	// Handle de l'objet
	int ret = 0;
	if (noHandle == NO)
	{
		ret = [ext handleRunObject];
	}
	
	if ((ret & REFLAG_ONESHOT) != 0)
	{
		noHandle = YES;
	}
	if (roc != nil)
	{
		if (roc->rcChanged)
		{
			ret |= REFLAG_DISPLAY;
			roc->rcChanged = NO;
		}
	}
	if ((ret & REFLAG_DISPLAY) != 0)
	{
		[self modif];
	}
}

-(void)modif
{
	if (ros != nil)
	{
		[ros modifRoutine];
	}
	else if ((hoOEFlags & OEFLAG_BACKGROUND) != 0)
	{
		[hoAdRunHeader modif_RedrawLevel:self];
	}
	else
	{
		[ext displayRunObject:nil];
	}
}

-(void)display
{
}

-(BOOL)kill:(BOOL)bFast
{
	[ext destroyRunObject:bFast];
	return NO;
}

-(void)getZoneInfos
{
	[ext getZoneInfos];
	//The rect is updated in CRSpr objGetZoneInfos
}

-(void)draw:(CRenderer*)renderer
{
	CImage* img = [ext getRunObjectSurface];
	if (img != nil)
	{
		[renderer renderImage:(ITexture*)img withX:hoRect.left andY:hoRect.top andWidth:hoRect.right-hoRect.left andHeight:hoRect.bottom-hoRect.top andInkEffect:0 andInkEffectParam:0];
	}
	else
	{
		[ext displayRunObject:renderer];
	}
}

-(CMask*)getCollisionMask:(int)flags
{
	return [ext getRunObjectCollisionMask:flags];
}

// IDrawable
-(void)spriteDraw:(CRenderer*)renderer withSprite:(CSprite*)spr andImageBank:(CImageBank*)bank andX:(int)x andY:(int)y
{
	[ext displayRunObject:renderer];
}

-(void)spriteKill:(CSprite*)spr
{
	[ext release];
}
-(CMask*)spriteGetMask
{
	return [ext getRunObjectCollisionMask:GCMF_OBSTACLE];
}

-(BOOL)condition:(int)num withCndExtension:(CCndExtension*)cnd
{
	return [ext condition:num withCndExtension:cnd];
}

-(void)action:(int)num withActExtension:(CActExtension*)act
{
	[ext action:num withActExtension:act];
}

-(CValue*)expression:(int)num
{
	return [ext expression:num];
}


////////////////////////////////////////////////////////////////////////
// CALL BACKS
////////////////////////////////////////////////////////////////////////

-(CRunApp*)getApplication
{
	return hoAdRunHeader->rhApp;
}
-(void)loadImageList:(short*)list withLength:(int)length
{
	[hoAdRunHeader->rhApp->imageBank loadImageList:list withLength:length];
}

-(CImage*)getImage:(short)handle
{
	return [hoAdRunHeader->rhApp->imageBank getImageFromHandle:handle];
}


-(void)reHandle
{
	noHandle = NO;
}

-(int)getExtUserData
{
	return privateData;
}

-(void)setExtUserData:(int)data
{
	privateData = data;
}

-(void)addBackdrop:(CImage*)img withX:(int)x andY:(int)y andEffect:(int)dwEffect andEffectParam:(int)dwEffectParam andType:(int)typeObst andLayer:(int)nLayer
{
/*	// Duplique et ajoute l'image
	int width = img->width();
	int height = img->height();
	Image newImg = Image.createImage(img, 0, 0, width, height, Sprite.TRANS_NONE);
	short handle = hoAdRunHeader.rhApp.imageBank.addImageCompare(newImg, (short) 0, (short) 0, (short) 0, (short) 0);
	
	// Ajoute a la liste
	CBkd2 toadd = new CBkd2();
	toadd.img = handle;
	toadd.loHnd = 0;
	toadd.oiHnd = 0;
	toadd.x = x;
	toadd.y = y;
	toadd.nLayer = (short) nLayer;
	toadd.inkEffect = dwEffect;
	toadd.inkEffectParam = dwEffectParam;
	toadd.colMode = CSpriteGen.CM_BITMAP;
	toadd.obstacleType = (short) typeObst;	// a voir
	for (int ns = 0; ns < 4; ns++)
	{
		toadd.pSpr[ns] = null;
	}
	hoAdRunHeader.addBackdrop2(toadd);
	
	// Add paste routine (pour �viter d'avoir � r�afficher tout le d�cor)
	if (nLayer == 0 && (hoAdRunHeader.rhFrame.layers[0].dwOptions & (CLayer.FLOPT_TOHIDE | CLayer.FLOPT_VISIBLE)) == CLayer.FLOPT_VISIBLE)
	{
		CBackDrawPaste paste;
		paste = new CBackDrawPaste();
		paste.img = handle;
		paste.x = x;
		paste.y = y;
		paste.typeObst = (short) typeObst;
		paste.inkEffect = dwEffect;
		paste.inkEffectParam = dwEffectParam;
		hoAdRunHeader.addBackDrawRoutine(paste);
		
		// Redraw sprites that intersect with the rectangle
		CRect rc = new CRect();
		rc.left = x - hoAdRunHeader.rhWindowX;
		rc.top = y - hoAdRunHeader.rhWindowY;
		rc.right = rc.left + width;
		rc.bottom = rc.top + height;
		hoAdRunHeader.spriteGen.activeSprite(null, CSpriteGen.AS_REDRAW_RECT, rc);
	}
*/
}

-(int)getEventCount
{
	return hoAdRunHeader->rh4EventCount;
}

-(CValue*)getExpParam
{
	hoAdRunHeader->rh4ExpToken=(LPEXP)((LPBYTE)hoAdRunHeader->rh4ExpToken+hoAdRunHeader->rh4ExpToken->expSize);
	CValue* temp=[hoAdRunHeader getExpression];
	CValue* ret=[hoAdRunHeader getTempValue:0];
	[ret forceValue:temp];
	return ret;
}

-(int)getEventParam
{
	return hoAdRunHeader->rhEvtProg->rhCurParam[0];
}

-(double)callMovement:(CObject*)hoPtr withAction:(int)action andParam:(double)param
{
	if ((hoPtr->hoOEFlags & OEFLAG_MOVEMENTS) != 0)
	{
		if (hoPtr->roc->rcMovementType == MVTYPE_EXT)
		{
			CMoveExtension* mvPtr = (CMoveExtension*) hoPtr->rom->rmMovement;
			return [mvPtr callMovement:action param:param];
		}
	}
	return 0;
}

-(CValue*)callExpression:(CObject*)hoPtr withExpression:(int)action andParam:(int)param
{
	CExtension* pExtension=(CExtension*)hoPtr;
	pExtension->privateData=param;
	return [pExtension expression:action];
}

-(int)getExpressionParam
{
	return privateData;
}

-(CObject*)getFirstObject
{
	objectCount = 0;
	objectNumber = 0;
	return [self getNextObject];
}

-(CObject*)getNextObject
{
	for (; objectNumber < hoAdRunHeader->rhNObjects; objectNumber++)
	{
		while (hoAdRunHeader->rhObjectList[objectCount] == nil)
		{
			objectCount++;
		}
		CObject* hoPtr = hoAdRunHeader->rhObjectList[objectCount];
		objectNumber++;
		objectCount++;
		return hoPtr;
	}
	return nil;
}

/*
public CFile openHFile(String path)
{
	return hoAdRunHeader.rhApp.openHFile(path);
}

public void closeHFile(CFile file)
{
	hoAdRunHeader.rhApp.closeHFile(file);
}
*/

-(NSString*)description
{
	return [NSString stringWithString:hoCommon->pCOI->oiName];
}

@end
