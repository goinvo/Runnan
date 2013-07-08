//----------------------------------------------------------------------------------
//
// CTRANSITIONDATA : donnÈes transitions
//
//----------------------------------------------------------------------------------
#import <Foundation/Foundation.h>

#define TRFLAG_COLOR 0x0001

@class CFile;

@interface CTransitionData : NSObject 
{
@public
    NSString* dllName;
	//  public int dllID;
    int transID;
    int transDuration;
    int transFlags;
    int transColor;
    int dataOffset;
	
}
-(void)dealloc;
-(void)load:(CFile*)file;

@end
