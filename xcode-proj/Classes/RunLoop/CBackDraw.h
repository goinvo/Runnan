// -----------------------------------------------------------------------------
//
// CBACKDRAW classe abtraite pour les backdraw routines
//
// -----------------------------------------------------------------------------
#import <Foundation/Foundation.h>

@class CRun;
@class CBitmap;

@interface CBackDraw : NSObject 
{

}
-(void)execute:(CRun*)rhPtr withBitmap:(CBitmap*)g2;

@end
