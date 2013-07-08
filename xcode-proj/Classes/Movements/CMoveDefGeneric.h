//----------------------------------------------------------------------------------
//
// CMOVEDEFGENERIC : donnÈes du mouvement generique
//
//----------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "CMoveDef.h"

@class CFile;

@interface CMoveDefGeneric : CMoveDef
{
@public
	short mgSpeed;
    short mgAcc;
    short mgDec;
    short mgBounceMult;
    int mgDir;	
}
-(void)load:(CFile*)file withLength:(int)length;

@end
