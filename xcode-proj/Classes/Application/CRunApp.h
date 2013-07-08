//----------------------------------------------------------------------------------
//
// CRUNAPP : Classe Application
//
//----------------------------------------------------------------------------------
#import <Foundation/Foundation.h>

#define RUNTIME_VERSION 0x0302
#define MAX_PLAYER 4
#define MAX_KEY 8
#define GA_BORDERMAX 0x0001
#define GA_NOHEADING 0x0002
#define GA_PANIC 0x0004
#define GA_SPEEDINDEPENDANT 0x0008
#define GA_STRETCH 0x0010
#define GA_MENUHIDDEN 0x0080
#define GA_MENUBAR 0x0100
#define GA_MAXIMISE 0x0200
#define GA_MIX 0x0400
#define GA_FULLSCREENATSTART 0x0800
#define GA_FULLSCREENSWITCH 0x1000
#define GA_PROTECTED 0x2000
#define GA_COPYRIGHT 0x4000
#define GA_ONEFILE (short)0x8000
#define GANF_SAMPLESOVERFRAMES 0x0001
#define GANF_RELOCFILES 0x0002
#define GANF_RUNFRAME 0x0004
#define GANF_SAMPLESEVENIFNOTFOCUS 0x0008
#define GANF_NOMINIMIZEBOX 0x0010
#define GANF_NOMAXIMIZEBOX 0x0020
#define GANF_NOTHICKFRAME 0x0040
#define GANF_DONOTCENTERFRAME 0x0080
#define GANF_SCREENSAVER_NOAUTOSTOP 0x0100
#define GANF_DISABLE_CLOSE 0x0200
#define GANF_HIDDENATSTART 0x0400
#define GANF_XPVISUALTHEMESUPPORT 0x0800
#define GANF_VSYNC 0x1000
#define GANF_RUNWHENMINIMIZED 0x2000
#define GANF_MDI 0x4000
#define GANF_RUNWHILERESIZING (short)0x8000
#define GAOF_DEBUGGERSHORTCUTS 0x0001
#define GAOF_DDRAW 0x0002
#define GAOF_DDRAWVRAM 0x0004
#define GAOF_OBSOLETE 0x0008
#define GAOF_AUTOIMGFLT 0x0010
#define GAOF_AUTOSNDFLT 0x0020
#define GAOF_ALLINONE 0x0040
#define GAOF_SHOWDEBUGGER 0x0080
#define GAOF_JAVASWING 0x1000
#define GAOF_JAVAAPPLET 0x2000
#define SL_RESTART 0
#define SL_STARTFRAME 1
#define SL_FRAMEFADEINLOOP 2
#define SL_FRAMELOOP 3
#define SL_FRAMEFADEOUTLOOP 4
#define SL_ENDFRAME 5
#define SL_QUIT 6
#define MAX_VK 523
#define CTRLTYPE_MOUSE 0
#define CTRLTYPE_JOY1 1
#define CTRLTYPE_JOY2 2
#define CTRLTYPE_JOY3 3
#define CTRLTYPE_JOY4 4
#define CTRLTYPE_KEYBOARD 5
#define ARF_MENUINIT 0x0001
#define ARF_MENUIMAGESLOADED 0x0002		// menu images have been loaded into memory
#define ARF_INGAMELOOP 0x0004
#define ARF_PAUSEDBEFOREMODALLOOP 0x0008
#define FILEINFO_DRIVE 0
#define FILEINFO_DIR 1
#define FILEINFO_TEMPPATH 2
#define FILEINFO_PATH 3
#define FILEINFO_APPNAME 4
#define DISPLAY_WINDOW 0
#define DISPLAY_SWING 1
#define DISPLAY_FULLSCREEN 2
#define DISPLAY_PANEL 3
#define DISPLAY_APPLET 4
#define kFilteringFactor 0.1
#define MAX_VIEWTOUCHES 10

#define VIEWMODE_CENTER 0
#define VIEWMODE_ADJUSTWINDOW 1
#define VIEWMODE_FITINSIDE_BORDERS 2
#define VIEWMODE_FITINSIDE_ADJUSTWINDOW 3
#define VIEWMODE_FITOUTSIDE 4
#define VIEWMODE_STRETCH 5

