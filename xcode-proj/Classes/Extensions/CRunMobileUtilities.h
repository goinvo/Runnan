//
//  CRunMobileUtilities.h
//  RuntimeIPhone
//
//  Created by Anders Riggelsen on 1/17/11.
//  Copyright 2011 Clickteam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CRunExtension.h"

@class CCreateObjectInfo;
@class CActExtension;
@class CCndExtension;
@class CFile;
@class CValue;
@class CArrayList;
@class CFontInfo;
@class CListItem;
@class ModalInput;

@interface CRunMobileUtilities : CRunExtension
{

}
-(int)getNumberOfConditions;
-(BOOL)createRunObject:(CFile*)file withCOB:(CCreateObjectInfo*)cob andVersion:(int)version;
-(void)destroyRunObject:(BOOL)bFast;

-(BOOL)condition:(int)num withCndExtension:(CCndExtension*)cnd;
-(void)action:(int)num withActExtension:(CActExtension*)act;
-(CValue*)expression:(int)num;

-(void)act_setRotation:(int)rotation;


@end
