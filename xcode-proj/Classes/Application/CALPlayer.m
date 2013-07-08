//
//  CALPlayer.m
//  RuntimeIPhone
//
//  Created by Francois Lionet on 24/03/11.
//  Copyright 2011 Clickteam. All rights reserved.
//

#import "CALPlayer.h"
#import "CSound.h"

OSStatus read_Proc (void *inClientData, SInt64 inPosition, UInt32 requestCount, void *buffer, UInt32 *actualCount)
{
    NSData* data=(NSData*)inClientData;
    
    NSRange range;
    int length=requestCount;
    if (length+inPosition>[data length])
    {
        length=[data length]-inPosition;        
    }        
    range.location=inPosition;
    range.length=length;
    [data getBytes:buffer range:range];
    *actualCount=length;
    return noErr;
}
OSStatus write_Proc (void *inClientData, SInt64 inPosition, UInt32 requestCount, const void *buffer, UInt32  *actualCount)
{
    *actualCount=0;
    return noErr;
}
SInt64 getSize_Proc (void *inClientData)
{
    NSData* data=(NSData*)inClientData;
    return [data length];
}
OSStatus setSize_Proc (void *inClientData, SInt64 size)
{
    return noErr;
}

void* GetOpenALAudioData(NSData* data, ALsizei *outDataSize, ALenum *outDataFormat, ALsizei* outSampleRate)
{
	OSStatus err = noErr;
	SInt64 theFileLengthInFrames = 0;
	AudioStreamBasicDescription theFileFormat;
	UInt32 thePropertySize = sizeof(theFileFormat);
	ExtAudioFileRef extRef = NULL;
	void* theData = NULL;
	AudioStreamBasicDescription theOutputFormat;
    
	// Open a file with ExtAudioFileOpen()
    AudioFileID id=0;
    err=AudioFileOpenWithCallbacks(data, read_Proc, write_Proc, getSize_Proc, setSize_Proc, 0, &id);
    if (err) goto Exit;    
    err=ExtAudioFileWrapAudioFileID(id, false, &extRef);
	if(err) goto Exit;
    
	// Get the audio data format
	err = ExtAudioFileGetProperty(extRef, kExtAudioFileProperty_FileDataFormat, &thePropertySize, &theFileFormat);
	if(err) goto Exit; 
	if (theFileFormat.mChannelsPerFrame > 2)  goto Exit;
    
	// Set the client format to 16 bit signed integer (native-endian) data
	// Maintain the channel count and sample rate of the original source format
	theOutputFormat.mSampleRate = theFileFormat.mSampleRate;
	theOutputFormat.mChannelsPerFrame = theFileFormat.mChannelsPerFrame;
    
	theOutputFormat.mFormatID = kAudioFormatLinearPCM;
	theOutputFormat.mBytesPerPacket = 2 * theOutputFormat.mChannelsPerFrame;
	theOutputFormat.mFramesPerPacket = 1;
	theOutputFormat.mBytesPerFrame = 2 * theOutputFormat.mChannelsPerFrame;
	theOutputFormat.mBitsPerChannel = 16;
	theOutputFormat.mFormatFlags = kAudioFormatFlagsNativeEndian | kAudioFormatFlagIsPacked | kAudioFormatFlagIsSignedInteger;
    
	// Set the desired client (output) data format
	err = ExtAudioFileSetProperty(extRef, kExtAudioFileProperty_ClientDataFormat, sizeof(theOutputFormat), &theOutputFormat);
	if(err) goto Exit;
    
	// Get the total frame count
	thePropertySize = sizeof(theFileLengthInFrames);
	err = ExtAudioFileGetProperty(extRef, kExtAudioFileProperty_FileLengthFrames, &thePropertySize, &theFileLengthInFrames);
	if(err) goto Exit; 
    
	// Read all the data into memory
	UInt32		dataSize = theFileLengthInFrames * theOutputFormat.mBytesPerFrame;;
	theData = malloc(dataSize);
	if (theData)
	{
		AudioBufferList		theDataBuffer;
		theDataBuffer.mNumberBuffers = 1;
		theDataBuffer.mBuffers[0].mDataByteSize = dataSize;
		theDataBuffer.mBuffers[0].mNumberChannels = theOutputFormat.mChannelsPerFrame;
		theDataBuffer.mBuffers[0].mData = theData;
        
		// Read the data into an AudioBufferList
		err = ExtAudioFileRead(extRef, (UInt32*)&theFileLengthInFrames, &theDataBuffer);
		if(err == noErr)
		{
			// success
			*outDataSize = (ALsizei)dataSize;
			*outDataFormat = (theOutputFormat.mChannelsPerFrame > 1) ? AL_FORMAT_STEREO16 : AL_FORMAT_MONO16;
			*outSampleRate = (ALsizei)theOutputFormat.mSampleRate;
		}
		else
		{
			// failure
			free (theData);
			theData = NULL; // make sure to return NULL
			goto Exit;
		}
	}
    
Exit:
	// Dispose the ExtAudioFileRef, it is no longer needed
	if (extRef) ExtAudioFileDispose(extRef);
    if (id) AudioFileClose(id);
	return theData;
}



@implementation CALPlayer

-(id)init
{
    mDevice=alcOpenDevice(NULL);
	parentPlayer=nil;
    if (mDevice)
    {
        mContext=alcCreateContext(mDevice, NULL);
        alcMakeContextCurrent(mContext);
    }
    int n;
    for (n=0; n<NALCHANNELS; n++)
    {
        pSources[n]=0;
        pSounds[n]=nil;
    }
    bPaused=NO;
    return self;
}
-(id)initWithPlayer:(CALPlayer*)parent
{
    mDevice=parent->mDevice;
	parentPlayer = parent;
    int n;
    for (n=0; n<NALCHANNELS; n++)
    {
        pSources[n]=0;
        pSounds[n]=nil;
    }
    bPaused=NO;
    return self;
}

