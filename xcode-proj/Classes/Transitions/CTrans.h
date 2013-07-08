//----------------------------------------------------------------------------------
//
// CTRANS : interface avec un effet de transition
//
//----------------------------------------------------------------------------------
#import <Foundation/Foundation.h>

#define LEFT_RIGHT 0
#define RIGHT_LEFT 1
#define TOP_BOTTOM 2
#define BOTTOM_TOP 3
#define CENTER_LEFTRIGHT 0
#define LEFTRIGHT_CENTER 1
#define CENTER_TOPBOTTOM 2
#define TOPBOTTOM_CENTER 3
#define TOP_LEFT 0
#define TOP_RIGHT 1
#define BOTTOM_LEFT 2
#define BOTTOM_RIGHT 3
#define CENTER 4
#define DIR_HORZ 0
#define DIR_VERT 1
#define TRFLAG_FADEIN 0x0001
#define TRFLAG_FADEOUT 0x0002

@class CBitmap;
@class CFile;
@class CTransitionData;
@class CRunApp;
@class CRenderer;
@class CRenderToTexture;

@interface CTrans : NSObject 
{
@public
	CRunApp* app;
	double m_initTime;
    double m_currentTime;
    double m_endTime;
    int m_duration;
    BOOL m_overflow;
    BOOL m_running;
    BOOL m_starting;
    CRenderToTexture* source1;
    CRenderToTexture* source2;
	CRenderer* es2renderer;
	int tType;
}
-(void)setApp:(CRunApp*)a;
-(void)dealloc;
-(void)start:(CTransitionData*)data withRenderer:(CRenderer*)renderer andStart:(CRenderToTexture*)debut andEnd:(CRenderToTexture*)fin andType:(int)type;
-(void)finish;
-(BOOL)isCompleted;
-(int)getDeltaTime;
-(int)getTimePos;
-(void)setTimePos:(double)msTimePos;
-(void)initialize:(CTransitionData*)data withFile:(CFile*)file andRenderer:(CRenderer*)renderer andStart:(CRenderToTexture*)source andEnd:(CRenderToTexture*)dest andType:(int)type;
-(char*)stepDraw:(int)flag;
-(void)end;

@end
