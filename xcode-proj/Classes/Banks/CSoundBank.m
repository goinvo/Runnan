//----------------------------------------------------------------------------------
//
// CSOUNDBANK : stockage des sons
//
//----------------------------------------------------------------------------------
#import "CSoundBank.h"
#import "CRunApp.h"
#import "CSound.h"
#import "CFile.h"

@implementation CSoundBank

-(id)initWithApp:(CRunApp*)app
{
	runApp=app;
	return self;
}
-(void)dealloc
{
	if (sounds!=nil)
	{
		int n;
		for (n=0; n<nSounds; n++)
		{
			if (sounds[n]!=nil)
			{
				[sounds[n] release];
			}
		}
		free(sounds);			
	}
	if (offsetsToSounds!=nil)
	{
		free(offsetsToSounds);
	}
	if (handleToIndex!=nil)
	{
		free(handleToIndex);
	}
	if (useCount!=nil)
	{
		free(useCount);
	}
	if (audioFlags!=nil)
	{
		free(audioFlags);
	}
	[super dealloc];
}
-(void)preLoad
{
	// Nombre de handles
	nHandlesReel=[runApp->file readAShort];
	offsetsToSounds=(int*)malloc(nHandlesReel*sizeof(int));
	
	// Repere les positions des images
	int nSnd=[runApp->file readAShort];
	int n;
	int offset;
	int size;
	short handle;
	
	for (n=0; n<nSnd; n++)
	{
		offset=[runApp->file getFilePointer];
		handle=[runApp->file readAShort];
		size=[runApp->file readAShort];
		if (runApp->bUnicode)
		{
			size*=2;
		}
		[runApp->file skipBytes:size];
        [runApp->file skipBytes:4];
		size=[runApp->file readAInt];
		[runApp->file skipBytes:size];
		offsetsToSounds[handle]=offset;
	}
	
	// Reservation des tables
	useCount=(short*)malloc(nHandlesReel*sizeof(short));
	audioFlags=(short*)malloc(nHandlesReel*sizeof(short));
	[self resetToLoad];
	handleToIndex=nil;
	nHandlesTotal=nHandlesReel;
	nSounds=0;
	sounds=nil;
}

-(CSound*)getSoundFromHandle:(short)handle
{
	if (handle>=0 && handle<nHandlesTotal)
	    if (handleToIndex[handle]!=-1)
			return sounds[handleToIndex[handle]];
	return nil;
}
-(CSound*)getSoundFromIndex:(short)index
{
	if (index>=0 && index<nSounds)
	    return sounds[index];
	return nil;
}
-(void)cleanMemory
{
	int index;
	for (index=0; index<nSounds; index++)
	{
		if (sounds[index]!=nil)
		{
			[sounds[index] cleanMemory];
		}
	}
}

-(void)resetToLoad
{
	int n;
	for (n=0; n<nHandlesReel; n++)
	{
	    useCount[n]=0;
	}
}
-(void)setToLoad:(short)handle
{
    if (offsetsToSounds[handle]!=0)
    {
        useCount[handle]++;
//        audioFlags[handle]=f;
    }
}
-(void)setFlags:(short)handle flags:(short)flag
{
    if (offsetsToSounds[handle]!=0)
    {
        audioFlags[handle]=flag;
    }
}

-(void)load
{
	int n;
	
	// Combien de sons?
	nSounds=0;
	for (n=0; n<nHandlesReel; n++)
	{
	    if (useCount[n]!=0)
			nSounds++;
	}
	
	// Charge les sons
	int id=0;
	CSound** newSounds=(CSound**)calloc(nSounds, sizeof(CSound*));
	int count=0;
	int h;
	for (h=0; h<nHandlesReel; h++)
	{
	    if (useCount[h]!=0)
	    {
			if (sounds!=nil && handleToIndex[h]!=-1 && sounds[handleToIndex[h]]!=nil)
			{
				newSounds[count]=sounds[handleToIndex[h]];
			}
			else
			{
				newSounds[count]=[[CSound alloc] initWithSoundPlayer:runApp->soundPlayer andALPlayer:runApp->ALPlayer];
				[runApp->file seek:offsetsToSounds[h]];
				[newSounds[count] load:runApp->file flags:audioFlags[h]];
				id++;
			}
			count++;
	    }
		else
		{
			if (sounds!=nil && handleToIndex[h]>=0 && sounds[handleToIndex[h]]!=nil)
			{
				[sounds[handleToIndex[h]] release];
				sounds[handleToIndex[h]]=nil;
			}
		}			
	}
	if (sounds!=nil)
	{
		free(sounds);
	}		
	sounds=newSounds;
	
	// Cree la table d'indirection
	if (handleToIndex!=nil)
	{
		free(handleToIndex);
	}
	handleToIndex=(short*)malloc(nHandlesReel*sizeof(short));
	for (n=0; n<nHandlesReel; n++)
	{
	    handleToIndex[n]=-1;
	}
	for (n=0; n<nSounds; n++)
	{
	    handleToIndex[sounds[n]->handle]=(short)n;
	}
	nHandlesTotal=nHandlesReel;
	
	// Plus rien a charger
	[self resetToLoad];
}


@end
