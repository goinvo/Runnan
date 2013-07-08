//----------------------------------------------------------------------------------
//
// CFILE : chargement des fichiers 
//
//----------------------------------------------------------------------------------
#import "CFile.h"
#import "CFontInfo.h"

@implementation CFile

-(id)initWithMemoryMappedFile:(NSString*)path
{	
	data=[[NSData alloc] initWithContentsOfMappedFile:path];
	maxLength=(int)[data length];
	pData=nil;
	pointer=0;
	useData=YES;
    bUnicode=NO;
	return self;
}

-(id)initWithPath:(NSString*)path
{	
	data=[[NSData alloc] initWithContentsOfFile:path];
	maxLength=(int)[data length];
	pData=nil;
	pointer=0;
	useData=YES;
    bUnicode=NO;
	return self;
}
-(id)initWithBytes:(unsigned char*)bytes length:(int)length
{
	data=nil;
	maxLength=length;
	pData=(char*)bytes;
	pointer=0;
	useData=NO;
    bUnicode=NO;
	return self;
}
-(id)initWithNSDataNoRelease:(NSData*)dt
{
	data=nil;
	maxLength=[dt length];
	pData=(char*)[dt bytes];
	pointer=0;
	useData=NO;
    bUnicode=NO;
	return self;
}
-(void)dealloc
{
	if (data!=nil)
		[data release];
	[super dealloc];
}
-(void)setUnicode:(BOOL)bUni
{
	bUnicode=bUni;
}
-(char)readAChar
{
	if(useData)
	{
		char rData;
		[data getBytes:&rData range:NSMakeRange(pointer++, sizeof(char))];
		return rData;
	}
	else
		return pData[pointer++];
}
-(NSData*)getSubData:(int)size
{
	return [data subdataWithRange:NSMakeRange(pointer, size)];
}
-(short)readAShort
{
	int b1, b2;
	b1 = [self readUnsignedByte];
	b2 = [self readUnsignedByte];
	return (short) (b2<<8 | b1);
}
-(void)readACharBuffer:(char*)pBuffer withLength:(int)length
{
	if(useData)
	{
		[data getBytes:pBuffer range:NSMakeRange(pointer, length)];
		pointer+=length;
	}
	else
	{
		memcpy(pBuffer, pData+pointer, length);
		pointer+=length;
	}
}
-(void)readAUnicharBuffer:(unichar*)pBuffer withLength:(int)length
{
	if(useData)
	{
		[data getBytes:pBuffer range:NSMakeRange(pointer, length*sizeof(unichar))];
		pointer+=length*sizeof(unichar);
	}
	else
	{
		memcpy(pBuffer, pData+pointer, length*sizeof(unichar));
		pointer+=length*sizeof(unichar);
	}
}
-(int)readAInt
{
	int b1, b2, b3, b4;
	b1 = [self readUnsignedByte];
	b2 = [self readUnsignedByte];
	b3 = [self readUnsignedByte];
	b4 = [self readUnsignedByte];
	return (b4<<24) | (b3<<16) | (b2<<8) | b1;
}
-(unsigned char)readAByte
{
	return (unsigned char)[self readUnsignedByte];
}
-(int)readAColor
{
	int b1, b2, b3;
	b1 = [self readUnsignedByte];
	b2 = [self readUnsignedByte];
	b3 = [self readUnsignedByte];
	[self readUnsignedByte];
	return (b1<<16) | (b2<<8) | b3;
}
-(float)readAFloat
{
	int b1, b2, b3, b4;
	b1 = [self readUnsignedByte];
	b2 = [self readUnsignedByte];
	b3 = [self readUnsignedByte];
	b4 = [self readUnsignedByte];
	long long total = b4 * 0x01000000 + b3 * 0x00010000 + b2 * 0x00000100 + b1;
	return (float) total / (float) 65536.0;
}

