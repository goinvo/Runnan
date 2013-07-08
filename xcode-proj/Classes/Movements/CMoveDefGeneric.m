//----------------------------------------------------------------------------------
//
// CMOVEDEFGENERIC : donnÈes du mouvement generique
//
//----------------------------------------------------------------------------------
#import "CMoveDefGeneric.h"
#import "CFile.h"

@implementation CMoveDefGeneric

-(void)load:(CFile*)file withLength:(int)length
{
	mgSpeed=[file readAShort];
	mgAcc=[file readAShort];
	mgDec=[file readAShort];
	mgBounceMult=[file readAShort];
	mgDir=[file readAInt];        
}

@end
