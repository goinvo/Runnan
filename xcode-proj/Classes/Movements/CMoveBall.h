//----------------------------------------------------------------------------------
//
// CMOVEBALL : Mouvement balle
//
//----------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "CMove.h"

@class CObject;
@class CMoveDef;

@interface CMoveBall : CMove 
{
@public
	int MB_StartDir;
    int MB_Angles;
    int MB_Securite;
    int MB_SecuCpt;
    int MB_Bounce;
    int MB_Speed;
    int MB_MaskBounce;
    int MB_LastBounce;
    BOOL MB_Blocked;	
}
-(void)initMovement:(CObject*)ho withMoveDef:(CMoveDef*)mvPtr;
-(void)move;
-(void)stop;
-(void)start;
-(void)bounce;
-(BOOL)mvb_Test:(int)dir;
-(void)setSpeed:(int)speed;
-(void)setMaxSpeed:(int)speed;
-(void)reverse;
-(void)setXPosition:(int)x;
-(void)setYPosition:(int)y;

@end
