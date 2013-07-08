//----------------------------------------------------------------------------------
//
// CRMVT : Donnees de base d'un mouvement
//
//----------------------------------------------------------------------------------
#import <Foundation/Foundation.h>

#define EF_GOESINPLAYFIELD 0x0001
#define EF_GOESOUTPLAYFIELD 0x0002
#define EF_WRAP 0x0004

@class CMove;
@class CObject;
@class CObjectCommon;
@class CCreateObjectInfo;
@class CMoveDefExtension;

@interface CRMvt : NSObject 
{
@public 
	int rmMvtNum;					// Number of the current movement
    CMove* rmMovement;
    CMove* rmMovementBackup;
    unsigned char rmWrapping;					// For CHECK POSITION
    BOOL rmMoveFlag;					// Messages/movements
    int rmReverse;					// Ahaid or reverse?
    BOOL rmBouncing;					// Bouncing?
    short rmEventFlags;				// To accelerate events	
}
-(void)dealloc;
-(void)initMovement:(int)nMove withObject:(CObject*)hoPtr andOC:(CObjectCommon*)ocPtr andCOB:(CCreateObjectInfo*)cob andNum:(int)forcedType;
-(void)initSimple:(CObject*)hoPtr withType:(int)forcedType andFlag:(BOOL)bRestore;
-(void)kill:(BOOL)bFast;
-(void)move;
-(void)nextMovement:(CObject*)hoPtr;
-(void)previousMovement:(CObject*)hoPtr;
-(void)selectMovement:(CObject*)hoPtr withNumber:(int)mvt;
-(int)dirAtStart:(CObject*)hoPtr withDirAtStart:(int)dirAtStart andDir:(int)dir;
-(CMove*)loadMvtExtension:(CObject*)hoPtr withDef:(CMoveDefExtension*)mvDef;

@end
