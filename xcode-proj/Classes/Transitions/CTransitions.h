//----------------------------------------------------------------------------------
//
// CTRANSITIONS : interface avec la dll
//
//----------------------------------------------------------------------------------
#import <Foundation/Foundation.h>

@class CTrans;
@class CTransitionData;

@interface CTransitions : NSObject 
{

}
-(CTrans*)getTrans:(CTransitionData*)data;

@end