-(double)readADouble
{
	int b1, b2, b3, b4, b5, b6, b7, b8;
	b1 = [self readUnsignedByte];
	b2 = [self readUnsignedByte];
	b3 = [self readUnsignedByte];
	b4 = [self readUnsignedByte];
	b5 = [self readUnsignedByte];
	b6 = [self readUnsignedByte];
	b7 = [self readUnsignedByte];
	b8 = [self readUnsignedByte];
	long long total1 = b4 * 0x01000000 + b3 * 0x00010000 + b2 * 0x00000100 + b1;
	long long total2 = b8 * 0x01000000 + b7 * 0x00010000 + b6 * 0x00000100 + b5;
	long long total = (total2 << 32) | total1;
	double temp = (double) total / (double) 65536.0;
	return temp / (double) 65536.0;
}
-(NSString*)readAStringWithSize:(int)size
{
	if (bUnicode==NO)
	{
		char* pBuffer=(char*)malloc(size);
		[self readACharBuffer:pBuffer withLength:size];
		int n;
		for (n=0; n<size; n++)
		{
			if (pBuffer[n]==0)
			{
				break;
			}
		}
		NSString* pString=[[NSString alloc] initWithBytes:pBuffer length:n encoding:NSWindowsCP1252StringEncoding];
		free(pBuffer);
		return pString;
	}
	else
	{
		unichar* pBuffer=(unichar*)malloc(size*sizeof(unichar));
		[self readAUnicharBuffer:pBuffer withLength:size];
		int n;
		for (n=0; n<size; n++)
		{
			if (pBuffer[n]==0)
			{
				break;
			}
		}
		NSString* pString=[[NSString alloc] initWithCharacters:pBuffer length:n];
        free(pBuffer);
		return pString;
	}
}
-(NSString*)readAString
{
	NSString* pString=nil;
	int debut = [self getFilePointer];
	if (bUnicode==NO)
	{
		int b;
		do{
			b = [self readUnsignedByte];
		} while (b != 0);
		int end = [self getFilePointer];
		if (end > debut + 1)
		{
			if(useData)
			{
				NSData* subdata = [data subdataWithRange:NSMakeRange(debut, end-debut-1)];
				pString=[[NSString alloc] initWithData:subdata encoding:NSWindowsCP1252StringEncoding];
			}
			else
				pString=[[NSString alloc] initWithBytes:pData+debut length:end-debut-1 encoding:NSWindowsCP1252StringEncoding];
		}
	}
	else
	{
		unichar b;
		do{
			b = [self readAUnichar];
		} while (b != 0);
		long end = [self getFilePointer];
		if (end > debut + 2)
		{
			if(useData)
			{
                int l=(end-debut-2)/2;
                unichar* buffer=(unichar*)malloc(l*sizeof(unichar));
                [self seek:debut];
                [self readAUnicharBuffer:buffer withLength:l];
				pString=[[NSString alloc] initWithCharacters:buffer length:l];
                free(buffer);
                [self seek:end];
			}
			else
				pString=[[NSString alloc] initWithCharacters:(unichar*)((char*)pData+debut) length:(end-debut-2)/2];
		}
	}
	if (pString==nil)
	{
		pString=[[NSString alloc] init];
	}
	return pString;
}
-(NSString*)readAStringEOL
{
	int debut = [self getFilePointer];
	NSString* pString=nil;
	
	if (bUnicode==NO)
	{
		int b;
		b = [self readUnsignedByte];
		while (b != 10 && b != 13 && b!=0)
		{
			b = [self readUnsignedByte];
		}
		int end = [self getFilePointer]-1;
		if (b!=0)
		{
			int bb=[self readUnsignedByte];
			if ( (b==10 && bb!=13) || (b==13 && bb!=10) )
			{
				[self seek:end+1];
			}
		}
		if (end > debut)
		{
			int len = MIN(end, maxLength) - debut;
			if(useData)
			{
				pString=[[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(debut, len)] encoding:NSWindowsCP1252StringEncoding];
			}
			else
				pString=[[NSString alloc] initWithBytes:pData+debut length:len encoding:NSWindowsCP1252StringEncoding];
		}
	}
	else
	{
		unichar b=[self readAUnichar];
		while (b != 10 && b != 13)
		{
			b = [self readAUnichar];
		}
		int end = [self getFilePointer]-2;
        int fileEnd=end;
		if (b!=0)
		{
			unichar bb=[self readAUnichar];
			if ( (b==10 && bb!=13) || (b==13 && bb!=10) )
			{
				[self seek:end+2];                
            }
            else
            {
                fileEnd+=2;
            }
		}
		if (end > debut)
		{
			if(useData)
			{
                int l=(end-debut)/2;
                unichar* buffer=malloc(l*sizeof(unichar));
                [self seek:debut];
                [self readAUnicharBuffer:buffer withLength:l];
				pString=[[NSString alloc] initWithCharacters:buffer length:l];
                free(buffer);
                [self seek:fileEnd];
			}
			else
				pString=[[NSString alloc] initWithCharacters:(unichar*)((char*)pData+debut) length:(end-debut)/2];
		}
	}
	if (pString==nil)
	{
		pString=[[NSString alloc] init];
	}
	return pString;
}
-(void)skipAString
{
	if (bUnicode==NO)
	{
		int b;
		do
		{
			b = [self readUnsignedByte];
		} while (b != 0);
	}
	else
	{
		unichar b;
		do
		{
			b = [self readAUnichar];
		} while (b != 0);
	}
}
-(int)getFilePointer
{
	return pointer;
}
-(void)setFilePointer:(int)pos
{
	pointer=pos;
}
-(void)seek: (int)newPointer
{
	pointer=newPointer;
}
-(void)skipBack: (int)n
{
	pointer-=n;
}
-(void)skipBytes: (int) n
{
	pointer+=n;
}
-(BOOL)IsEOF
{
	return (pointer >= maxLength);
}
-(NSData*)readNSData: (int)l
{
	NSData* p=[data subdataWithRange:NSMakeRange(pointer,l)];
	pointer+=l;
	return p;
}
-(int)readUnsignedByte
{
	if(useData)
	{
		char nData;
		[data getBytes:&nData range:NSMakeRange(pointer++, sizeof(char))];
		return ((int)nData)&0xFF;
	}
	else	
		return ((int)pData[pointer++])&0xFF;
}
-(void)adjustTo8
{
	int offset = [self getFilePointer];
	if ((offset&0x07)!=0)
		[self seek:offset + (8-(offset&0x07))];
}
-(void)skipStringOfLength:(int)length
{
	int multiplier = bUnicode ? sizeof(unichar) : sizeof(char);
	[self skipBytes:length * multiplier];
}

