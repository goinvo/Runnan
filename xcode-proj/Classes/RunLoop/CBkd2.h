// -----------------------------------------------------------------------------
//
// CBKD2 : objet paste dans le decor
//
// -----------------------------------------------------------------------------
#import <Foundation/Foundation.h>

@class CRun;
@class CSprite;

@interface CBkd2 : NSObject 
{
@public
	CRun* rhPtr;
	short loHnd;			// 0 
    short oiHnd;			// 0 
    int x;
    int y;
    short img;
    short colMode;
    short nLayer;
    short obstacleType;
    CSprite* pSpr[4];
    int inkEffect;
    int inkEffectParam;    	
	int spriteFlag;
}
-(id)initWithCRun:(CRun*)rh;
-(void)dealloc;

@end