@class CArrayList;
@class CRunView;
@class MainView;
@class COIList;
@class CImageBank;
@class CFontBank;
@class CSoundBank;
@class CSoundPlayer;
@class CRunFrame;
@class CEmbeddedFile;
@class CTransitionManager;
@class CValue;
@class CFile;
@class CRun;
@class CExtLoader;
@class CEventProgram;
@class CSpriteGen;
@class CJoystick;
@class CJoystickAcc;
@class CBitmap;
@class CRenderer;
@class CTransitionManager;
@class CRenderToTexture;
@class CMask;
@class CIAdViewController;
@class MainViewController;
@class CCCA;
@class CObject;
@class CALPlayer;
@class CExtension;
@class RuntimeIPhoneAppDelegate;

#define ORIENTATION_PORTRAIT 0x00
#define ORIENTATION_LANDSCAPELEFT 0x01
#define ORIENTATION_LANDSCAPERIGHT 0x02
#define ORIENTATION_AUTOLANDSCAPE 0x04
#define ORIENTATION_AUTOPORTRAIT 0x05
#define ORIENTATION_PORTRAITUPSIDEDOWN 0x06

#define AH2OPT_ENABLEIAD 0x0100
#define AH2OPT_IADBOTTOM 0x0200
#define AH2OPT_STATUSLINE 0x0040
#define AH2OPT_ANTIALIASED 0x1000

