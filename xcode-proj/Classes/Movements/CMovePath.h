//----------------------------------------------------------------------------------
//
// CMOVEPATH : Mouvement enregistre
//
//----------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "CMove.h"

@class CObject;
@class CMoveDef;
@class CMoveDefPath;

@interface CMovePath : CMove
{
@public
	int MT_Speed;
    int MT_Sinus;
    int MT_Cosinus;
    int MT_Longueur;
    int MT_XOrigin;
    int MT_YOrigin;
    int MT_XDest;
    int MT_YDest;
    int MT_MoveNumber;
    BOOL MT_Direction;
    CMoveDefPath* MT_Movement;
    int MT_Calculs;
    int MT_XStart;
    int MT_YStart;
    int MT_Pause;
    NSString* MT_GotoNode;
    BOOL MT_FlagBranch;	
}
-(void)initMovement:(CObject*)ho withMoveDef:(CMoveDef*)mvPtr;
-(void)kill;
-(void)move;
-(BOOL)mtMove:(int)step;
-(void)mtGoAvant:(int)number;
-(void)mtGoArriere:(int)number;
-(void)mtBranche;
-(void)mtMessages;
-(BOOL)mtTheEnd;
-(void)mtReposAtEnd;
-(void)mtBranchNode:(NSString*)pName;
-(void)freeMTNode;
-(void)mtGotoNode:(NSString*)pName;
-(void)stop;
-(void)start;
-(void)reverse;
-(void)setXPosition:(int)x;
-(void)setYPosition:(int)y;
-(void)setSpeed:(int)speed;
-(void)setMaxSpeed:(int)speed;

@end
