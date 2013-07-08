// -----------------------------------------------------------------------------
//
// CBACKDRAWCLSZONE effacement d'une zone du fond de l'ecran
//
// -----------------------------------------------------------------------------
#import "CBackDrawClsZone.h"
#import "CServices.h"
#import "CRun.h"
#import "CBitmap.h"

@implementation CBackDrawClsZone

-(void)execute:(CRun*)rhPtr withBitmap:(CBitmap*)bitmap
{
	[bitmap fillRect:x1 withY:y1 andWidth:x2-x1 andHeight:y2-y1 andColor:color];
}

@end
