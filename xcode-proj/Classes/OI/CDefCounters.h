//----------------------------------------------------------------------------------
//
// CDEFCOUNTERS : DonnÈes d'un objet score / vies / counter
//
//----------------------------------------------------------------------------------
#import <Foundation/Foundation.h>

// Display types
#define CTA_HIDDEN 0
#define CTA_DIGITS 1
#define CTA_VBAR 2
#define CTA_HBAR 3
#define CTA_ANIM 4
#define CTA_TEXT 5    
#define BARFLAG_INVERSE 0x0100
#define CTA_FILLTYPE_GRADIENT 2
#define CTA_FILLTYPE_SOLID 1
#define CTA_GRAD_HORIZONTAL 0
#define CTA_GRAD_VERTICAL 1

@class CFile;

@interface CDefCounters : NSObject 
{
@public 
	int odCx;					// Size: only lives & counters
    int odCy;
    short odPlayer;				// Player: only score & lives
    short odDisplayType;			// CTA_xxx
    short odDisplayFlags;			// BARFLAG_INVERSE
    short odFont;					// Font
    short ocBorderSize;			// Border
    int ocBorderColor;
    short ocShape;			// Shape
    short ocFillType;
    short ocLineFlags;			// Only for lines in non filled mode
    int ocColor1;			// Gradient
    int ocColor2;
    int ocGradientFlags;
    short nFrames;
    short* frames;
	
}
-(id)init;
-(void)dealloc;
-(void)load:(CFile*)file;
-(void)enumElements:(id)enumImages withFont:(id)enumFonts;

@end
