//----------------------------------------------------------------------------------
//
// CEXTLOADER: Chargement des extensions
//
//----------------------------------------------------------------------------------
#import <Foundation/Foundation.h>

#define KPX_BASE 32

@class CRunApp;
@class CRunExtension;
@class CExtLoad;

@interface CExtLoader : NSObject 
{
	CRunApp* runApp;
    CExtLoad** extensions;
    short* numOfConditions;
    int extMaxHandles;
}

-(id)initWithApp:(CRunApp*)app;
-(void)dealloc;
-(void)loadList;
-(int)getNumberOfConditions:(int)type;
-(CRunExtension*)loadRunObject:(int)type;

@end
