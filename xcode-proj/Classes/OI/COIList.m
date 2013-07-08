//----------------------------------------------------------------------------------
//
// COILIST : liste des OI de l'application
//
//----------------------------------------------------------------------------------
#import "COIList.h"
#import "CRunApp.h"
#import "CChunk.h"
#import "COI.h"
#import "IEnum.h"

@implementation COIList

-(void)dealloc
{
	int index;
	for (index=0; index<oiMaxIndex; index++)
	{
		if (ois[index]!=nil)
		{
			[ois[index] release];
	    }
	}
	free(ois);
	free(oiLoaded);
	free(oiToLoad);
	
	[super dealloc];
}
-(void)preLoad:(CFile*)file
{
	// Alloue la table de OI
	oiMaxIndex=(short)[file readAInt];
	ois=(COI**)calloc(oiMaxIndex, sizeof(COI*));
	
	// Explore les chunks
	int index;
	oiMaxHandle=0;
	CChunk* chk=[[CChunk alloc] init];
	for (index=0; index<oiMaxIndex; index++)
	{
		int posEnd;
		chk->chID=0;
		while (chk->chID!=CHUNK_LAST)
		{
			[chk readHeader:file];
			if (chk->chSize==0)
				continue;
			posEnd=[file getFilePointer]+chk->chSize;
			switch(chk->chID)
			{
					// CHUNK_OBJINFOHEADER
				case 0x4444:
					ois[index]=[[COI alloc] init];
					[ois[index] loadHeader:file];
					if (ois[index]->oiHandle>=oiMaxHandle)
						oiMaxHandle=(short)(ois[index]->oiHandle+1);
					break;
					// CHUNK_OBJINFONAME
				case 0x4445:
					ois[index]->oiName=[file readAString];
					break;
					// CHUNK_OBJECTSCOMMON
				case 0x4446:
					ois[index]->oiFileOffset=[file getFilePointer];
					break;
			}
			// Positionne a la fin du chunk
			[file seek:posEnd];
		}
	}
	[chk release];
	
	// Table OI To Handle
	oiHandleToIndex=(short*)malloc(oiMaxHandle*sizeof(short));
	for (index=0; index<oiMaxIndex; index++)
	{
		oiHandleToIndex[ois[index]->oiHandle] = (short)index;
	}
	
	// Tables de chargement
	oiToLoad=(char*)malloc(oiMaxHandle*sizeof(char));
	oiLoaded=(char*)malloc(oiMaxHandle*sizeof(char));
	int n;
	for (n=0; n<oiMaxHandle; n++)
	{
		oiToLoad[n]=0;
		oiLoaded[n]=0;
	}
}
-(COI*)getOIFromHandle:(short)handle
{
	return ois[oiHandleToIndex[handle]];
}
-(COI*)getOIFromIndex:(short)index
{
	return ois[index];
}
-(void)resetOICurrent
{
	int n;
	for (n=0; n<oiMaxIndex; n++)
	{
	    ois[n]->oiFlags&=~OILF_CURFRAME;
	}
}
-(void)setOICurrent:(int)handle
{
	ois[oiHandleToIndex[handle]]->oiFlags|=OILF_CURFRAME;
}
-(COI*)getFirstOI
{
	int n;
	for (n=0; n<oiMaxIndex; n++)
	{
	    if ((ois[n]->oiFlags&OILF_CURFRAME)!=0)
	    {
			currentOI=n;
			return ois[n];
	    }
	}
	return nil;
}
-(COI*)getNextOI
{
	if (currentOI<oiMaxIndex)
	{
	    int n;
	    for (n=currentOI+1; n<oiMaxIndex; n++)
	    {
			if ((ois[n]->oiFlags&OILF_CURFRAME)!=0)
			{
				currentOI=n;
				return ois[n];
			}
	    }
	}
	return nil;
}
-(void)resetToLoad
{
	int n;
	for (n=0; n<oiMaxHandle; n++)
	{
	    oiToLoad[n]=0;
	}
}
-(void)setToLoad:(int)n
{
	oiToLoad[n]=1;
}
-(void)load:(CFile*)file 
{
	int h;
	for (h=0; h<oiMaxHandle; h++)
	{
	    if (oiToLoad[h]!=0)
	    {
			if (oiLoaded[h]==0 || (oiLoaded[h]!=0 && (ois[oiHandleToIndex[h]]->oiLoadFlags&OILF_TORELOAD)!=0) )
			{
				[ois[oiHandleToIndex[h]] load:file];
				oiLoaded[h]=1;
			}
	    }
	    else
	    {
			if (oiLoaded[h]!=0)
			{
				[ois[oiHandleToIndex[h]] unLoad];
				oiLoaded[h]=0;
			}
	    }
	}
	[self resetToLoad];
}
-(void)enumElements:(id)enumImages withFont:(id)enumFonts
{
	int h;
	for (h=0; h<oiMaxHandle; h++)
	{
	    if (oiLoaded[h]!=0)
	    {
			[ois[oiHandleToIndex[h]] enumElements:enumImages withFont:enumFonts];
	    }
	}
}


@end
