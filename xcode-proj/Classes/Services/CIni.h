//
//  CIni.h
//  RuntimeIPhone


#import <Foundation/Foundation.h>

@class CArrayList;

@interface CIni : NSObject
{
@public
    CArrayList* strings;
    NSString* currentFileName;	
}
-(id)init;
-(void)dealloc;
-(void)loadIni:(NSString*)fileName;
-(void)saveIni;
-(int)findSection:(NSString*)sectionName;
-(int)findKey:(int)l withParam1:(NSString*)keyName;
-(NSString*)getPrivateProfileString:(NSString*)sectionName withParam1:(NSString*)keyName andParam2:(NSString*)defaultString andParam3:(NSString*)fileName;
-(void)writePrivateProfileString:(NSString*)sectionName withParam1:(NSString*)keyName andParam2:(NSString*)name andParam3:(NSString*)fileName;
-(void)deleteItem:(NSString*)group withParam1:(NSString*)item andParam2:(NSString*)iniName;
-(void)deleteGroup:(NSString*)group withParam1:(NSString*)iniName;
-(NSString*)description;

@end
