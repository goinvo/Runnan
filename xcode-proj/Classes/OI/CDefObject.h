//----------------------------------------------------------------------------------
//
// CDEFOBJECT : Classe abstraite de definition d'un objet'
//
//----------------------------------------------------------------------------------
#import <Foundation/Foundation.h>

@class CFile;

@interface CDefObject : NSObject 
{

}
-(void)load:(CFile*)file;
-(void)enumElements:(id)enumImages withFont:(id)enumFonts;

@end
