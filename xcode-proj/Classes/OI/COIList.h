//----------------------------------------------------------------------------------
//
// COILIST : liste des OI de l'application
//
//----------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "IEnum.h"

@class CRunApp;
@class COI;
@class CFile;

@interface COIList : NSObject 
{
@public
    short oiMaxIndex;
    COI** ois;
    short oiMaxHandle;
    short* oiHandleToIndex;
    char* oiToLoad;
    char* oiLoaded;
    int currentOI;
}

-(void)dealloc;
-(void)preLoad:(CFile*)file;
-(COI*)getOIFromHandle:(short)handle;
-(COI*)getOIFromIndex:(short)index;
-(void)resetOICurrent;
-(void)setOICurrent:(int)handle;
-(COI*)getFirstOI;
-(COI*)getNextOI;
-(void)resetToLoad;
-(void)setToLoad:(int)n;
-(void)load:(CFile*)file; 
-(void)enumElements:(id)enumImages withFont:(id)enumFonts;

@end
