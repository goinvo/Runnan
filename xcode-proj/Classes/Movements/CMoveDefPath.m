//----------------------------------------------------------------------------------
//
// CMOVEDEFPATH : donnÈes du mouvement path
//
//----------------------------------------------------------------------------------
#import "CMoveDefPath.h"
#import "CFile.h"
#import "CPathStep.h"

@implementation CMoveDefPath

-(void)dealloc
{
	for (int n=0; n<mtNumber; n++)
		[steps[n] release];
	
	free(steps);	
	[super dealloc];
}
-(void)load:(CFile*)file withLength:(int)length
{
	mtNumber=[file readAShort];
	mtMinSpeed=[file readAShort];
	mtMaxSpeed=[file readAShort];
	mtLoop=[file readAByte];	
	mtRepos=[file readAByte];
	mtReverse=[file readAByte];
	[file skipBytes:1];
	
	steps=(CPathStep**)malloc(mtNumber*sizeof(CPathStep*));
	int n, next;
	int debut;
	for (n=0; n<mtNumber; n++)
	{
		debut=[file getFilePointer];
		steps[n]=[[CPathStep alloc] init];
		[file skipBytes:1];		// prev
		next=[file readUnsignedByte];
		[steps[n] load:file];
		[file seek:debut+next];
	}
}

@end
