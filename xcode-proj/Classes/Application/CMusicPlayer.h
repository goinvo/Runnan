//----------------------------------------------------------------------------------
//
// CMUSICPLAYER : synthetiseur MIDI
//
//----------------------------------------------------------------------------------
#import <Foundation/Foundation.h>

@class CRunApp;

@interface CMusicPlayer : NSObject 
{
@public 
	CRunApp* runApp;
}

-(id)initWithApp:(CRunApp*)app;
-(void)dealloc;
-(void)stop;

@end
