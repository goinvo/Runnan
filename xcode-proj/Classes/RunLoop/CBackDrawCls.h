// -----------------------------------------------------------------------------
//
// CBACKDRAWCLS effacement du fond de l'ecran
//
// -----------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "CBackDraw.h"

@class CRun;
@class CBitmap;

@interface CBackDrawCls : CBackDraw 
{
@public
	int color;	
}
-(void)execute:(CRun*)rhPtr withBitmap:(CBitmap*)g2;
@end
