//----------------------------------------------------------------------------------
//
// CMOVEDEFPLATFORM : donnees du mouvement platforme
//
//----------------------------------------------------------------------------------
#import "CMoveDefPlatform.h"
#import "CFile.h"

@implementation CMoveDefPlatform

-(void)load:(CFile*)file withLength:(int)length
{
	mpSpeed=[file readAShort];
	mpAcc=[file readAShort];	
	mpDec=[file readAShort];	
	mpJumpControl=[file readAShort];
	mpGravity=[file readAShort];
	mpJump=[file readAShort];        
}

@end
