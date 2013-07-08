//----------------------------------------------------------------------------------
//
// CEXTLOADER: Chargement des extensions
//
//----------------------------------------------------------------------------------
#import "CExtLoader.h"
#import "CRunApp.h"
#import "CRunExtension.h"
#import "CExtLoad.h"
#import "CFile.h"

@implementation CExtLoader

-(id)initWithApp:(CRunApp*)app
{
	runApp=app;
	return self;
}
-(void)dealloc
{
	if (extensions!=nil)
	{
		free(extensions);
	}
	if (numOfConditions!=nil)
	{
		free(numOfConditions);
	}
	[super dealloc];
}
-(void)loadList 
{
	int extCount=[runApp->file readAShort];
	extMaxHandles=[runApp->file readAShort];
	
	extensions=(CExtLoad**)calloc(extMaxHandles, sizeof(CExtLoad*));
	numOfConditions=(short*)calloc(extMaxHandles, sizeof(short));
	int n;
	
	for (n=0; n<extCount; n++)
	{
	    CExtLoad* e=[[CExtLoad alloc] init];
	    [e loadInfo:runApp->file];
	    extensions[e->handle]=nil;
        
        CRunExtension* ext=[e loadRunObject];
        if (ext!=nil)
        {
            extensions[e->handle]=e;	    
            numOfConditions[e->handle]=(short)[ext getNumberOfConditions];
            [ext release];
        }
	}
}
-(CRunExtension*)loadRunObject:(int)type
{
	type-=KPX_BASE;
	CRunExtension* ext=nil;
    if (type<extMaxHandles && extensions[type]!=nil)
    {
        ext=[extensions[type] loadRunObject];
    }
	return ext;
}  
-(int)getNumberOfConditions:(int)type
{
	type-=KPX_BASE;
    if (type<extMaxHandles)
    {
        return numOfConditions[type];
    }
    return 0;
}

@end
