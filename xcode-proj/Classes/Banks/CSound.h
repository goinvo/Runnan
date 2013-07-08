//----------------------------------------------------------------------------------
//
// CSOUND : un echantillon
//
//----------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import <AVFoundation/AVAudioPlayer.h>
#import <OpenAL/al.h>
#import <OpenAL/alc.h>

@class CSoundPlayer;
@class CFile;
@class CALPlayer;

#define PSOUNDFLAG_IPHONE_AUDIOPLAYER 0x0004
#define PSOUNDFLAG_IPHONE_OPENAL 0x0008

@interface CSound : NSObject <AVAudioPlayerDelegate>
{
@public 
	CFile* file;
	int pointer;
	CSoundPlayer* soundPlayer;
    CALPlayer* ALPlayer;
	AVAudioPlayer* AVPlayer;
    short handle;
    BOOL bUninterruptible;
	BOOL bPlaying;
	BOOL bPaused;
	BOOL gamePaused;
	NSString* name;
    double volume;
    int duration;
    
    BOOL bAudioPlayer;
    NSUInteger bufferID;
    int nSound;
	NSTimeInterval pauseTime;

}
-(id)initWithSoundPlayer:(CSoundPlayer*)p andALPlayer:(CALPlayer*)alp;
-(void)dealloc;
-(void)load:(CFile*)file flags:(short)flags;
-(void)play:(int)nLoops channel:(int)channel;
-(void)pause:(BOOL)gamePause;
-(BOOL)isPaused;
-(void)resume:(BOOL)gameResume;
-(void)stop;
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag;
-(void)audioPlayerBeginInterruption:(AVAudioPlayer*)player;
-(void)audioPlayerEndInterruption:(AVAudioPlayer *)player;
-(void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer*)player error:(NSError*)error;
-(void)setVolume:(int)v;
-(int)getVolume;
-(void)setPosition:(int)p;
-(int)getPosition;
-(int)getDuration;
-(void)cleanMemory;
-(void)checkPlaying;
-(void)setPitch:(float)p;

@end
