//----------------------------------------------------------------------------------
//
// CRECT : classe rectangle similaire a celle de windows
//
//----------------------------------------------------------------------------------

#import <Foundation/Foundation.h>
#import "CFile.h"

struct CRect
{
	int left;
	int top;
	int right;
	int bottom;
	
};
typedef struct CRect CRect;

CRect CRectLoad(CFile* file);
CRect CRectInflate(CRect rc, int dx, int dy);
CRect CRectNil(void);
CRect CRectCreateAtPosition(int x, int y, int w, int h);
CRect CRectCreate(int left, int top, int right, int bottom);
BOOL CRectPointInRect(CRect rc, int x, int y);
BOOL CRectIntersects(CRect a, CRect b);
BOOL CRectAreEqual(CRect a, CRect b);


