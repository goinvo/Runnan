//----------------------------------------------------------------------------------
//
// CRUNVIEWCONTROLLER
//
//----------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "CRunView.h"

@class CRunApp;

@interface CRunViewController : UIViewController 
{
@public 
	CRunView* runView;
	CRunApp* runApp;
	CGRect screenRect;
	CGRect appRect;
}
- (void)dealloc; 
- (void)didReceiveMemoryWarning; 
- (void)loadView;
- (id)initWithApp:(CRunApp*)pApp;

@end
