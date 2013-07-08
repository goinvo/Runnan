//----------------------------------------------------------------------------------
//
// CMOVEMOUSE : Mouvement souris
//
//----------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "CMove.h"

@interface CMoveMouse : CMove 
{
@public 
	int MM_DXMouse;
    int MM_DYMouse;
    int MM_FXMouse;
    int MM_FYMouse;
    int MM_Stopped;
    int MM_OldSpeed;	
}
-(void)initMovement:(CObject*)ho withMoveDef:(CMoveDef*)mvPtr;
-(void)move;
-(void)stop;
-(void)start;
-(void)setXPosition:(int)x;
-(void)setYPosition:(int)y;

@end
