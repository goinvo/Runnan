//----------------------------------------------------------------------------------
//
// CSOUNDBANK: stockage des sons
//
//----------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "IEnum.h"

@class CRunApp;
@class CSound;

@interface CSoundBank : NSObject
{
@public
	CRunApp* runApp;
    CSound** sounds;
    int nHandlesReel;
    int nHandlesTotal;
    int nSounds;
    int* offsetsToSounds;
    short* handleToIndex;
    short* useCount;
    short* audioFlags;
}

-(id)initWithApp:(CRunApp*)app;
-(void)dealloc;
-(void)preLoad;
-(CSound*)getSoundFromHandle:(short)handle;
-(CSound*)getSoundFromIndex:(short)index;
-(void)resetToLoad;
-(void)setToLoad:(short)handle;
-(void)setFlags:(short)handle flags:(short)f;
-(void)load;
-(void)cleanMemory;

@end
