//----------------------------------------------------------------------------------
//
// CFONTINFO : informations sur une fonte
//
//----------------------------------------------------------------------------------
#import "CFontInfo.h"


@implementation CFontInfo

-(id)init
{
	lfHeight=8; 
	lfWeight=400; 
	lfItalic=0; 
	lfUnderline=0; 
	lfStrikeOut=0; 
	lfFaceName=[[NSString alloc] initWithString:@"Arial"];
	return self;
}
-(void)dealloc
{
	if (lfFaceName!=nil)
	{
		[lfFaceName release];
	}
	[super dealloc];
}
//public Font createFont()
-(void)copy:(CFontInfo*)f
{
	lfHeight=f->lfHeight; 
	lfWeight=f->lfWeight; 
	lfItalic=f->lfItalic; 
	lfUnderline=f->lfUnderline; 
	lfStrikeOut=f->lfStrikeOut; 
	[lfFaceName release];
	lfFaceName=[[NSString alloc] initWithString:f->lfFaceName];
}
-(void)setName:(NSString*)name
{
	[lfFaceName release];
	lfFaceName=[[NSString alloc] initWithString:name];
}
+(CFontInfo*)fontInfoFromFontInfo:(CFontInfo*)f
{
	CFontInfo* dest=[[CFontInfo alloc] init];
	dest->lfHeight=f->lfHeight; 
	dest->lfWeight=f->lfWeight; 
	dest->lfItalic=f->lfItalic; 
	dest->lfUnderline=f->lfUnderline; 
	dest->lfStrikeOut=f->lfStrikeOut; 
	[dest->lfFaceName release];
	dest->lfFaceName=[[NSString alloc] initWithString:f->lfFaceName];
	
	return dest;
}
-(UIFont*)createFont
{
	NSString* fontName=nil;
	NSArray* fNames=[UIFont familyNames];	
	int n;
	BOOL bQuit=NO;
	for (n=0; n<[fNames count]; n++)
	{
		NSString* fName=[fNames objectAtIndex:n];
		NSArray* ffNames=[UIFont fontNamesForFamilyName:fName];
		int m;
		for (m=0; m<[ffNames count]; m++)
		{
			NSString* ffName=[ffNames objectAtIndex:m];
			if ([lfFaceName caseInsensitiveCompare:ffName]==0)
			{
				fontName=[[NSString alloc] initWithString:ffName];
				bQuit=YES;
				break;
			}
		}
		if (bQuit)
		{
			break;
		}
	}	
	UIFont* font;
	if (fontName!=nil)
	{
		font=[UIFont fontWithName:fontName size:lfHeight];
		[fontName retain];
	}
	else
	{
		if (lfWeight>=600)
		{
			font=[UIFont boldSystemFontOfSize:lfHeight];
			[font retain];
		}
		else if (lfItalic!=0)
		{
			font=[UIFont italicSystemFontOfSize:lfHeight];
			[font retain];
		}
		else
		{
			font=[UIFont systemFontOfSize:lfHeight];
			[font retain];
		}
	}
	return font;
}

@end
