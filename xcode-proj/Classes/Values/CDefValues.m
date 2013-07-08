//----------------------------------------------------------------------------------
//
// CDEF : DonnÈes d'un objet normal
//
//----------------------------------------------------------------------------------
#import "CDefValues.h"
#import "CFile.h"

@implementation CDefValues

-(id)init
{
	values=nil;
	return self;
}
-(void)dealloc
{
	if (values!=nil)
	{
		free(values);
	}
	[super dealloc];
}
-(void)load:(CFile*)file
{
	nValues=[file readAShort];
	if (nValues>0)
	{		
		values=(int*)malloc(nValues*sizeof(int));
		int n;
		for (n=0; n<nValues; n++)
		{
			values[n]=[file readAInt];
		}
    }
}

@end
