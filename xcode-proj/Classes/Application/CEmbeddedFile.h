//----------------------------------------------------------------------------------
//
// CEMBEDDEDFILE : fichiers inclus dans l'application
//
//----------------------------------------------------------------------------------
#import <Foundation/Foundation.h>

@class CRunApp;

@interface CEmbeddedFile : NSObject 
{
@public 
	CRunApp* runApp;
	NSString* path;
	int length;
	int offset;
}

-(id)initWithApp:(CRunApp*)app;
-(void)preLoad;
-(NSData*)open;

@end
