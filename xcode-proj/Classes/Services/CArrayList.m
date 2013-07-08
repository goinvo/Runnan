//----------------------------------------------------------------------------------
//
// CARRAYLIST : classe extensible de stockage
//
//----------------------------------------------------------------------------------
#import "CArrayList.h"

#define SORT_NAME sorter
#define SORT_TYPE int
#define SORT_CMP(x,y) (int)([((CListItem*)(x))->string caseInsensitiveCompare:(((CListItem*)(y))->string)])
#include "sort.h"

@implementation CArrayList

-(id)init
{
	numberOfEntries=0;
	pArray=nil;
	length=0;
	return self;
}
-(void)dealloc
{
	if (pArray!=nil)
	{
		free(pArray);
	}
	[super dealloc];
}
		
-(void)getArray:(int)max
{
	if (pArray==nil)
	{            
		pArray=(void**)malloc((max+GROWTH_STEP)*sizeof(void*));
		length=max+GROWTH_STEP;
	}
	else if (max>=length)
	{
		pArray=(void**)realloc(pArray, (max+GROWTH_STEP)*sizeof(void*));
		length=max+GROWTH_STEP;
	}
}
-(void)ensureCapacity:(int)max
{
	[self getArray:max];
}
-(int)add:(void*)o
{
	[self getArray: numberOfEntries];
	pArray[numberOfEntries]=o;
    return numberOfEntries++;
}
-(void)addIndex:(int)index object:(void*)o
{
	[self getArray: numberOfEntries];
	int n;
	for (n=numberOfEntries; n>index; n--)
	{
		pArray[n]=pArray[n-1];
	}
	pArray[index]=o;
	numberOfEntries++;
}
-(void*)get:(int)index
{
	if (index<numberOfEntries)
	{
		return pArray[index];
	}
	return nil;
}
-(void)set:(int)index object:(void*)o
{
	if (index<numberOfEntries)
	{
		pArray[index]=o;
	}
}

-(void)setAtGrow:(int)index object:(void*)o
{
	if(index >= numberOfEntries)
	{
		[self ensureCapacity:index+1];
		for(int i=numberOfEntries; i<=index; ++i)
			[self add:0];
	}
	[self set:index object:o];
}

-(void)removeIndex:(int)index
{
	if (index<numberOfEntries && numberOfEntries>0)
	{
		int n;
		for (n=index; n<numberOfEntries-1; n++)
		{
			pArray[n]=pArray[n+1];
		}
		numberOfEntries--;
		pArray[numberOfEntries]=nil;
	}
}
-(void)removeClearIndex:(int)index
{
	if (index<numberOfEntries && numberOfEntries>0)
	{
		[((id)pArray[index]) release];
		[self removeIndex:index];
	}
}
-(void)removeIndexRelease:(int)i
{
	id o=[self get:i];
	if (o!=nil)
	{
		[o release];
	}
	[self removeIndex:i];
}
-(void)removeIndexFree:(int)i
{
	void* o=[self get:i];
	if (o!=nil)
		free(o);
	[self removeIndex:i];
}
-(int)indexOf:(void*)o
{
	int n;
	for (n=0; n<numberOfEntries; n++)
	{
		if (pArray[n]==o)
		{
			return n;
		}
	}
	return -1;
}
-(void)removeObject:(void*)o
{
	int n=[self indexOf:o];
	if (n>=0)
	{
		[self removeIndex:n];
	}
}
-(void)removeObjectRelease:(void*)o
{
	int n=[self indexOf:o];
	if (n>=0)
	{
		[self removeIndexRelease:n];
	}
}
-(int)size
{
	return numberOfEntries;
}
-(void)clear
{
	numberOfEntries=0;
}
-(void)clearRelease
{
	int n;
	for (n=0; n<numberOfEntries; n++)
	{
		id obj = pArray[n];
		if (obj!=nil)
		{
			[obj release];
			pArray[n] = nil;
		}
	}
	numberOfEntries=0;
}
-(void)freeRelease
{
	int n;
	for (n=0; n<numberOfEntries; n++)
	{
		if (pArray[n]!=nil)
		{
			free(pArray[n]);
		}
	}
	numberOfEntries=0;
}


-(int)findString:(NSString*)string startingAt:(int)startIndex
{
	int strLen = [string length];
	for(int i=startIndex; i<numberOfEntries; ++i)
	{
		CListItem* item = (CListItem*)[self get:i];
		NSString* cmp = item->string;
		int cmpLen = [cmp length];

		if(cmpLen < strLen)
			continue;
		
		NSRange range = NSMakeRange(0, MIN(cmpLen,strLen));
		if([cmp compare:string options:NSCaseInsensitiveSearch range:range]==NSOrderedSame)
			return i;
	}
   return -1;
}

-(int)findStringExact:(NSString*)string startingAt:(int)startIndex
{
	for(int i=startIndex; i<numberOfEntries; ++i)
	{
		CListItem* item = (CListItem*)[self get:i];
		if([item->string caseInsensitiveCompare:string] == NSOrderedSame)
			return i;
	}
	return -1;
}

-(void)sortCListItems
{
	sorter_tim_sort((int*)pArray, numberOfEntries);
}

-(NSMutableArray*)getNSArray
{
	NSMutableArray* arr = [NSMutableArray arrayWithCapacity:numberOfEntries];
	for(int i=0; i<numberOfEntries; ++i)
	{
		[arr addObject:(id)[self get:i]];
	}
	return arr;
}

@end






@implementation CListItem

-(id)initWithString:(NSString*)s andData:(int)d
{
	string = [[NSString alloc] initWithString:s];
	data = d;
	return self;
}

-(void)dealloc
{
	[string release];	//Was wrong order before causing rare crash.
	[super dealloc];
}

@end


