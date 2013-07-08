// -----------------------------------------------------------------------------
//
// CACTEXTENSION
//
// -----------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "CEvents.h"

#define MAX_ACTPARAMS 16

@class CValue;
@class CRun;
@class CFile;

@interface CActExtension : NSObject 
{
	LPEVP pParams[MAX_ACTPARAMS];
	LPEVT pEvent;
}
-(void)initialize:(LPEVT)evtPtr;
-(CObject*)getParamObject:(CRun*)rhPt withNum:(int)num;
-(short)getParamObjectType:(CRun*)rhPt withNum:(int)num;
-(int)getParamTime:(CRun*)rhPtr withNum:(int)num;
-(short)getParamBorder:(CRun*)rhPtr withNum:(int)num;
-(short)getParamAltValue:(CRun*)rhPtr withNum:(int)num;
-(short)getParamDirection:(CRun*)rhPtr withNum:(int)num;
-(int)getParamAnimation:(CRun*)rhPtr withNum:(int)num;
-(short)getParamPlayer:(CRun*)rhPtr withNum:(int)num;
-(LPEVP)getParamEvery:(CRun*)rhPtrw withNum:(int)num;
-(int)getParamSpeed:(CRun*)rhPtr withNum:(int)num;
-(unsigned int)getParamPosition:(CRun*)rhPtr withNum:(int)num;
-(short)getParamJoyDirection:(CRun*)rhPtr withNum:(int)num;
-(int)getParamExpression:(CRun*)rhPtr withNum:(int)num;
-(int)getParamColour:(CRun*)rhPtr withNum:(int)num;
-(short)getParamFrame:(CRun*)rhPtr withNum:(int)num;
-(int)getParamNewDirection:(CRun*)rhPtr withNum:(int)num;
-(short)getParamClick:(CRun*)rhPtr withNum:(int)num;
-(NSString*)getParamFilename:(CRun*)rhPtr withNum:(int)num;
-(NSString*)getParamExpString:(CRun*)rhPtr withNum:(int)num;
-(double)getParamExpDouble:(CRun*)rhPtr withNum:(int)num;
-(NSString*)getParamFilename2:(CRun*)rhPtr withNum:(int)num;
-(CFile*)getParamExtension:(CRun*)rhPtr withNum:(int)num;
-(short*)getParamZone:(CRun*)rhPtr withNum:(int)num;

@end
