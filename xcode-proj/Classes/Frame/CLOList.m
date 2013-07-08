//----------------------------------------------------------------------------------
//
// CLOLIST : liste de levelobjects
//
//----------------------------------------------------------------------------------
#import "CLOList.h"
#import "CRunApp.h"
#import "CLO.h"
#import "CFile.h"
#import "COI.h"
#import "COIList.h"

@implementation CLOList

-(id)initWithApp:(CRunApp*)a
{
	app=a;
	return self;
}
-(void)dealloc
{
	for (int n = 0; n < nIndex; n++)
		[list[n] release];
	
	free(list);
	free(handleToIndex);
	[super dealloc];
}
-(void)load
{
	nIndex = [app->file readAInt];
	list = (CLO**)malloc(nIndex*sizeof(CLO*));
	int n;
	short maxHandles = 0;

	for (n = 0; n < nIndex; n++)
	{
		list[n] = (CLO*)[[CLO alloc] init];

		[list[n] load:app->file];
		if (list[n]->loHandle + 1 > maxHandles)
		{
			maxHandles = (short) (list[n]->loHandle + 1);
		}
		COI* pOI = [app->OIList getOIFromHandle:list[n]->loOiHandle];
		list[n]->loType = pOI->oiType;
	}

	lHandleToIndex=maxHandles;
	handleToIndex = (short*)malloc(maxHandles*sizeof(short*));
	for (n = 0; n < nIndex; n++)
	{
		handleToIndex[list[n]->loHandle] = (short)n;
	}
}

-(CLO*)getLOFromIndex:(short)index
{
	return list[index];
}

-(CLO*)getLOFromHandle:(short)handle
{
	if (handle<lHandleToIndex)
	{
		return list[handleToIndex[handle]];
	}
	return nil;
}
	
-(CLO*)next_LevObj
{
	CLO* plo;
	
	if (loFranIndex < nIndex)
	{
		do
		{
			plo = list[loFranIndex++];
			if (plo->loType >= OBJ_SPR)
			{
				return plo;
			}
		} while (loFranIndex < nIndex);
	}
	return nil;
}

-(CLO*)first_LevObj
{
	loFranIndex = 0;
	return [self next_LevObj];
}	

@end
