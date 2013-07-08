
struct CPoint
{
	short x;
	short y;
};
typedef struct CPoint CPoint;

extern CPoint CPointMake(int x, int y);

struct CApproach
{
	BOOL isFound;
	CPoint point;
};
typedef struct CApproach CApproach;

extern CApproach CApproachMake(BOOL isFound, int x, int y);