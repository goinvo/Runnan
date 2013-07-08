//----------------------------------------------------------------------------------
//
// CDEFTEXT : un element de texte
//
//----------------------------------------------------------------------------------
#import <Foundation/Foundation.h>

#define TSF_LEFT 0x0000
#define TSF_HCENTER 0x0001
#define TSF_RIGHT 0x0002
#define TSF_VCENTER 0x0004
#define TSF_HALIGN 0x000F
#define TSF_CORRECT 0x0100
#define TSF_RELIEF 0x0200

@class CFile;

@interface CDefText : NSObject 
{
@public
	short tsFont;					// Font 
    short tsFlags;				// Flags
    int tsColor;				// Color
    NSString* tsText;	
}

-(void)dealloc;
-(void)load:(CFile*)file;
-(void)enumElements:(id)enumImages withFont:(id)enumFonts;

@end
