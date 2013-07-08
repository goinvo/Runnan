//----------------------------------------------------------------------------------
//
// CRUNMultipleTOuch
//
//----------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "CRunExtension.h"
#import "ITouches.h"


@class CFile;
@class CCreateObjectInfo;
@class CValue;
@class CCndExtension;

#define MAX_TOUCHES 10

@interface CRunMultipleTouch : CRunExtension <ITouches>
{
	int newTouchCount;
	int endTouchCount;
	int movedTouchCount;
	int numberOfTouches;
	UITouch* touches[MAX_TOUCHES];
	int touchesX[MAX_TOUCHES];
	int touchesY[MAX_TOUCHES];
	int startX[MAX_TOUCHES];
	int startY[MAX_TOUCHES];
	int dragX[MAX_TOUCHES];
	int dragY[MAX_TOUCHES];
	int touchesNew[MAX_TOUCHES];
	int touchesEnd[MAX_TOUCHES];
	int lastTouch;
	int lastNewTouch;
	int lastEndTouch;
}
-(int)getNumberOfConditions;
-(BOOL)createRunObject:(CFile*)file withCOB:(CCreateObjectInfo*)cob andVersion:(int)version;
-(void)destroyRunObject:(BOOL)bFast;
-(BOOL)touchBegan:(UITouch*)touch;
-(void)touchMoved:(UITouch*)touch;
-(void)touchEnded:(UITouch*)touch;
-(void)touchCancelled:(UITouch*)touch;
-(void)action:(int)num withActExtension:(CActExtension*)act;
-(void)setOriginX:(CActExtension*)act;
-(void)setOriginY:(CActExtension*)act;
-(BOOL)condition:(int)num withCndExtension:(CCndExtension*)cnd;
-(BOOL)cndNewTouch:(CCndExtension*)cnd;
-(BOOL)cndEndTouch:(CCndExtension*)cnd;
-(BOOL)cndNewTouchAny:(CCndExtension*)cnd;
-(BOOL)cndEndTouchAny:(CCndExtension*)cnd;
-(BOOL)cndTouchMoved:(CCndExtension*)cnd;
-(BOOL)cndTouchActive:(CCndExtension*)cnd;
-(CValue*)expression:(int)num;
-(CValue*)expGetNumber;
-(CValue*)expGetX;
-(CValue*)expGetY;
-(CValue*)expGetOriginX;
-(CValue*)expGetOriginY;
-(CValue*)expGetDeltaX;
-(CValue*)expGetDeltaY;
-(CValue*)expGetAngle;
-(CValue*)expGetDistance;



@end
