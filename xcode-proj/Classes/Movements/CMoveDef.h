//----------------------------------------------------------------------------------
//
// CMOVEDEF classe abstraite de definition d'un mouvement
//
//----------------------------------------------------------------------------------
#import <Foundation/Foundation.h>

// Definition of movement types
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#define MVTYPE_STATIC 0
#define MVTYPE_MOUSE 1
#define MVTYPE_RACE 2
#define MVTYPE_GENERIC 3
#define MVTYPE_BALL 4
#define MVTYPE_TAPED 5
#define MVTYPE_PLATFORM 9
#define MVTYPE_DISAPPEAR 11
#define MVTYPE_APPEAR 12
#define MVTYPE_BULLET 13
#define MVTYPE_EXT 14

@class CFile;

@interface CMoveDef : NSObject 
{
@public 
	short mvType;
    short mvControl;
    unsigned char mvMoveAtStart;
    int mvDirAtStart;	
	unsigned char mvOpt;
}
-(void)load:(CFile*)file withLength:(int)length;
-(void)setData:(short)t withControl:(short)c andMoveAtStart:(unsigned char)m andDirAtStart:(int)d andOptions:(unsigned char)mo;

@end
