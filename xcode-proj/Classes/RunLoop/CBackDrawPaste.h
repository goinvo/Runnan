// -----------------------------------------------------------------------------
//
// CBACKDRAWPASTE
//
// -----------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "CBackDraw.h"

@class CRun;
@class CBitmap;

@interface CBackDrawPaste : CBackDraw 
{
@public 
	short img;
    int x;
    int y;
    short typeObst;
    int inkEffect;
    int inkEffectParam;	
}
-(void)execute:(CRun*)rhPtr withBitmap:(CBitmap*)g2;

@end
