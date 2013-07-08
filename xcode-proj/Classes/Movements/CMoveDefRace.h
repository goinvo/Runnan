//----------------------------------------------------------------------------------
//
// CMOVEDEFRACE : donnees du mouvement racecar
//
//----------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "CMoveDef.h"

@interface CMoveDefRace : CMoveDef
{
@public
	short mrSpeed;
    short mrAcc;	
    short mrDec;	
    short mrRot;	
    short mrBounceMult;
    short mrAngles;
    short mrOkReverse;	
}
-(void)load:(CFile*)file withLength:(int)length;

@end
