//----------------------------------------------------------------------------------
//
// CMOVEDEFEXTENSION : donnees d'un movement extension
//
//----------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "CMoveDef.h"

@class CFile;

@interface CMoveDefExtension : CMoveDef
{
@public 
	NSString* moduleName;
    int mvtID;
    unsigned char* data;
	int length;
	
}
-(void)dealloc;
-(void)load:(CFile*)file withLength:(int)length;
-(void)setModuleName:(NSString*)name withID:(int)id;

@end
