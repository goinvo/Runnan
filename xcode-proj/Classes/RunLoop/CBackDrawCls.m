// -----------------------------------------------------------------------------
//
// CBACKDRAWCLS effacement du fond de l'ecran
//
// -----------------------------------------------------------------------------
#import "CBackDrawCls.h"
#import "CRun.h"
#import "CServices.h"
#import "CRunFrame.h"
#import "CBitmap.h"

@implementation CBackDrawCls

-(void)execute:(CRun*)rhPtr withBitmap:(CBitmap*)bitmap
{
	[bitmap fillRect:0 withY:0 andWidth:rhPtr->rhFrame->leEditWinWidth andHeight:rhPtr->rhFrame->leEditWinHeight andColor:color];
}

@end
