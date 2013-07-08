//----------------------------------------------------------------------------------
//
// CMOVEDEFMOUSE : donnees du mouvement mouse
//
//----------------------------------------------------------------------------------
#import "CMoveDefMouse.h"
#import "CFile.h"

@implementation CMoveDefMouse

-(void)load:(CFile*)file withLength:(int)length
{
	mmDx=[file readAShort];
	mmFx=[file readAShort];
	mmDy=[file readAShort];
	mmFy=[file readAShort];
	mmFlags=[file readAShort];
}

@end
