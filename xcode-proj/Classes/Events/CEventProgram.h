//----------------------------------------------------------------------------------
//
// CEVENTPROGRAM : Programme des evenements
//
//----------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "CEvents.h"
#import "COI.h"
#import "IEnum.h"

@class CRunApp;
@class CLoadQualifiers;
@class CQualToOiList;
@class CObject;
@class CObjInfo;
@class CArrayList;
@class CRun;
@class CSoundBank;

@interface CEventProgram : NSObject 
{
@public
	CRunApp* app;
    CRun* rhPtr;
    short maxObjects;
    short maxOi;
    short nPlayers;
    short nConditions[7 + OBJ_LAST];         // NUMBEROF_SYSTEMTYPES+OBJ_LAST
    short nQualifiers;
    CLoadQualifiers** qualifiers;
    LPEVG pEvents;
    CQualToOiList** qualToOiList;
	DWORD* listPointers;
    DWORD* eventPointers;
//  BYTE eventPointersCnd[] = null;
    short* limitBuffer;
    LPDWORD rhEvents[NUMBEROF_SYSTEMTYPES + 1];
    LPDWORD rhEventAlways;
    LPDWORD rh4TimerEventsBase;
    short* colBuffer;
    int qualOilPtr;
    int qualOilPos;
    int qualOilPtr2;
    int qualOilPos2;
    BOOL rh4CheckDoneInstart;			/// Build92 to correct start of frame with fade in
    LPEVG rhEventGroup;				/// Current group
    int rhCurCode;                                       /// Current event
    int rh4PickFlags[4];				/// 00-31
    BOOL rh2ActionLoop;			/// Actions flag
    BOOL rh2ActionOn;			/// Flag are we in actions?
    BOOL rh2EnablePick;  			/// Are we in pick for actions?
    int rh2EventCount;				/// Number of the event
    int rh2ActionCount;				/// Action counter
    int rh2ActionLoopCount;	  		/// Action loops counter
    int rh4EventCountOR;                         /// Number of the event for OR conditions
    BOOL rh4ConditionsFalse;
    BOOL rh3DoStop;			/// Force the test of stop actions
    CQualToOiList* rh2EventQualPos;          /// ***Position in event objects
    int rh2EventQualPosNum;			/// ***Position in event objects
    CObject* rh2EventPos;				/// ***Position in event objects
    int rh2EventPosOiList; 		/// ***Position in oilist for TYPE exploration 
    CObject* rh2EventPrev;				/// ***Previous object address
    CObjInfo* rh2EventPrevOiList;				/// ***Previous object address
    int evtNSelectedObjects;
    BOOL repeatFlag;
    short rh2EventType;
    short rhCurOi;
    int rhCurParam[2];
    int rh3CurrentMenu;				/// For menu II events
    short rh2CurrentClick;			/// For click events II
    CObject* rh4_2ndObject;	 		/// Collision object address
    BOOL bReady;
    CArrayList* rh2ShuffleBuffer;
    short rhCurObjectNumber;	 		/// Object number
    short rh1stObjectNumber;          /// Number, for collisions
    CArrayList* rh2PushedEvents;
    BOOL rh2ActionEndRoutine;		/// End of action routine
	LPEVT rh4ActionStart;
    CArrayList* allocatedStrings;
}

