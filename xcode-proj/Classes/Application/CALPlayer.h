//
//  CALPlayer.h
//  RuntimeIPhone
//
//  Created by Francois Lionet on 24/03/11.
//  Copyright 2011 Clickteam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenAL/al.h>
#import <OpenAL/alc.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AudioToolbox/ExtendedAudioFile.h>

typedef ALvoid	AL_APIENTRY	(*alBufferDataStaticProcPtr) (const ALint bid, ALenum format, ALvoid* data, ALsizei size, ALsizei freq);
ALvoid  alBufferDataStaticProc(const ALint bid, ALenum format, ALvoid* data, ALsizei size, ALsizei freq);
void* GetOpenALAudioData(NSData* data, ALsizei *outDataSize, ALenum *outDataFormat, ALsizei*	outSampleRate);

#define NALCHANNELS 32

@class CSound;

@interface CALPlayer : NSObject 
{
 	ALCcontext* mContext; // stores the context (the 'air')
	ALCdevice* mDevice; // stores the device
   
    NSUInteger pSources[NALCHANNELS];
    CSound* pSounds[NALCHANNELS];
    int nLoops[NALCHANNELS];
    CALPlayer* parentPlayer;
    BOOL bPaused;
}

-(id)init;
-(id)initWithPlayer:(CALPlayer*)parent;
-(void)dealloc;
-(int)play:(CSound*)pSound loops:(int)nl channel:(int)channel;
-(void)stop:(int)nSound;
-(void)pause:(int)nSound;
-(void)resume:(int)nSound;
-(void)rewind:(int)nSound;
-(void)setVolume:(int)nSound volume:(float)v;
-(void)setPitch:(int)nSound pitch:(float)v;
-(BOOL)checkPlaying:(int)nSound;
-(void)resetSources;
-(void)beginInterruption;
-(void)endInterruption;
-(int)getPosition:(int)nSound;
@end

OSStatus read_Proc (void *inClientData, SInt64 inPosition, UInt32 requestCount, void *buffer, UInt32 *actualCount);
OSStatus write_Proc (void *inClientData, SInt64 inPosition, UInt32 requestCount, const void *buffer, UInt32  *actualCount);
SInt64 getSize_Proc (void *inClientData);
OSStatus setSize_Proc (void *inClientData, SInt64 size);
