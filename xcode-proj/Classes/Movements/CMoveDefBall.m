//----------------------------------------------------------------------------------
//
// CMOVEDEFBALL : donnees du mouvement ball
//
//----------------------------------------------------------------------------------
#import "CMoveDefBall.h"
#import "CFile.h"

@implementation CMoveDefBall

-(void)load:(CFile*)file withLength:(int)length 
{
	mbSpeed=[file readAShort];
	mbBounce=[file readAShort];
	mbAngles=[file readAShort];
	mbSecurity=[file readAShort];
	mbDecelerate=[file readAShort];       
}

@end
