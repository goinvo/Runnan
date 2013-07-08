// -----------------------------------------------------------------------------
//
// CBACKDRAWCLSZONE effacement d'une zone du fond de l'ecran
//
// -----------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "CBackDraw.h"

@class CBitmap;
@interface CBackDrawClsZone : CBackDraw
{
@public 
    int color;
    int x1;
    int x2;
    int y1;
    int y2;	
}
-(void)execute:(CRun*)rhPtr withBitmap:(CBitmap*)g2;

@end
