//----------------------------------------------------------------------------------
//
// CEXTLOAD Chargement des extensions
//
//----------------------------------------------------------------------------------
#import <Foundation/Foundation.h>

@class CRunExtension;
@class CFile;

@interface CExtLoad : NSObject 
{
@public 
	short handle;
    NSString* name;
    NSString* subType;
	
}
-(CRunExtension*)loadRunObject; 
-(void)loadInfo:(CFile*)file;
-(void)dealloc;
@end
