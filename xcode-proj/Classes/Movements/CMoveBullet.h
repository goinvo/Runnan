//----------------------------------------------------------------------------------
//
// CMOVEBULLET : mouvement shoot
//
//----------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "CMove.h"

@class CObject;
@class CMoveDef;

@interface CMoveBullet : CMove 
{
@public
	BOOL MBul_Wait;
    CObject* MBul_ShootObject;	
}
-(void)initMovement:(CObject*)ho withMoveDef:(CMoveDef*)mvPtr;
-(void)init2:(CObject*)parent;
-(void)move;
-(void)startBullet;
-(void)setXPosition:(int)x;
-(void)setYPosition:(int)y;

@end
