//----------------------------------------------------------------------------------
//
// CFONT : une fonte
//
//----------------------------------------------------------------------------------
#import <Foundation/Foundation.h>

@class CFile;
@class CFontInfo;

@interface CFont : NSObject 
{
@public
	short useCount;
    short handle;
    int lfHeight;
    int lfWidth;
    int lfEscapement;
    int lfOrientation;
    int lfWeight;
    unsigned char lfItalic;
    unsigned char lfUnderline;
    unsigned char lfStrikeOut;
    unsigned char lfCharSet;
    unsigned char lfOutPrecision;
    unsigned char lfClipPrecision;
    unsigned char lfQuality;
    unsigned char lfPitchAndFamily;
    NSString* lfFaceName;
    UIFont* font;
	
}
-(void)dealloc;
-(void)loadHandle:(CFile*)file;
-(void)load:(CFile*)file;
-(CFontInfo*)getFontInfo;
+(CFont*)createFromFontInfo:(CFontInfo*)info;
-(void)createDefaultFont;
-(UIFont*)createFont;

@end
