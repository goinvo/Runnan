//----------------------------------------------------------------------------------
//
// CVALUE : classe de calcul et de stockage de valeurs
//
//----------------------------------------------------------------------------------
#import <Foundation/Foundation.h>

#define TYPE_INT 0
#define TYPE_DOUBLE 1
#define TYPE_STRING 2

@interface CValue : NSObject 
{
@public
	short type;
    int intValue;
    double doubleValue;
    NSString* stringValue;	
}
    
-(id)init;
-(id)initWithInt:(int)value;
-(id)initWithDouble:(double)value;
-(id)initWithString:(NSString*)string;
-(id)initWithValue:(CValue*)value;
-(void)dealloc;
-(void)releaseString;
-(short)getType;
-(int)getInt;
-(double)getDouble;
-(NSString*)getString;
-(void)forceInt:(int)value;
-(void)forceDouble:(double)value;
-(void)forceString:(NSString*)value;
-(void)forceValue:(CValue*)value;
-(void)setValue:(CValue*)value;
-(void)getCompatibleTypes:(CValue*)value;
-(void)convertToDouble;
-(void)convertToInt;
-(void)add:(CValue*)value;
-(void)sub:(CValue*)value;
-(void)negate;
-(void)mul:(CValue*)value;
-(void)div:(CValue*)value;
-(void)pow:(CValue*)value;
-(void)mod:(CValue*)value;
-(void)andLog:(CValue*)value;
-(void)orLog:(CValue*)value;
-(void)xorLog:(CValue*)value;
-(BOOL)equal:(CValue*)value;
-(BOOL)greater:(CValue*)value;
-(BOOL)lower:(CValue*)value;
-(BOOL)greaterThan:(CValue*)value;
-(BOOL)lowerThan:(CValue*)value;
-(BOOL)notEqual:(CValue*)value;
-(NSString*)description;

@end
