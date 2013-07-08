//----------------------------------------------------------------------------------
//
// CQUALTOOI : qualifiers
//
//----------------------------------------------------------------------------------
#import <Foundation/Foundation.h>


@interface CQualToOiList : NSObject 
{
@public
	short qoiCurrentOi;
    short qoiNext;
    short qoiActionPos;
    int qoiCurrentRoutine;
    int qoiActionCount;
    int qoiActionLoopCount;
    BOOL qoiNextFlag;
    BOOL qoiSelectedFlag;
	short nQoi;
    short* qoiList;						// Array OINUM / OFFSET	
}
-(id)init;
-(void)dealloc;

@end
