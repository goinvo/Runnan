//----------------------------------------------------------------------------------
//
// CRUNFRAME : contenu d'une frame
//
//----------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "CRect.h"

#define LEF_DISPLAYNAME 0x0001
#define LEF_GRABDESKTOP 0x0002
#define LEF_KEEPDISPLAY 0x0004
#define LEF_TOTALCOLMASK 0x0020
#define LEF_PASSWORD 0x0040
#define LEF_RESIZEATSTART 0x0100
#define LEF_DONOTCENTER 0x0200
#define LEF_FORCE_LOADONCALL 0x0400
#define LEF_NOSURFACE 0x0800
#define LEF_RESERVED_1 0x1000
#define LEF_RESERVED_2 0x2000
#define LEF_TIMEDMVTS 0x8000
#define IPHONEOPT_JOYSTICK_FIRE1 0x0001
#define IPHONEOPT_JOYSTICK_FIRE2 0x0002
#define IPHONEOPT_JOYSTICK_LEFTHAND 0x0004
#define IPHONEOPT_MULTITOUCH 0x0008
#define IPHONEOPT_SCREENLOCKING 0x0010
#define IPHONEOPT_IPHONEFRAMEIAD 0x0020
#define JOYSTICK_NONE 0x0000
#define JOYSTICK_TOUCH 0x0001
#define JOYSTICK_ACCELEROMETER 0x0002
#define JOYSTICK_EXT 0x0003

@class CRunApp;
@class CRun;
@class CLayer;
@class CLOList;
@class CEventProgram;
@class CColMask;
@class CSprite;
@class CTransitionData;
@class CTrans;

@interface CRunFrame : NSObject 
{
@public
    CRunApp* app;
    int leWidth;			// Playfield width in pixels
    int leHeight;		// Playfield height in pixels
    int leBackground;
    int leFlags;
    CRect leVirtualRect;
    int leEditWinWidth;
    int leEditWinHeight;
	int originalWinWidth;
	int originalWinHeight;
    NSString* frameName;
    int nLayers;
    CLayer** layers;
    CLOList* LOList;
    short maxObjects;
    // Coordinates of top-level pixel in edit window
    int leX;
    int leY;
    int leLastScrlX;
    int leLastScrlY;
	short joystick;
	short iPhoneOptions;
	
    // Transitions
	CTransitionData* fadeIn;
	CTransitionData* fadeOut;
    CTrans* pTrans;
    BOOL fade;
	int fadeTimerDelta;
	int fadeVblDelta;
	
    // Exit code
    int levelQuit;
	
    // Events
    BOOL rhOK;				// TRUE when the events are initialized
	
    // public int nPlayers;
    //	int				m_nPlayersReal;
    //	int				m_level_loop_state;
    int startLeX;
    int startLeY;
    //	short<w			m_maxObjects;
    //	short			m_maxOI;
    //	LPOBL			m_oblEnum;
    //	int				m_oblEnumCpt;
    //	BOOL			m_eventsBranched;
    //	DWORD			m_pasteMask;
	
    //	int				m_nCurTempString;
    //	LPSTR			m_pTempString[MAX_TEMPSTRING];
    int dwColMaskBits;
    CColMask* colMask;
    short m_wRandomSeed;
    int m_dwMvtTimerBase;	
}

-(id)initWithApp:(CRunApp*)pApp;
-(void)dealloc;
-(BOOL)loadFullFrame:(int)index;
-(void)loadLayers;
-(void)loadHeader;
-(int)getMaskBits;
-(BOOL)bkdLevObjCol_TestPoint:(int)x withY:(int)y andLayer:(int)nTestLayer andPlane:(int)nPlane;
-(BOOL)bkdLevObjCol_TestRect:(int)x withY:(int)y andWidth:(int)nWidth andHeight:(int)nHeight andLayer:(int)nTestLayer andPlane:(int)nPlane;
-(BOOL)bkdLevObjCol_TestSprite:(CSprite*)pSpr withImage:(short)newImg andX:(int)newX andY:(int)newY andAngle:(int)newAngle andScaleX:(float)newScaleX andScaleY:(float)newScaleY andFoot:(int)subHt andPlane:(int)nPlane;
-(BOOL)bkdCol_TestPoint:(int)x withY:(int)y andLayer:(int)nLayer andPlane:(int)nPlane;
-(BOOL)bkdCol_TestRect:(int) x withY:(int)y andWidth:(int)nWidth andHeight:(int)nHeight andLayer:(int)nLayer andPlane:(int)nPlane;
-(BOOL)bkdCol_TestSprite:(CSprite*)pSpr withImage:(int)newImg andX:(int)newX andY:(int)newY andAngle:(int)newAngle andScaleX:(float)newScaleX andScaleY:(float)newScaleY andFoot:(int)subHt andPlane:(int)nPlane;
-(BOOL)colMask_TestSprite:(CSprite*)pSpr withImage:(int)newImg andX:(int)newX andY:(int)newY andAngle:(int)newAngle andScaleX:(float)newScaleX andScaleY:(float)newScaleY andFoot:(int)subHt andPlane:(int)nPlane;

-(NSString*)description;

@end
