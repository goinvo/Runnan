//----------------------------------------------------------------------------------
//
// CRVAL : Alterable values et strings
//
//----------------------------------------------------------------------------------
#import <Foundation/Foundation.h>

#define VALUES_NUMBEROF_ALTERABLE 26
#define STRINGS_NUMBEROF_ALTERABLE 10

@class CValue;
@class CObject;
@class CObjectCommon;
@class CCreateObjectInfo;

@interface CRVal : NSObject 
{
@public
	int rvValueFlags;
    CValue** rvValues;
    NSString** rvStrings;	
}
-(void)dealloc;
-(id)initWithHO:(CObject*)ho andOC:(CObjectCommon*)ocPtr andCOB:(CCreateObjectInfo*)cob;
-(void)kill:(BOOL)bFast;
-(CValue*)getValue:(int)n;
-(NSString*)getString:(int)n;
-(void)setString:(int)n withString:(NSString*)s;

@end
