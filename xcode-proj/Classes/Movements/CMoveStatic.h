//----------------------------------------------------------------------------------
//
// CMOVESTATIC : Mouvement statique
//
//----------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "CMove.h"

@interface CMoveStatic : CMove 
{

}
-(void)initMovement:(CObject*)ho withMoveDef:(CMoveDef*)mvPtr;
-(void)move;
-(void)setXPosition:(int)x;
-(void)setYPosition:(int)y;

@end
