//
//  CServices.h
//  RuntimeIPhone
//
//  Created by Francois Lionet on 19/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CRect.h"

#define DT_LEFT 0x0000
#define DT_TOP 0x0000
#define DT_CENTER 0x0001
#define DT_RIGHT 0x0002
#define DT_BOTTOM 0x0008
#define DT_VCENTER 0x0004
#define DT_SINGLELINE 0x0020
#define DT_CALCRECT 0x0400
#define DT_VALIGN 0x0800
#define DT_NOINTERLINESUB 0x1000
#define CPTDISPFLAG_INTNDIGITS 0x000F
#define CPTDISPFLAG_FLOATNDIGITS 0x00F0
#define CPTDISPFLAG_FLOATNDIGITS_SHIFT 4
#define CPTDISPFLAG_FLOATNDECIMALS 0xF000
#define CPTDISPFLAG_FLOATNDECIMALS_SHIFT 12
#define CPTDISPFLAG_FLOAT_FORMAT 0x0200
#define CPTDISPFLAG_FLOAT_USEDECIMALS 0x0400
#define CPTDISPFLAG_FLOAT_PADD 0x0800

@class CFont;
@class CBitmap;
@class CRenderToTexture;
@class CRenderer;
@class CSprite;

extern int getR(int rgb);
extern int getG(int rgb);
extern int getB(int rgb);
extern int getRGB(int r, int g, int b);
extern int getRGBA(int r, int g, int b, int a);
extern int getABGR(int a, int b, int g, int r);
extern int getARGB(int a, int r, int g, int b);
extern int getABGRPremultiply(int a, int b, int g, int r);
extern int ABGRtoRGB(int abgr);
extern int inverseOpaqueColor(int color);
extern float degreesToRadians(float degrees);
extern float radiansToDegrees(float radians);
extern float Q_rsqrt(float number);

extern int clamp(int val, int a, int b);
extern double clampd(double val, double a, double b);
extern int max(int, int);
extern int min(int a, int b);
extern double maxd(double a, double b);
extern double mind(double a, double b);

double absDouble(double v);
extern void setRGBFillColor(CGContextRef ctx, int rgb);
extern void setRGBStrokeColor(CGContextRef ctx, int rgb);
extern void drawLine(CGContextRef context, int x1, int y1, int x2, int y2);
extern int HIWORD(int ul);
extern int LOWORD(int ul);
extern int POSX(int ul);
extern int POSY(int ul);
extern int MAKELONG(int lo, int hi);
extern int swapRGB(int rgb);
extern int strUnicharLen(unichar* str);
extern UIColor* getUIColor(int rgb);

@interface CServices : NSObject 
{
}

+(int)indexOf:(NSString*)s withChar:(unichar)c startingAt:(int)start;
+(int)drawText:(CBitmap*)bitmap withString:(NSString*)s andFlags:(short)flags andRect:(CRect)rc andColor:(int)rgb andFont:(CFont*)font andEffect:(int)effect andEffectParam:(int)effectParam;
+(NSString*)intToString:(int)v withFlags:(int)flags;
+(NSString*)doubleToString:(double)v withFlags:(int)flags;
+(UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
+(CGRect)CGRectFromSprite:(CSprite*)sprite;
@end

@interface TouchEventWrapper : NSObject
{
@public
	NSSet* touches;
	UIEvent* event;
}
-(id)initWithTouches:(NSSet*)touchSet andEvent:(UIEvent*)touchEvent;
-(void)dealloc;
@end

