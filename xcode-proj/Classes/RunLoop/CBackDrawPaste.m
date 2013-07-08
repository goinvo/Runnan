// -----------------------------------------------------------------------------
//
// CBACKDRAWPASTE
//
// -----------------------------------------------------------------------------
#import "CBackDrawPaste.h"
#import "CImageBank.h"
#import "CMask.h"
#import "CRun.h"
#import "CColMask.h"
#import "CImage.h"
#import "CRunApp.h"
#import "CColMask.h"
#import "CRunFrame.h"
#import "CSpriteGen.h"
#import "CBitmap.h"

@implementation CBackDrawPaste

-(void)execute:(CRun*)rhPtr withBitmap:(CBitmap*)bitmap
{
	// Demande la largeur et la hauteur de l'image
	CImage* ifo=[rhPtr->rhApp->imageBank getImageFromHandle:img];
	
	int xImage = x - rhPtr->rhWindowX;
	int x1Image = xImage - ifo->xSpot;
	int x2Image = x1Image + ifo->width;
	int yImage = y - rhPtr->rhWindowY;
	int y1Image = yImage - ifo->ySpot;
	int y2Image = y1Image + ifo->height;
	
	// En fonction de type de paste
	CMask* mask;
	switch (typeObst)
	{
	    case 0:
			// Un rien
			// -------
			if (rhPtr->rhFrame->colMask!=nil)
			{
				mask=[ifo getMask:GCMF_OBSTACLE withAngle:0 andScaleX:1.0 andScaleY:1.0];
				[rhPtr->rhFrame->colMask orMask:mask withX:x1Image andY:y1Image andPlane:CM_OBSTACLE | CM_PLATFORM andValue:0];
			}
			[rhPtr y_Ladder_Sub:0 withX1:x1Image andY1:y1Image andX2:x2Image andY2:y2Image];
			break;
	    case 1:
			// Un obstacle
			// -----------
			if (rhPtr->rhFrame->colMask!=nil)
			{
				mask=[ifo getMask:GCMF_OBSTACLE withAngle:0 andScaleX:1.0 andScaleY:1.0];
				[rhPtr->rhFrame->colMask orMask:mask withX:x1Image andY:y1Image andPlane:CM_OBSTACLE|CM_PLATFORM andValue:CM_OBSTACLE|CM_PLATFORM];
			}
			break;
	    case 2:
			// Une plateforme
			// --------------
			if (rhPtr->rhFrame->colMask!=nil)
			{
				mask=[ifo getMask:GCMF_OBSTACLE withAngle:0 andScaleX:1.0 andScaleY:1.0];
				[rhPtr->rhFrame->colMask orMask:mask withX:x1Image andY:y1Image andPlane:CM_OBSTACLE|CM_PLATFORM andValue:0];
				[rhPtr->rhFrame->colMask orPlatformMask:mask withX:x1Image andY:y1Image];
			}
			break;
	    case 3:
			// Une echelle
			[rhPtr y_Ladder_Add:0 withX1:x1Image andY1:y1Image andX2:x2Image andY2:y2Image];
			if (rhPtr->rhFrame->colMask!=nil)
			{
				[rhPtr->rhFrame->colMask fillRectangle:x1Image withY1:y1Image andX2:x2Image andY2:y2Image andValue:0];
			}
			break;
	    default:
			break;
	}
	
	// Paste dans l'image!
	// -------------------
	
	//ANDOS TODO
	//[rhPtr->rhApp->spriteGen pasteSpriteEffect:bitmap withImage:img andX:x1Image andY:y1Image andFlags:0 andInkEffect:inkEffect andInkEffectParam:inkEffectParam];	
}

@end
