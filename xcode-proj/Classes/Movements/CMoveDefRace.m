//----------------------------------------------------------------------------------
//
// CMOVEDEFRACE : donnees du mouvement racecar
//
//----------------------------------------------------------------------------------
#import "CMoveDefRace.h"
#import "CFile.h"

@implementation CMoveDefRace

-(void)load:(CFile*)file withLength:(int)length
{
	mrSpeed=[file readAShort];
	mrAcc=[file readAShort];	
	mrDec=[file readAShort];	
	mrRot=[file readAShort];	
	mrBounceMult=[file readAShort];
	mrAngles=[file readAShort];
	mrOkReverse=[file readAShort];        
}

@end
