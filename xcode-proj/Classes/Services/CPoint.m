
#import "CPoint.h"


CPoint CPointMake(int x, int y)
{
	CPoint p;
	p.x = x;
	p.y = y;
	return p;
}


CApproach CApproachMake(BOOL isFound, int x, int y)
{
	CApproach a;
	a.isFound = isFound;
	a.point.x = x;
	a.point.y = y;
	return a;
}
