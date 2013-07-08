//----------------------------------------------------------------------------------
//
// CARRAYLIST : classe extensible de stockage
//
//----------------------------------------------------------------------------------

#import <Foundation/Foundation.h>

#define GROWTH_STEP 5

@interface CArrayList : NSObject 
{
	void** pArray;
	int length;
	int numberOfEntries;
}
-(id)init;
-(void)dealloc;
-(void)getArray:(int)max;
-(void)ensureCapacity:(int)max;
-(int)add:(void*)o;
-(void)addIndex:(int)index object:(void*)o;
-(void*)get:(int)index;
-(void)set:(int)index object: (void*)o;
-(void)setAtGrow:(int)index object:(void*)o;
-(void)removeIndex:(int)index;
-(void)removeIndexFree:(int)i;
-(int)indexOf:(void*)o;
-(void)removeObject:(void*)o;
-(void)removeClearIndex:(int)index;
-(int)size;
-(void)clear;
-(void)clearRelease;
-(void)removeIndexRelease:(int)n;
-(void)freeRelease;
-(void)removeObjectRelease:(void*)o;

-(int)findString:(NSString*)string startingAt:(int)startIndex;
-(int)findStringExact:(NSString*)string startingAt:(int)startIndex;

-(void)sortCListItems;
-(NSMutableArray*)getNSArray;

@end





@interface CListItem : NSObject
{
@public
	NSString* string;
	int	data;
}
-(id)initWithString:(NSString*)s andData:(int)d;
-(void)dealloc;
@end