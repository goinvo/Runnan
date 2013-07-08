//----------------------------------------------------------------------------------
//
// CSYSEVENT : classe abstraite pour stocker les evenements systeme
//
//----------------------------------------------------------------------------------
#import <Foundation/Foundation.h>

@class CRun;

@interface CSysEvent : NSObject 
{
}
-(void)execute:(CRun*)rhPtr;

@end
