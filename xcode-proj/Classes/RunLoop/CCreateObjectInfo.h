//----------------------------------------------------------------------------------
//
// CCREATEOBJECTINFO: informations pour la creation des objets
//
//----------------------------------------------------------------------------------
#import <Foundation/Foundation.h>

#define COF_HIDDEN 0x0002

@class CLO;

@interface CCreateObjectInfo : NSObject 
{
@public
	CLO* cobLevObj;				// Leave first!
    short cobLevObjSeg;
    short cobFlags;
    int cobX;
    int cobY;
    int cobDir;
    int cobLayer;
    int cobZOrder;	
}

@end
