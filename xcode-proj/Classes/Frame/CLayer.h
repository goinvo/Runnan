//----------------------------------------------------------------------------------
//
// CLAYER : classe layer
//
//----------------------------------------------------------------------------------
#import <Foundation/Foundation.h>

@class CFile;
@class CArrayList;

#define FLOPT_XCOEF 0x0001
#define FLOPT_YCOEF 0x0002
#define FLOPT_NOSAVEBKD 0x0004
#define FLOPT_WRAP_OBSOLETE 0x0008
#define FLOPT_VISIBLE 0x0010
#define FLOPT_WRAP_HORZ 0x0020
#define FLOPT_WRAP_VERT 0x0040
#define FLOPT_REDRAW 0x000010000
#define FLOPT_TOHIDE 0x000020000
#define FLOPT_TOSHOW 0x000040000

@interface CLayer : NSObject 
{
@public
	NSString* pName;			/// Name
	
    // Offset
    int x;				/// Current offset
    int y;
    int dx;				/// Offset to apply to the next refresh
    int dy;
	
    CArrayList* pBkd2;
	
    // Ladders
    CArrayList* pLadders;
	
    // Z-order max index for dynamic objects
    int nZOrderMax;
	
    // Permanent data (EditFrameLayer)
    int dwOptions;			/// Options
    float xCoef;
    float yCoef;
    int nBkdLOs;				/// Number of backdrop objects
    int nFirstLOIndex;			/// Index of first backdrop object in LO table
	
    // Backup for restart
    int backUp_dwOptions;
    float backUp_xCoef;
    float backUp_yCoef;
    int backUp_nBkdLOs;
    int backUp_nFirstLOIndex;
	
	CArrayList* m_loZones;
}

-(id)init;
-(void)dealloc;
-(void)load:(CFile*)file;

@end
