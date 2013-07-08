//
//  CRunMobileUtilities.m
//  RuntimeIPhone
//
//  Created by Anders Riggelsen on 1/17/11.
//  Copyright 2011 Clickteam. All rights reserved.
//

#import "CRunMobileUtilities.h"

#import "CActExtension.h"
#import "CCndExtension.h"

#import "CExtension.h"
#import "CPoint.h"
#import "CCreateObjectInfo.h"
#import "CFile.h"

#import "CRunApp.h"
#import "CValue.h"
#import "CExtension.h"
#import "CRun.h"
#import "CServices.h"

#define	CND_LEFTKEYPRESSED					0
#define	CND_RIGHTKEYPRESSED					1
#define	CND_LEFTKEYDOWN						2
#define	CND_RIGHTKEYDOWN					3
#define CND_ORIENTATION						4
#define CND_ISMOBILE						5

#define ACT_SETROTATION						0
#define ACT_REFRESHALL						1

#define EXP_GETORIENTATION					0
#define EXP_GETROTATION						1
#define EXP_GETWIDTH						2
#define EXP_GETHEIGHT						3

@implementation CRunMobileUtilities


-(int)getNumberOfConditions
{
	return 6;
}

-(BOOL)createRunObject:(CFile*)file withCOB:(CCreateObjectInfo*)cob andVersion:(int)version
{
	return YES;
}

-(void)destroyRunObject:(BOOL)bFast
{

}


// Conditions
// --------------------------------------------------
-(BOOL)condition:(int)num withCndExtension:(CCndExtension*)cnd
{
	switch (num)
	{
		case CND_LEFTKEYPRESSED:
			return NO;
		case CND_RIGHTKEYPRESSED:
			return NO;
		case CND_LEFTKEYDOWN:
			return NO;
		case CND_RIGHTKEYDOWN:
			return NO;
		case CND_ORIENTATION:
			return YES;
		case CND_ISMOBILE:
			return YES;
	}
	return NO;
}



// Actions
// -------------------------------------------------
-(void)action:(int)num withActExtension:(CActExtension*)act
{
	switch (num)
	{
		case ACT_SETROTATION:
			[self act_setRotation:[act getParamExpression:rh withNum:0]];
		case ACT_REFRESHALL:
			break;
	}
}

-(void)act_setRotation:(int)rotation
{
	//UIDevice* device=[UIDevice currentDevice];
	//int orientation = device.orientation;
	
	
	/*switch (rotation)
	{
		case 0: //No rotation
			device.orientation = rotation;
			break;
		case 1: //90 clockwise
			break;
		case 2: //90 counterclockwise
			break;
	}*/
}


// Expressions
// --------------------------------------------
-(CValue*)expression:(int)num
{
	switch (num)
	{
		case EXP_GETORIENTATION:
			break;
			
		case EXP_GETROTATION:
			break;
			
		case EXP_GETWIDTH:
			break;
		
		case EXP_GETHEIGHT:
			break;
	}
	return [rh getTempValue:0];//won't happen
}


@end
