//----------------------------------------------------------------------------------
//
// CDEF : DonnÈes d'un objet normal
//
//----------------------------------------------------------------------------------
#import <Foundation/Foundation.h>

@class CFile;

@interface CDefValues : NSObject 
{
@public
	short nValues;
    int* values;	
}
-(id)init;
-(void)dealloc;
-(void)load:(CFile*)file;

@end
