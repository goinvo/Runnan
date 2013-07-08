//----------------------------------------------------------------------------------
//
// CMOVEDEF : classe abstraite base des definitions mouvements
//
//----------------------------------------------------------------------------------
#import "CMoveDef.h"
#import "CFile.h"

@implementation CMoveDef

-(void)load:(CFile*)file withLength:(int)length
{
}
-(void)setData:(short)t withControl:(short)c andMoveAtStart:(unsigned char)m andDirAtStart:(int)d andOptions:(unsigned char)mo
{
	mvType=t;
	mvControl=c;
	mvMoveAtStart=m;
	mvDirAtStart=d;
	mvOpt=mo;
}

@end
