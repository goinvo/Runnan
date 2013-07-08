//----------------------------------------------------------------------------------
//
// CMOVEDEFPLATFORM : donnees du mouvement platforme
//
//----------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "CMoveDef.h"

@class CFile;

@interface CMoveDefPlatform : CMoveDef
{
@public 
	short mpSpeed;
    short mpAcc;	
    short mpDec;	
    short mpJumpControl;
    short mpGravity;
    short mpJump;	
}
-(void)load:(CFile*)file withLength:(int)length;

@end
