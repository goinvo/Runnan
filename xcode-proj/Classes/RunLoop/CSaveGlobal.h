// ---------------------------------------------------------------------------------
//
// CSaveGlobal : Sauvegarde des objets globaux
//
// ---------------------------------------------------------------------------------
#import <Foundation/Foundation.h>

@class CArrayList;
@class CValue;

@interface CSaveGlobal : NSObject 
{
@public
	NSString* name;
	CArrayList* objects;
}
-(id)init;
-(void)dealloc;

@end

@interface CSaveGlobalCounter : NSObject 
{
@public
	CValue* pValue;
	int rsMini;
	int rsMaxi;
	double rsMiniDouble;
	double rsMaxiDouble;
}
-(id)init;
-(void)dealloc;
@end

@interface CSaveGlobalText : NSObject 
{
@public
	NSString* pString;
	int rsMini;
}
-(id)init;
-(void)dealloc;
@end

@interface CSaveGlobalValues : NSObject 
{
@public
	NSString** pStrings;
	CValue** pValues;
	int flags;
}
-(id)init;
-(void)dealloc;
@end
