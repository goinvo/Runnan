//----------------------------------------------------------------------------------
//
// CSOUNDPLAYER : synthetiseur MIDI
//
//----------------------------------------------------------------------------------
#import <Foundation/Foundation.h>

@class CRunApp;
@class CSound;

void audioSessionListenerCallback(void* inClientData, UInt32 inInterruptionState);

#define NCHANNELS 32

@interface CSoundPlayer : NSObject 
{
@public
	CRunApp* runApp;
	BOOL bOn;
    CSound** channels;
    BOOL bMultipleSounds;
	BOOL* bLocked;
	int* volumes;
	int* frequencies;
	int mainVolume;
	CSoundPlayer* parentPlayer;
}

-(id)initWithApp:(CRunApp*)app;
-(id)initWithApp:(CRunApp*)app andSoundPlayer:(CSoundPlayer*)player;
-(void)dealloc;
-(void)reset;
-(void)play:(short)handle withNLoops:(int)nLoops andChannel:(int)channel andPrio:(BOOL)bPrio;
-(void)setMultipleSounds:(BOOL)bMultiple;
-(void)keepCurrentSounds;
-(void)setOnOff:(BOOL)bState;
-(BOOL)getOnOff;
-(void)stopAllSounds;
-(void)stopSample:(short)handle;
-(BOOL)isSoundPlaying;
-(BOOL)isSamplePlaying:(short)handle;
-(BOOL)isChannelPlaying:(int)channel;
-(void)setPositionSample:(short)handle withPosition:(int)pos;
-(int)getPositionSample:(short)handle;
-(void)pauseSample:(short)handle;
-(BOOL)isSamplePaused:(short)handle;
-(BOOL)isChannelPaused:(int)channel;
-(void)resumeSample:(short)handle;
-(void)pause:(BOOL)gamePause;
-(void)resume:(BOOL)gameResume;
-(void)pauseChannel:(int)channel;
-(void)stopChannel:(int)channel;
-(void)resumeChannel:(int)channel;
-(void)setPositionChannel:(int)channel withPosition:(int)pos;
-(int)getPositionChannel:(int)channel;
-(void)setVolumeSample:(short)handle withVolume:(int)pos;
-(void)setVolumeChannel:(int)channel withVolume:(int)v;
-(int)getVolumeChannel:(int)channel;
-(void)removeSound:(CSound*)s;
-(void)setMainVolume:(int)v;
-(void)lockChannel:(int)channel;
-(void)unLockChannel:(int)channel;
-(int)getMainVolume;
-(int)getDurationChannel:(int)channel;
-(int)getChannel:(NSString*)name;
-(int)getSamplePosition:(NSString*)name;
-(int)getSampleVolume:(NSString*)name;
-(int)getSampleDuration:(NSString*)name;
-(void)checkPlaying;
-(void)setFreqChannel:(int)channel withFreq:(int)v;
-(void)setFreqSample:(short)handle withFreq:(int)v;
-(int)getSampleFrequency:(NSString*)name;
-(int)getFrequencyChannel:(int)channel;

@end
