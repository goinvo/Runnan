//----------------------------------------------------------------------------------
//
// CDEFTEXTS : liste de textes
//
//----------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "CDefObject.h"

@class CDefText;
@class CFile;

@interface CDefTexts : CDefObject
{
@public 
	int otCx;
    int otCy;
    int otNumberOfText;
    CDefText** otTexts;
	
}
-(void)dealloc;
-(void)load:(CFile*)file;
-(void)enumElements:(id)enumImages withFont:(id)enumFonts;

@end