@interface CRunApp : NSObject <UIAccelerometerDelegate>
{
@public 
	CRunView* runView;
	MainView* mainView;
	RuntimeIPhoneAppDelegate* appDelegate;
    MainViewController* mainViewController;
	CSpriteGen* spriteGen;
	CJoystick* joystick;
	CJoystickAcc* joystickAcc;
	id touches;
    int* frameOffsets;
    int frameMaxIndex;
    NSString** framePasswords;
    NSString* appName;
    short nGlobalValuesInit;
    char* globalValuesInitTypes;
    int* globalValuesInit;
    int nGlobalStringsInit;
    NSString** globalStringsInit;
    COIList* OIList;
    CImageBank* imageBank;
    CFontBank* fontBank;
    CSoundBank* soundBank;
    CSoundPlayer* soundPlayer;
    CALPlayer* ALPlayer;
    int appRunningState;
    int lives[MAX_PLAYER];
    int scores[MAX_PLAYER];
    NSString* playerNames[MAX_PLAYER];
    CArrayList* gValues;
    CArrayList* gStrings;
    CValue* tempGValue;
    int startFrame;
    int nextFrame;
    int currentFrame;
    CRunFrame* frame;
    CFile* file;
    CRunApp* parentApp;			//Parent CRunApp if this one is contained in a subapp
    int parentOptions;
    int parentX;
    int parentY;
    int parentWidth;
    int parentHeight;
	CCCA* subApp;				//If this CRunApp is contained in a subapp, this is the subapp object pointer
    long refTime;
    CRun* run;
	CEventProgram* events;
    // Application header
    short gaFlags;				// Flags
    short gaNewFlags;				// New flags
    short gaMode;				// graphic mode
    short gaOtherFlags;				// Other Flags	
    int gaCxWin;				// Window x-size
    int gaCyWin;				// Window y-size
    int gaScoreInit;				// Initial score
    int gaLivesInit;				// Initial number of lives
    int gaBorderColour;				// Border colour
    int gaNbFrames;				// Number of frames
    int gaFrameRate;				// Number of frames per second
	BOOL bScoresExternal;
	BOOL bLivesExternal;
    short* frameHandleToIndex;
    short frameMaxHandle;
    int cx;
    int cy;
	int mouseX;
    int mouseY;
	int mouseClick;
	BOOL bMouseDown;
    short appRunFlags;
    CArrayList* adGO;
    CArrayList* sysEvents;
    BOOL quit;
    CExtLoader* extLoader;
    int xOffset;
    int yOffset;
    int sxComponent;
    int syComponent;
    int debug;
    CArrayList* extensionStorage;
    CArrayList* embeddedFiles;
    CTransitionManager* transitionManager;
    BOOL bUnicode;
	int sxView;
	int syView;
	int displayType;
	CRenderer* renderer;
	int VBLCount;
	int frameRate;
	BOOL bStatusBar;
	int orientation;
	int actualOrientation;
	int hdr2Options;
	int accelerometerCount;
	double accX;
	double accY;
	double accZ;
	double filteredAccX;
	double filteredAccY;
	double filteredAccZ;
	double instantAccX;
	double instantAccY;
	double instantAccZ;
	CRenderToTexture* oldFrameImage;
	CMask* firstMask;
	CMask* secondMask;
	CIAdViewController* iAdViewController;
	CGRect screenRect;
    CExtension* iOSObject;
    short typeIOS;
	UITouch* cancelledTouches[MAX_VIEWTOUCHES];
    UITouch* currentTouch;
	CGRect lastInteraction;
	UIWindow* window;
	NSString* appEditorPathname;
    NSString* appTargetPathname;
	int viewMode;
	CCCA* modalSubapp;
}
-(void)cleanMemory;
-(void)setView:(CRunView*)pView;
-(id)initWithPath:(NSString*)path;
-(id)initWithFile:(CFile*)f;
-(id)initAsSubApp:(CRunApp*)parent;
-(void)dealloc;
-(void)clear;
-(void)setParentView:(CRunView*)view startFrame:(int)sFrame options:(int)options width:(int)sx height:(int)sy;
-(void)setIAdViewController:(CIAdViewController*)pCont;
-(void)setMainViewController:(MainViewController*)pCont;
-(BOOL)load;
-(BOOL)startApplication;
-(void)createDisplay;
-(BOOL)playApplication:(BOOL)bOnlyRestartApp;
-(void)endApplication;
-(int)startTheFrame;
-(BOOL)loopFrame;
-(void)endFrame;
-(void)killGlobalData;
-(void)initGlobal;
-(int*)getLives;
-(int*)getScores;
-(CArrayList*)getGlobalValues;
-(int)getNGlobalValues;
-(CArrayList*)getGlobalStrings;
-(int)getNGlobalStrings;
-(CArrayList*)checkGlobalValue:(int)num;
-(CValue*)getGlobalValueAt:(int)num;
-(void)setGlobalValueAt:(int)num value:(CValue*)value;
-(CArrayList*)checkGlobalString:(int)num;
-(NSString*)getGlobalStringAt:(int)num;
-(void) setGlobalStringAt:(int)num string:(NSString*)value;
-(void)loadAppHeader;
-(void)loadAppHeader2;
-(void)loadGlobalValues;
-(void)loadGlobalStrings;
-(void) loadFrameHandles:(int)size;
-(short)HCellToNCell:(short)hCell;
-(int)newGetCptVBL;
-(void)mouseMoved:(int)x withY:(int)y;
-(void)mouseClicked:(int)numTap;
-(void)mouseDown:(BOOL)bFlag;
-(void)setFrameRate:(int)rate;
-(void)createJoystick:(BOOL)bCreate withFlags:(int)flags;
-(void)createJoystickAcc:(BOOL)bCreate;
-(CTransitionManager*)getTransitionManager;
-(BOOL)startFrameFadeIn:(CRenderToTexture*)oldImage;
-(BOOL)loopFrameFadeIn;
-(BOOL)endFrameFadeIn;
-(BOOL)startFrameFadeOut:(CRenderToTexture*)oldImage;
-(BOOL)loopFrameFadeOut;
-(BOOL)endFrameFadeOut;
-(void)startAccelerometer;
-(void)endAccelerometer;
-(void)killAccelerometer;
-(void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration;
-(void)positionUIElement:(UIView*)view withObject:(CObject*)ho;
-(CGPoint)adjustPoint:(CGPoint)point;
-(BOOL)supportsOrientation:(UIInterfaceOrientation)interfaceOrientation;
-(NSUInteger)supportedOrientations;

-(void)touchesEnded:(NSSet*)touchesA withEvent:(UIEvent*)event;
-(void)touchesMoved:(NSSet *)touchesA withEvent:(UIEvent *)event;
-(void)touchesBegan:(NSSet *)touchesA withEvent:(UIEvent *)event;
-(void)touchesCancelled:(NSSet*)touchesA withEvent:(UIEvent*)event;
-(void)resetTouches;

-(void)registerForiOSEvents:(id<UIApplicationDelegate>)object;
-(void)unregisterForiOSEvents:(id<UIApplicationDelegate>)object;

+(CRunApp*)getRunApp;
+(void)setRunApp:(CRunApp*)app;

-(NSString*)getRelativePath:(NSString*)path;
-(BOOL)resourceFileExists:(NSString*)path;
-(NSData*)loadResourceData:(NSString*)path;
-(NSString*)getPathForWriting:(NSString*)path;
-(NSString*)getParent:(NSString*)path;
-(NSString*)stringGuessingEncoding:(NSData*)data;

-(CGSize)screenSize;
@end
