//
//  CTexture.h
//  RuntimeIPhone
//
//  Created by Anders Riggelsen on 8/15/10.
//  Copyright 2010 Clickteam. All rights reserved.
//

#import "CRenderer.h"
#import "CBitmap.h"

enum TextureQuality {
	RGBA8888,	//32 bit
	RGBA4444,	//16 bit
	RGBA5551,	//16 bit
	RGB888,		//24 bit
	RGB565		//16 bit
};

@protocol ITexture

-(int)getHandle;
-(int)uploadTexture;
-(int)deleteTexture;
-(int)getTextureID;
-(int)getWidth;
-(int)getHeight;
-(int)getTextureWidth;
-(int)getTextureHeight;
-(GLfloat*)getTextureCoordinates;
-(void)generateMipMaps;
-(int)getUsageCount;
-(void)resetCount;
-(void)incrementCount;
-(void)cleanMemory;
-(void)setResampling:(BOOL)resample;
-(BOOL)getResampling;

@end
