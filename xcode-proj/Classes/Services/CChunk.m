// --------------------------------------------------------------------------------
//
// CCHUNK : lecture de troncons de donnees de l'application
//
// --------------------------------------------------------------------------------

#import "CChunk.h"

@implementation CChunk

-(id)init
{
	chID=0;
	chFlags=0;
	chSize=0;	
	return self;
}
-(void)dealloc
{
	[super dealloc];
}
-(short)readHeader: (CFile*)file
{
	chID=[file readAShort];
	chFlags=[file readAShort];
	chSize=[file readAInt];
	return chID;
}
-(void)skipChunk: (CFile*) file 
{
	[file skipBytes: ((int)chSize)];
}

@end
