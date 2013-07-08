//----------------------------------------------------------------------------------
//
// CQuestion : Objet question
//
//----------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "CObject.h"
#import "IDrawable.h"
#import "CRect.h"

@class CSprite;
@class CDefText;
@class CFont;
@class CBitmap;
@class CRenderer;

@interface CQuestion : CObject <UIAlertViewDelegate>
{
@public
	int numReponses;
	UIAlertView* alert;
    BOOL bAsked;
}
-(void)initObject:(CObjectCommon*)ocPtr withCOB:(CCreateObjectInfo*)cob;

@end
