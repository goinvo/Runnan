//----------------------------------------------------------------------------------
//
// CMOVEEXTENSIOn : Mouvement extension
//
//----------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "CMove.h"

@class CRunMvtExtension;

@interface CMoveExtension : CMove 
{
@public
    CRunMvtExtension* movement;
    double callParam;	
}
-(id)initWithObject:(CRunMvtExtension*)m;
-(void)dealloc;
-(void)initMovement:(CObject*)ho withMoveDef:(CMoveDef*)mvPtr;
-(void)kill;
-(void)move;
-(void)stop;
-(void)start;
-(void)bounce;
-(void)setSpeed:(int)speed;
-(void)setMaxSpeed:(int)speed;
-(void)reverse;
-(void)setXPosition:(int)x;
-(void)setYPosition:(int)y;
-(void)setDir:(int)dir;
-(double)callMovement:(int)function param:(double)param;

@end