-(id)initWithApp:(CRunApp*)a;
-(void)dealloc;
-(void)setCRun:(CRun*)rhPtr;
-(void)load;
-(void)prepareProgram;
-(LPEVG)inactiveGroup:(LPEVG)evgPtr;
-(LPSHORT)make_ColList2:(LPSHORT)colList withOi:(OINUM)oi1 andOiList:(WORD)ol;
-(LPSHORT)make_ColList1:(LPEVG)evgPtr withList:(LPSHORT)colList andOi:(short)oi1;
-(WORD)qual_GetNextOiList2;
-(WORD)qual_GetFirstOiList2:(short)o;
-(WORD)qual_GetNextOiList;
-(WORD)qual_GetFirstOiList:(short)o;
-(BOOL)isTypeRealSprite:(short)type;
-(short)get_OiListOffset:(short)oi withType:(short)type;
-(LPEVT)evg_FindAction:(LPEVG)evgPtr withNum:(int)n;
-(void)freeAssembledData;
-(short)assemblePrograms;
-(void)unBranchPrograms;
-(int)getCollisionFlags;
-(short)qoi_GetFirstList:(CQualToOiList*)pqoi;
-(short)qoi_GetNextList:(CQualToOiList*)pqoi;
-(short)qoi_GetFirstListSelected:(CQualToOiList*)pqoi;
-(short)qoi_GetNextListSelected:(CQualToOiList*)pqoi;
-(CObject*)get_CurrentObjectQualifier:(short)qoil;
-(CObject*)get_CurrentObject:(short)qoil;
-(CObject*)get_CurrentObjects:(short)qoil;
-(CObject*)get_ActionObjects:(LPEVT)evtPtr;
-(CObject*)get_ParamActionObjects:(short)qoil withAction:(LPEVT)evtPtr;
-(CObject*)get_ExpressionObjects:(short)expoi;
-(void)evt_BranchSelectedObjects;
-(void)evt_MarkSelectedObjects;
-(void)evt_DeleteCurrent;
-(void)evt_DeleteCurrentType:(short)nType;
-(void)evt_ForceOneObject:(short)oil withObject:(CObject*)pHo;
-(void)deselectThem:(short)oil;
-(void)evt_AddCurrentObject:(CObject*)pHo;
-(void)evt_DeleteCurrentObject;
-(void)evt_AddCurrentQualifier:(short)qual;
-(CObject*)evt_NextObject;
-(CObject*)qualProc:(short)sEvtOiList;
-(CObject*)evt_FirstObject:(short)sEvtOiList;
-(CObject*)evt_SelectAllFromType:(short)nType withFlag:(BOOL)bStore;
-(CObject*)evt_NextObjectFromType;
-(CObject*)evt_FirstObjectFromType:(short)nType;
-(BOOL)bts:(int*)array withIndex:(int)index;
-(void)enumSounds:(CSoundBank*)bank;
-(void)call_Stops:(LPEVT)pActions withObject:(CObject*)pHo;
-(void)call_Actions:(LPEVT)pActions;
-(void)computeEventList:(LPDWORD)pdw withObject:(CObject*)pHo;
-(void)compute_TimerEvents;
-(void)restartTimerEvents;
-(BOOL)handle_Event:(CObject*)pHo withCode:(int)code;
-(void)handle_GlobalEvents:(int)cond;
-(void)onMouseButton:(int)nClicks;
-(BOOL)pickFromId:(int)value;
-(CObject*)count_ObjectsFromOiList:(short)oil withStop:(int)stop;
-(CObject*)countThem:(short)oil withStop:(int)stop;
-(int)count_ZoneOneObject:(short)oil withZone:(short*)pZone;
-(int)czoCountThem:(short)oil withZone:(short*)pZone;
-(int)select_LineOfSight:(int)x1 withY1:(int)y1 andX2:(int)x2 andY2:(int)y2;
-(BOOL)losCompare:(double)x1 withY1:(double)y1 andX2:(double)x2 andY2:(double)y2 andObject:(CObject*)pHo;
-(int)select_ZoneTypeObjects:(short*)p withType:(short)type;
-(BOOL)czaCompare:(short*)pZone withObject:(CObject*)pHo;
-(CObject*)count_ObjectsFromType:(short)type withStop:(int)stop;
-(CObject*)count_ZoneTypeObjects:(short*)pZone withStop:(int)stop andType:(short)type;
-(BOOL)ctoCompare:(short*)pZone withObject:(CObject*)pHo;
-(void)onMouseMove;
-(void)handle_PushedEvents;
-(void)push_Event:(int)routine withCode:(int)code andParam:(int)lParam andObject:(CObject*)pHo andOI:(short)oi;
-(void)endShuffle;
-(void)finaliseColList;
-(void)addColList:(short)oiList withOiNum:(short)oiNum andOiList2:(short)oiList2 andOiNum2:(short)oiNum2;
-(void)freeAllocatedStrings;





@end
