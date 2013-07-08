//----------------------------------------------------------------------------------
//
// CMOVEDEFBALL : donnees du mouvement ball
//
//----------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "CMoveDef.h"

@class CFile;

@interface CMoveDefBall : CMoveDef 
{
@public 
	short mbSpeed;
    short mbBounce;
    short mbAngles;
    short mbSecurity;
    short mbDecelerate;	
}
-(void)load:(CFile*)file withLength:(int)length; 

@end
