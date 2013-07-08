#import "CoreMath.h"

struct Point2D MakePoint2D(float x, float y)
{
	Point2D ret = {x,y};
	return ret;
}

struct Size2D MakeSize2D(float w, float h)
{
	Size2D ret = {w,h};
	return ret;
}

Scale2D MakeScale2D(float sX, float sY)
{
	Scale2D ret = {sX,sY};
	return ret;
}

Vec3f MakeVec3f(float x, float y, float z)
{
	Vec3f ret = {x,y,z};
	return ret;
}


Vec3f MatrixMult(const Mat3f m, const Vec3f v)
{
	Vec3f ret = {
		m.a*v.x + m.b*v.y + m.c*v.z,
		m.d*v.x + m.e*v.y + m.f*v.z,
		m.g*v.x + m.h*v.y + m.i*v.z
	};
	return ret;
}

/*Mat3f MatrixMult(const Mat3f &a, const Mat3f &b)
{
	Mat3f ret = {
		a.a*b.a + a.b*b.d + a.c*b.g,
		a.a*b.b + a.b*b.e + a.c*b.h,
		a.a*b.c + a.b*b.f + a.c*b.i,
		a.d*b.a + a.e*b.d + a.f*b.g,
		a.d*b.b + a.e*b.e + a.f*b.h,
		a.d*b.c + a.e*b.f + a.f*b.i,
		a.g*b.a + a.h*b.d + a.i*b.g,
		a.g*b.b + a.h*b.e + a.i*b.h,
		a.g*b.c + a.h*b.f + a.i*b.i
	};
	return ret;
}*/

Mat3f TranslationMatrix(Point2D pos)
{
	Mat3f ret = {
		1,	0,	pos.x,
		0,	1,	pos.y,
		0,	0,	1
	};
	return ret;
}

Mat3f ScaleMatrix(Scale2D scale)
{
	Mat3f ret = {
		scale.x,	0,			0,
		0,			scale.y,	0,
		0,			0,			1
	};
	return ret;
}

Mat3f RotationMatrix(float angle)
{
	float radians = -angle * 0.0174532925f;
	float cosA = cosf(radians);
	float sinA = sinf(radians);
	Mat3f ret = {
		cosA,	-sinA,	0,
		sinA,	cosA,	0,
		0,		0,		1
	};
	return ret;
}


Mat3f MaskspaceToWorldspace(Point2D position, Point2D hotspot, Scale2D scale, float angle)
{
	float radians = -angle * 0.0174532925f;
	float cosa = cosf(radians);
	float sina = sinf(radians);
	float sxa = scale.x;
	float sya = scale.y;
	float pxa = position.x;
	float pya = position.y;
	float hxa = hotspot.x;
	float hya = hotspot.y;

	Mat3f ret = {
		cosa*sxa,	-sina*sya,	-cosa*hxa*sxa + hya*sina*sya + pxa,
		sina*sxa,	cosa*sya,	-cosa*hya*sya - hxa*sina*sxa + pya,
		0,			0,			1
	};
	return ret;
}


Mat3f WorldspaceToMaskspace(Point2D position, Point2D hotspot, Scale2D scale, float angle)
{
	float radians = angle * 0.0174532925f;
	float cosb = cosf(radians);
	float sinb = sinf(radians);
	float sxb = 1.0f/scale.x;
	float syb = 1.0f/scale.y;
	float pxb = position.x;
	float pyb = position.y;
	float hxb = hotspot.x;
	float hyb = hotspot.y;

	Mat3f ret = {
		cosb*sxb,		-sinb*sxb,		-cosb*pxb*sxb + hxb + pyb*sinb*sxb,
		sinb*syb,		cosb*syb,		-cosb*pyb*syb + hyb - pxb*sinb*syb,
		0,				0,				1
	};
	return ret;
}

Mat3f MaskspaceToMaskspace(Point2D positionA, Point2D hotspotA, Scale2D scaleA, float angleA, Point2D positionB, Point2D hotspotB, Scale2D scaleB, float angleB)
{
	float radiansA = -angleA * 0.0174532925f;
	float cosa = cosf(radiansA);
	float sina = sinf(radiansA);
	float sxa = scaleA.x;
	float sya = scaleA.y;
	float pxa = positionA.x;
	float pya = positionA.y;
	float hxa = hotspotA.x;
	float hya = hotspotA.y;

	float radiansB = angleB * 0.0174532925f;
	float cosb = cosf(radiansB);
	float sinb = sinf(radiansB);
	float sxb = 1.0f/scaleB.x;
	float syb = 1.0f/scaleB.y;
	float pxb = positionB.x;
	float pyb = positionB.y;
	float hxb = hotspotB.x;
	float hyb = hotspotB.y;

	Mat3f ret = {
		cosa*cosb*sxa*sxb - sina*sinb*sxa*sxb,
		-cosa*sinb*sxb*sya - cosb*sina*sxb*sya,
		cosa*(hya*sinb*sxb*sya - cosb*hxa*sxa*sxb) + cosb*(hya*sina*sya + pxa - pxb)*sxb + hxa*sina*sinb*sxa*sxb + hxb - (pya - pyb)*sinb*sxb,
		cosa*sinb*sxa*syb + cosb*sina*sxa*syb,
		cosa*cosb*sya*syb - sina*sinb*sya*syb,
		cosa*(-cosb*hya*sya*syb - hxa*sinb*sxa*syb) - cosb*(hxa*sina*sxa - pya + pyb)*syb + hya*sina*sinb*sya*syb + hyb + pxa*sinb*syb - pxb*sinb*syb,
		0, 0, 1
	};
	return ret;
}