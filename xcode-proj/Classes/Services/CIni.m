//
//  CIni.m
//  RuntimeIPhone
//

#import "CIni.h"
#import "CFile.h"
#import "CArrayList.h"
#import "CRunApp.h"

// CINI ///////////////////////////////////////////////////////////////////////

@implementation CIni

-(id)init
{
	strings=[[CArrayList alloc] init];
	return self;
}
-(void)dealloc
{
	if (strings!=nil)
	{
		[strings clearRelease];
		[strings release];
	}
	if (currentFileName!=nil)
	{
		[currentFileName release];
	}
	[super dealloc];
}

-(void)loadIni:(NSString*)fileName
{
	BOOL reload=YES;
	if (currentFileName!=nil)
	{
		if ([currentFileName caseInsensitiveCompare:fileName]==0)
		{
			reload=NO;
		}
	}
	if (reload)
	{
		[self saveIni];

		if (currentFileName!=nil)
		{
			[currentFileName release];
		}
		currentFileName=[[NSString alloc] initWithString:fileName];

		if (strings==nil)
		{
			strings=[[CArrayList alloc] init];
		}
		else
		{
			[strings clearRelease];
		}

		if([[CRunApp getRunApp] resourceFileExists:fileName])
		{
			CRunApp* app = [CRunApp getRunApp];
			NSData* myData = [app loadResourceData:fileName];
			if (myData != nil && [myData length]!=0)
			{
				NSString* guess = [app stringGuessingEncoding:myData];
				if(guess != nil)
				{
					guess = [guess stringByReplacingOccurrencesOfString:@"\r" withString:@""];
					NSArray* lines = [guess componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
					
					for(NSString* s in lines)
						[strings add:[s retain]];
				}
			}
		}
	}
}
-(void)saveIni
{
	if (strings!=nil && currentFileName!=nil)
	{
		//Fix for INI object writing faulty data for some encodings
		NSMutableArray* arr = [strings getNSArray];
		NSString* fString = [arr componentsJoinedByString:@"\n"];
		NSString* path = [[CRunApp getRunApp] getPathForWriting:currentFileName];
		
		NSError* error = nil;
		[fString writeToFile:path atomically:NO encoding:NSUTF8StringEncoding error:&error];
		if(error != nil)
			NSLog(@"INI file write error: %@", error);
	}
}

-(int)findSection:(NSString*)sectionName
{
	int l;
	NSString* s;
	NSString* s2;
	for (l=0; l<[strings size]; l++)
	{
		s=(NSString*)[strings get:l];
        if ([s length]>0)
        {
            if ([s characterAtIndex:0]=='[')
            {
                NSRange range=[s rangeOfString:@"]"];
                if (range.location!=NSNotFound)
                {
                    int last=range.location;
                    if (last>=1)
                    {
                        range.location=1;
                        range.length=last-1;
                        s2=[[s substringWithRange:range] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                        if ([s2 caseInsensitiveCompare:sectionName]==0)
                        {
                            return l;
                        }
					}
				}
			}
		}
	}
	return -1;
}
-(int)findKey:(int)l withParam1:(NSString*)keyName
{
	NSString* s;
	NSString* s2;
	for (; l<[strings size]; l++)
	{
		s=(NSString*)[strings get:l];
        if ([s length]>0)
        {
            if ([s characterAtIndex:0]=='[')
            {
                return -1;
            }
            NSRange range=[s rangeOfString:@"="];
            if (range.location!=NSNotFound)
            {
                s2=[[s substringToIndex:range.location] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                if ([s2 caseInsensitiveCompare:keyName]==0)
                {
                    return l;
                }
			}
		}
	}
	return -1;
}

-(NSString*)getPrivateProfileString:(NSString*)sectionName withParam1:(NSString*)keyName andParam2:(NSString*)defaultString andParam3:(NSString*)fileName
{
	[self loadIni:fileName];
	
	int l=[self findSection:sectionName];
	if (l>=0)
	{
		l=[self findKey:l+1  withParam1:keyName];
		if (l>=0)
		{
			NSString* s=(NSString*)[strings get:l];
			NSRange range=[s rangeOfString:@"="]; 
            int start;
            for (start=range.location+1; start<[s length]; start++)
            {
                if ([s characterAtIndex:start]!=' ')
                {
                    break;
                }
            }
            int end;
            for (end=[s length]; end>0 && end>start; end--)
            {
                if ([s characterAtIndex:end-1]!=' ')
                {
                    break;
                }
            }
            range.location=start;
            range.length=end-start;
            if (range.length>0)
            {
                return [[NSString alloc] initWithString:[s substringWithRange:range]];
            }
		}
	}
	return defaultString;
}

-(void)writePrivateProfileString:(NSString*)sectionName withParam1:(NSString*)keyName andParam2:(NSString*)name andParam3:(NSString*)fileName
{
	[self loadIni:fileName];
	NSString* item = [[NSString alloc] initWithFormat:@"%@=%@", keyName, name];
	
	int section=[self findSection:sectionName];
	if (section<0)
	{
		[strings add:[[NSString alloc] initWithFormat:@"[%@]", sectionName]];
		[strings add:item];
		return;
	}
	
	int key=[self findKey:section+1  withParam1:keyName];
	if (key>=0)
	{
		[(NSString*)[strings get:key] release];
		[strings set:key object:item];
		return;
	}
	
	for (key=section+1; key<[strings size]; key++)
	{
		NSString* str = (NSString*)[strings get:key];
		if ([str length] > 0 && [str characterAtIndex:0]=='[')
		{
			[strings addIndex:key object:item];
			return;
		}
	}
	[strings add:item];
}    

-(void)deleteItem:(NSString*)group withParam1:(NSString*)item andParam2:(NSString*)iniName
{
	[self loadIni:iniName];
	
	int s=[self findSection:group];
	if (s>=0)
	{
		int k=[self findKey:s+1  withParam1:item];
		if (k>=0)
		{
			[strings removeClearIndex:k];
		}
	}
}

-(void)deleteGroup:(NSString*)group withParam1:(NSString*)iniName
{
	[self loadIni:iniName];
	
	int s=[self findSection:group];
	if (s>=0)
	{
		[strings removeClearIndex:s];
		while(YES)
		{
			if (s>=[strings size])
			{
				break;
			}
			
			NSString* str = (NSString*)[strings get:s];
			if ([str length] > 0 && [str characterAtIndex:0]=='[')
			{
				break;
			}
			[strings removeClearIndex:s];
		}
	}
}

-(NSString*)description
{
	NSMutableString* buffer = [[NSMutableString alloc] init];
	for (int l=0; l<[strings size]; l++)
	{
		NSString* s=(NSString*)[strings get:l];
        [buffer appendFormat:@"%@\n", s];
	}
	return buffer;
}

@end
