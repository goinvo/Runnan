//----------------------------------------------------------------------------------
//
// CFILE : chargement des fichiers 
//
//----------------------------------------------------------------------------------

#import <Foundation/Foundation.h>

@class CFontInfo;

@interface CFile : NSObject 
{
@public
	NSData* data;
	char* pData;
	int pointer;
	int maxLength;
	BOOL bUnicode;
	BOOL useData;
}

#define STRINGENCODING	NSUTF8StringEncoding
#define UTFENCODING		NSUTF16LittleEndianStringEncoding

- (void)dealloc;
- (id)initWithMemoryMappedFile:(NSString*)path;
- (id)initWithPath:(NSString*)path;
- (id)initWithBytes:(unsigned char*)bytes length:(int)length;
- (id)initWithNSDataNoRelease:(NSData*)data;
- (void)setUnicode:(BOOL)bUnicode;
- (char)readAChar;
- (short)readAShort;
- (unichar)readAUnichar;
- (unsigned char)readAByte;
- (void)readACharBuffer:(char*)pBuffer withLength:(int)length;
- (void)readAUnicharBuffer:(unichar*)pBuffer withLength:(int)length;
- (int)readAInt;
- (int)readAColor;
- (float)readAFloat;
- (double)readADouble;
- (NSString*)readAStringWithSize: (int)size;
- (NSString*)readAString;
- (NSString*)readAStringEOL;
- (void)skipAString;
- (int)getFilePointer;
- (void)setFilePointer:(int)pos;
- (void)seek: (int)newPointer;
- (void)skipBack: (int)n;
- (void)skipBytes: (int)n;
- (NSData*)readNSData: (int)l;
- (int)readUnsignedByte;
- (NSData*)getSubData:(int)size;
-(CFontInfo*)readLogFont16;
-(CFontInfo*)readLogFont;
-(void)adjustTo8;
-(void)skipStringOfLength:(int)length;
-(BOOL)IsEOF;

@end
