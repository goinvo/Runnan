//----------------------------------------------------------------------------------
//
// CMOVEDEFMOUSE : donnees du mouvement mouse
//
//----------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "CMoveDef.h"

@class CFile;

@interface CMoveDefMouse : CMoveDef
{
@public 
	short mmDx;      				
    short mmFx;
    short mmDy;
    short mmFy;
    short mmFlags;	
}
-(void)load:(CFile*)file withLength:(int)length;

@end
