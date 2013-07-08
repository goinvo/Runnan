//----------------------------------------------------------------------------------
//
// CLOLIST : liste de levelobjects
//
//----------------------------------------------------------------------------------
#import <Foundation/Foundation.h>

@class CRunApp;
@class CLO;

@interface CLOList : NSObject 
{
@public
	CRunApp* app;
    CLO** list;
    short* handleToIndex;
	short lHandleToIndex;
    int nIndex;
    int loFranIndex;
}

-(id)initWithApp:(CRunApp*)a;
-(void)dealloc;
-(void)load;
-(CLO*)getLOFromIndex:(short)index;
-(CLO*)getLOFromHandle:(short)handle;
-(CLO*)next_LevObj;
-(CLO*)first_LevObj;

@end
