//----------------------------------------------------------------------------------
//
// CFONTBANK : stockage des fontes
//
//----------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "IEnum.h"

@class CRunApp;
@class CFont;
@class CFontInfo;
@class CFile;

@interface CFontBank : NSObject <IEnum>
{
@public
	CRunApp* runApp;
    CFont** fonts;          /// List of CFonts
    int* offsetsToFonts;
    int nFonts;
    short* handleToIndex;
    int maxHandlesReel;
    int maxHandlesTotal;
    short* useCount;
    CFont* nullFont;
}

-(id)initWithApp:(CRunApp*)app;
-(void)dealloc;
-(void)preLoad;
-(void)load;
-(CFont*)getFontFromHandle:(short)handle;
-(CFont*)getFontFromIndex:(short)index;
-(CFontInfo*)getFontInfoFromHandle:(short)handle;
-(void)setToLoad:(short)handle;
-(void)resetToLoad;
-(short)addFont:(CFontInfo*)info;
-(short)enumerate:(short)num;

@end
