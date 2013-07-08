//----------------------------------------------------------------------------------
//
// CDEFCOUNTER : valeurs de depart counter
//
//----------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "CDefObject.h"

@class CFile;

@interface CDefCounter : CDefObject 
{
@public
	int ctInit;				// Initial value
    int ctMini;				// Minimal value
    int ctMaxi;				// Maximal value
	
}
-(void)load:(CFile*)file;
-(void)enumElements:(id)enumImages withFont:(id)enumFonts;

@end
