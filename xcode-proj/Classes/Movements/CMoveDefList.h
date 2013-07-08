//----------------------------------------------------------------------------------
//
// CMOVEDEFLIST : liste des mouvements d'un objet'
//
//----------------------------------------------------------------------------------
#import <Foundation/Foundation.h>

@class CFile;
@class CMoveDef;

@interface CMoveDefList : NSObject 
{
@public
	int nMovements;
    CMoveDef** moveList;
	
}
-(void)dealloc;
-(void)load:(CFile*)file; 

@end