-(void)dealloc
{
    if (mDevice && parentPlayer==nil)
    {
        int n;
        for (n=0; n<NALCHANNELS; n++)
        {
            if (pSources[n]!=0)
            {
                alDeleteSources(1, &pSources[n]);
            }
        }            
        alcDestroyContext(mContext);
        alcCloseDevice(mDevice);
    }
    [super dealloc];
}
-(int)play:(CSound*)pSound loops:(int)nl channel:(int)channel
{
    if (pSound->bufferID==0)
    {
        return -1;
    }
    if (mDevice)
    {
        bPaused=NO;
        if (pSounds[channel]==pSound)
        {
            nLoops[channel]=nl;
			alSourceStop(pSources[channel]);
			alSourcei(pSources[channel], AL_BUFFER, AL_NONE);
			
			if(nl > 0)
			{
				alSourcei(pSources[channel], AL_LOOPING, AL_FALSE);
				for(int i=0; i<nl; ++i)
					alSourceQueueBuffers(pSources[channel], 1, &pSound->bufferID);
			}
			else
			{
				alSourcei(pSources[channel], AL_BUFFER,  pSound->bufferID);
				alSourcei(pSources[channel], AL_LOOPING, AL_TRUE);
			}
			
			alSourceRewind(pSources[channel]);
			alSourcePlay(pSources[channel]);
            return channel;
        }
        if (pSounds[channel]!=nil)
        {
            alSourceStop(pSources[channel]);
        }
        if (pSources[channel]==0)
        {
            alGenSources(1, &pSources[channel]);
        }
        pSounds[channel]=pSound;
        nLoops[channel]=nl;
		
		alSourceStop(pSources[channel]);
		alSourcei(pSources[channel], AL_BUFFER, AL_NONE);
		
		if(nl > 0)
		{
			alSourcei(pSources[channel], AL_LOOPING, AL_FALSE);
			for(int i=0; i<nl; ++i)
				alSourceQueueBuffers(pSources[channel], 1, &pSound->bufferID);
		}
		else
		{
			alSourcei(pSources[channel], AL_BUFFER,  pSound->bufferID);
			alSourcei(pSources[channel], AL_LOOPING, AL_TRUE);
		}
		
        alSourcef(pSources[channel], AL_PITCH, 1.0f);
        alSourcef(pSources[channel], AL_GAIN, 1.0f);
		
        alSourceRewind(pSources[channel]);
        alSourcePlay(pSources[channel]);
		
		ALenum error = alGetError();
		if(error != 0)
			NSLog(@"AL Error: %i", error);
		
        return channel;
    }       
    return -1;
}
-(void)resetSources
{
    int n;
    for (n=0; n<NALCHANNELS; n++)
    {
        if (pSources[n]!=0)
        {
            ALenum state;
            alGetSourcei(pSources[n], AL_SOURCE_STATE, &state);
            if (state!=AL_PLAYING && state!=AL_PAUSED)
            {
                alDeleteSources(1, &pSources[n]);
                pSources[n]=0;
            }            
        }
    }
}
-(void)beginInterruption
{
    alcMakeContextCurrent(NULL);
}
-(void)endInterruption
{
    alcMakeContextCurrent(mContext);
}

-(void)stop:(int)nSound
{
    if (nSound>=0 && pSources[nSound]!=0)
    {
        alSourceStop(pSources[nSound]);
		alDeleteSources(1, &pSources[nSound]);
		pSources[nSound]=0;
        pSounds[nSound]=nil;
        bPaused=NO;
    }
}
-(void)pause:(int)nSound
{
    if (nSound>=0 && pSources[nSound]!=0)
    {
        alSourcePause(pSources[nSound]);
        bPaused=YES;
    }
}
-(void)resume:(int)nSound
{
    if (nSound>=0 && pSources[nSound]!=0)
    {
        alSourcePlay(pSources[nSound]);
        bPaused=NO;
    }
}
-(void)rewind:(int)nSound
{
    if (nSound>=0 && pSources[nSound]!=0)
    {
        alSourceRewind(pSources[nSound]);
    }
}
-(void)setVolume:(int)nSound volume:(float)v
{
    if (nSound>=0 && pSources[nSound]!=0)
    {
        alSourcef(pSources[nSound], AL_GAIN, v);
    }
}
-(void)setPitch:(int)nSound pitch:(float)v
{
    if (nSound>=0 && pSources[nSound]!=0)
    {
        alSourcef(pSources[nSound], AL_PITCH, v);
    }
}
-(BOOL)checkPlaying:(int)nSound
{
    if (bPaused)
    {
        return true;
    }
    if (nSound>=0 && pSources[nSound]!=0)
    {
        if (pSounds[nSound]!=nil)
        {
            ALenum state;
            alGetSourcei(pSources[nSound], AL_SOURCE_STATE, &state);
            if (state==AL_PLAYING || state==AL_INITIAL || state==AL_PAUSED)
            {
                return true;
            }
            pSounds[nSound]=nil;
        }
    }
    return false;    
}

-(int)getPosition:(int)nSound
{
	float offset = 0;
	alGetSourcef(pSources[nSound], AL_SEC_OFFSET, &offset);
	return (int)(offset*1000);
}

@end
