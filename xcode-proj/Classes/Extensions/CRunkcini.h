//----------------------------------------------------------------------------------
//
// CRUNKCINI : objet ini
//
//----------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "CRunExtension.h"

@class CFile;
@class CCreateObjectInfo;
@class CValue;
@class CCndExtension;
@class CActExtension;
@class CArrayList;
@class CIni;

@interface CRunkcini : CRunExtension 
{
    int saveCounter;
    CIni* ini;
    short iniFlags;
    NSString* iniName;
    NSString* iniCurrentGroup;
    NSString* iniCurrentItem;	
}
-(CValue*)GetStringGroupItem;
-(CValue*)GetStringItem;
-(CValue*)GetValueGroupItem;
-(CValue*)GetValueItem;
-(CValue*)GetString;
-(CValue*)GetValue;
-(CValue*)expression:(int)num;
-(void)DeleteGroup:(CActExtension*)act;
-(void)DeleteGroupItem:(CActExtension*)act;
-(void)DeleteItem:(CActExtension*)act;
-(void)SetStringGroupItem:(CActExtension*)act;
-(void)SetStringItem:(CActExtension*)act;
-(void)SetValueGroupItem:(CActExtension*)act;
-(void)SetValueItem:(CActExtension*)act;
-(void)SetCurrentFile:(CActExtension*)act;
-(void)SetString:(CActExtension*)act;
-(void)LoadPosition:(CActExtension*)act;
-(void)SavePosition:(CActExtension*)act;
-(void)SetValue:(CActExtension*)act;
-(void)SetCurrentItem:(CActExtension*)act;
-(void)SetCurrentGroup:(CActExtension*)act;
-(void)action:(int)num withActExtension:(CActExtension*)act;
-(int)handleRunObject;
-(void)destroyRunObject:(BOOL)bFast;
-(BOOL)createRunObject:(CFile*)file withCOB:(CCreateObjectInfo*)cob andVersion:(int)version;
-(int)getNumberOfConditions;
-(NSString*)cleanPCPath:(NSString*)srce;

@end


	
