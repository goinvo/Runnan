// ------------------------------------------------------------------------------
// 
// EXTENSION conditions
// 
// ------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "CEvents.h"

#define MAX_CNDPARAMS 16

@class CValue;
@class CRun;

@interface CCndExtension : NSObject 
{
@public
	LPEVP pParams[MAX_CNDPARAMS];
}
-(void)initialize:(LPEVT)evtPtr;
-(LPEVP)getParamObject:(CRun*)rhPtr withNum:(int)num;
-(int)getParamTime:(CRun*)rhPtr withNum:(int)num;
-(short)getParamOi:(CRun*)rhPtr withNum:(int)num;
-(short)getParamBorder:(CRun*)rhPtr withNum:(int)num;
-(short)getParamAltValue:(CRun*)rhPtr withNum:(int)num;
-(short)getParamDirection:(CRun*)rhPtr withNum:(int)num;
-(int)getParamAnimation:(CRun*)rhPtr withNum:(int)num;
-(short)getParamPlayer:(CRun*)rhPtr withNum:(int)num;
-(LPEVP)getParamEvery:(CRun*)rhPtrw withNum:(int)num;
-(int)getParamSpeed:(CRun*)rhPtr withNum:(int)num;
-(LPPOS)getParamPosition:(CRun*)rhPtr withNum:(int)num;
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
-(BOOL)compareValues:(CRun*)rhPtr withNum:(int)num andValue:(CValue*)value;
-(BOOL)compareTime:(CRun*)rhPtr withNum:(int)num andTime:(int)t;

@end
