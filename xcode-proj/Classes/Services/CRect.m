//----------------------------------------------------------------------------------
//
// CRECT : classe rectangle similaire a celle de windows
//
//----------------------------------------------------------------------------------
#include "CRect.h"

CRect CRectLoad(CFile* file)
{
	CRect rc;
	rc.left = [file readAInt];
	rc.top = [file readAInt];
	rc.right = [file readAInt];
	rc.bottom = [file readAInt];
	return rc;
}

CRect CRectInflate(CRect rc, int dx, int dy)
{
	rc.left-=dx;
	rc.top-=dy;
	rc.right+=dx;
	rc.top+=dy;
	return rc;
}

CRect CRectNil(void)
{
	CRect rc = {0,0,0,0};
	return rc;
}

BOOL CRectAreEqual(CRect a, CRect b)
{
	return a.left == b.left && a.top == b.top && a.left == b.left && a.bottom == b.bottom;
}

BOOL CRectPointInRect(CRect rc, int x, int y)
{
	if (x>=rc.left && x<rc.right && y>=rc.top && y<rc.bottom)
	    return YES;
	return NO;	
}

BOOL CRectIntersects(CRect a, CRect b)
{
	if ((b.left>=a.left && b.left<a.right) || (b.right>=a.left && b.right<a.right) || (a.left>=b.left && a.left<b.right) || (a.right>=b.left && a.right<b.right))
	{
	    if ((b.top>=a.top && b.top<a.bottom) || (b.bottom>=a.top && b.bottom<a.bottom) || (a.top>=b.top && a.top<b.bottom) || (a.bottom>=b.top && a.bottom<b.bottom))
	    {
			return YES;
	    }
	}
	return NO;
	
}

CRect CRectCreateAtPosition(int x, int y, int w, int h)
{
	CRect rc;
	rc.left = x;
	rc.top = y;
	rc.right = x+w;
	rc.bottom = y+h;
	return rc;
}

CRect CRectCreate(int left, int top, int right, int bottom)
{
	CRect rc;
	rc.left = left;
	rc.top = top;
	rc.right = right;
	rc.bottom = bottom;
	return rc;
}