-(unichar)readAUnichar
{
	int b1, b2;
	b1 = [self readUnsignedByte];
	b2 = [self readUnsignedByte];
	return (unichar) (b2<<8 | b1);
}
-(CFontInfo*)readLogFont16
{
	CFontInfo* info=[[CFontInfo alloc] init];
	info->lfHeight=[self readAShort];
	if (info->lfHeight<0)
	{
		info->lfHeight=-info->lfHeight;
	}
	[self skipBytes:6];	// width - escapement - orientation
	info->lfWeight = [self readAShort];
	info->lfItalic = [self readAByte];
	info->lfUnderline = [self readAByte];
	info->lfStrikeOut = [self readAByte];
	[self skipBytes:5];
	BOOL oldUnicode=bUnicode;
	bUnicode=NO;
	[info->lfFaceName release];
	info->lfFaceName = [self readAStringWithSize:32];
	bUnicode=oldUnicode;
	
	return info;
}

-(CFontInfo*)readLogFont
{
	CFontInfo* info = [[CFontInfo alloc] init];
	
	info->lfHeight = [self readAInt];
	if (info->lfHeight < 0)
	{
		info->lfHeight = -info->lfHeight;
	}
	[self skipBytes:12];	// width - escapement - orientation
	info->lfWeight = [self readAInt];
	info->lfItalic = [self readAByte];
	info->lfUnderline = [self readAByte];
	info->lfStrikeOut = [self readAByte];
	[self skipBytes:5];
	[info->lfFaceName release];
	info->lfFaceName = [self readAStringWithSize:32];
	
	return info;
}

@end
