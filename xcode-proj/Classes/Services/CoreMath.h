#import <Foundation/Foundation.h>

struct Point2D{float x, y;};
struct Size2D{float width, height;};
struct Scale2D{float x, y;};
struct Vec3f {float x,y,z;};
struct Mat3f {float a,b,c,d,e,f,g,h,i;};

typedef struct Point2D Point2D;
typedef struct Size2D Size2D;
typedef struct Scale2D Scale2D;
typedef struct Vec3f Vec3f;
typedef struct Mat3f Mat3f;

extern Vec3f MatrixMult(const Mat3f m, const Vec3f v);
//Mat3f MatrixMult(const Mat3f a, const Mat3f b);

extern Mat3f MaskspaceToWorldspace(Point2D position, Point2D hotspot, Scale2D scale, float angle);
extern Mat3f WorldspaceToMaskspace(Point2D position, Point2D hotspot, Scale2D scale, float angle);
extern Mat3f MaskspaceToMaskspace(Point2D positionA, Point2D hotspotA, Scale2D scaleA, float angleA, Point2D positionB, Point2D hotspotB, Scale2D scaleB, float angleB);

extern Mat3f TranslationMatrix(Point2D pos);
extern Mat3f ScaleMatrix(Scale2D scale);
extern Mat3f RotationMatrix(float angle);

extern Point2D MakePoint2D(float x, float y);
extern Size2D MakeSize2D(float w, float h);
extern Scale2D MakeScale2D(float sX, float sY);
extern Vec3f MakeVec3f(float x, float y, float z);
