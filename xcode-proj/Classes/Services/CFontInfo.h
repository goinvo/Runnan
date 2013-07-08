//----------------------------------------------------------------------------------
//
// CFONTINFO : informations sur une fonte
//
//----------------------------------------------------------------------------------
#import <Foundation/Foundation.h>


@interface CFontInfo : NSObject 
{
@public
    int lfHeight; 
    int lfWeight; 
    unsigned char lfItalic; 
    unsigned char lfUnderline; 
    unsigned char lfStrikeOut; 
    NSString* lfFaceName;	
}
-(id)init;
-(void)dealloc;
-(void)copy:(CFontInfo*)f;
-(void)setName:(NSString*)name;
+(CFontInfo*)fontInfoFromFontInfo:(CFontInfo*)f;
-(UIFont*)createFont;

@end
