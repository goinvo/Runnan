//----------------------------------------------------------------------------------
//
// CVALUE : classe de calcul et de stockage de valeurs
//
//----------------------------------------------------------------------------------
#import "CValue.h"

@implementation CValue

-(id)init
{
	type=TYPE_INT;
	intValue=0;
	stringValue=nil;
	return self;
}

-(void)dealloc
{
	if (stringValue!=nil)
	{
		[stringValue release];
		stringValue=nil;
	}
	[super dealloc];
}

-(id)initWithInt:(int)value
{
	type=TYPE_INT;
	intValue=value;
	stringValue=nil;
	return self;
}
-(id)initWithDouble:(double)value
{
	type=TYPE_DOUBLE;
	doubleValue=value;
	stringValue=nil;
	return self;
}
-(id)initWithString:(NSString*)string
{
	type=TYPE_STRING;
	stringValue=[[NSString alloc] initWithString:string];
	return self;
}
-(id)initWithValue:(CValue*)value
{
	stringValue=nil;
	switch (value->type)
	{
		case 0:
			intValue = value->intValue;
			break;
		case 1:
			doubleValue = value->doubleValue;
			break;
		case 2:
			stringValue=[[NSString alloc] initWithString:value->stringValue];
			break;
	}
	type = value->type;
	return self;
}
-(void)releaseString
{
	if (stringValue!=nil)
	{
		[stringValue release];
		stringValue=nil;
	}
}
-(short)getType
{
	return type;
}
-(int)getInt
{
	switch (type)
	{
		case 0:
			return intValue;
		case 1:
			return (int)doubleValue;
	}
	return 0;
}

-(double)getDouble
{
	switch (type)
	{
		case 0:
			return (double) intValue;
		case 1:
			return doubleValue;
	}
	return 0;
}

-(NSString*)getString
{
	if (type == TYPE_STRING)
	{
		return stringValue;
	}
	return @"";
}
-(void)forceInt:(int)value
{
	if (stringValue!=nil)
	{
		[stringValue release];
		stringValue=nil;
	}
	type = TYPE_INT;
	intValue = value;
}
-(void)forceDouble:(double)value
{
	if (stringValue!=nil)
	{
		[stringValue release];
		stringValue=nil;
	}
	type = TYPE_DOUBLE;
	doubleValue = value;
}
-(void)forceString:(NSString*)value
{
	if (stringValue!=nil)
	{
		[stringValue release];
		stringValue=nil;
	}
	type = TYPE_STRING;
	stringValue = [[NSString alloc] initWithString:value];
}
-(void)forceValue:(CValue*)value
{
	type = value->type;
	if (stringValue!=nil)
	{
		[stringValue release];
		stringValue=nil;
	}
	switch (type)
	{
		case 0:
			intValue = value->intValue;
			break;
		case 1:
			doubleValue = value->doubleValue;
			break;
		case 2:
			stringValue = [[NSString alloc] initWithString:value->stringValue];
			break;
	}
}
-(void)setValue:(CValue*)value
{
	switch (type)
	{
		case 0:
			intValue = [value getInt];
			break;
		case 1:
			doubleValue = [value getDouble];
			break;
		case 2:
			if (stringValue!=nil)
			{
				[stringValue release];
				stringValue=nil;
			}
			stringValue = [[NSString alloc] initWithString:[value getString]];
			break;
	}
}
-(void)getCompatibleTypes:(CValue*)value
{
	if (type == TYPE_INT && value->type == TYPE_DOUBLE)
	{
		[self convertToDouble];
	}
	else if (type == TYPE_DOUBLE && value->type == TYPE_INT)
	{
		[value convertToDouble];
	}
}

-(void)convertToDouble
{
	if (type == TYPE_INT)
	{
		doubleValue = (double) intValue;
		type = TYPE_DOUBLE;
	}
}
-(void)convertToInt
{
	if (type == TYPE_DOUBLE)
	{
		intValue = (int) doubleValue;
		type = TYPE_INT;
	}
}
-(void)add:(CValue*)value
{
	if (type != value->type)
	{
		[self getCompatibleTypes:value];
	}
	
	switch (type)
	{
		case TYPE_INT:
			intValue += value->intValue;
			break;
		case TYPE_DOUBLE:
			doubleValue += value->doubleValue;
			break;
		case TYPE_STRING:
		{
			NSString* temp=[stringValue stringByAppendingString:value->stringValue];
			if (stringValue!=nil)
			{
				[stringValue release];
				stringValue=nil;
			}
			stringValue=[[NSString alloc] initWithString:temp];
			break;
		}
	}
}
-(void)sub:(CValue*)value
{
	if (type != value->type)
	{
		[self getCompatibleTypes:value];
	}
	
	switch (type)
	{
		case 0:	// TYPE_INT:
			intValue -= value->intValue;
			break;
		case 1:	// TYPE_DOUBLE:
			doubleValue -= value->doubleValue;
			break;
	}
}
-(void)negate
{
	switch (type)
	{
		case 0:
			intValue = -intValue;
			break;
		case 1:
			doubleValue = -doubleValue;
			break;
	}
}
-(void)mul:(CValue*)value
{
	if (type != value->type)
	{
		[self getCompatibleTypes:value];
	}
	
	switch (type)
	{
		case 0:
			intValue *= value->intValue;
			break;
		case 1:
			doubleValue *= value->doubleValue;
			break;
	}
}
-(void)div:(CValue*)value
{
	if (type != value->type)
	{
		[self getCompatibleTypes:value];
	}
	
	switch (type)
	{
		case 0:
			if (value->intValue != 0)
			{
				intValue /= value->intValue;
			}
			else
			{
				intValue = 0;
			}
			break;
		case 1:
			if (value->doubleValue != 0.0)
			{
				doubleValue /= value->doubleValue;
			}
			else
			{
				doubleValue = 0.0;
			}
			break;
	}
}
-(void)pow:(CValue*)value
{
	if (type != value->type)
	{
		[self getCompatibleTypes:value];
	}
	
	switch (type)
	{
		case 0:
			doubleValue = pow([self getDouble], [value getDouble]);
			type = TYPE_DOUBLE;
			break;
		case 1:
			doubleValue = pow(doubleValue, value->doubleValue);
			break;
	}
}
-(void)mod:(CValue*)value
{
	if (type != value->type)
	{
		[self getCompatibleTypes:value];
	}
	
	switch (type)
	{
		case 0:
			if (value->intValue == 0)
			{
				intValue = 0;
			}
			else
			{
				intValue %= value->intValue;
			}
			break;
		case 1:
			if (value->doubleValue == 0.0)
			{
				doubleValue = 0.0;
			}
			else
			{
				doubleValue = (double)([self getInt]%[value getInt]);
			}
			break;
	}
}
-(void)andLog:(CValue*)value
{
	if (type != value->type)
	{
		[self getCompatibleTypes:value];
	}
	
	switch (type)
	{
		case 0:
			intValue &= value->intValue;
			break;
		case 1:
			[self forceInt:([self getInt]&[value getInt])];
			break;
	}
}
-(void)orLog:(CValue*)value
{
	if (type != value->type)
	{
		[self getCompatibleTypes:value];
	}
	
	switch (type)
	{
		case 0:
			intValue |= value->intValue;
			break;
		case 1:
			[self forceInt:([self getInt]|[value getInt])];
			break;
	}
}
-(void)xorLog:(CValue*)value
{
	if (type != value->type)
	{
		[self getCompatibleTypes:value];
	}
	
	switch (type)
	{
		case 0:
			intValue ^= value->intValue;
			break;
		case 1:
			[self forceInt:([self getInt]^[value getInt])];
			break;
	}
}
-(BOOL)equal:(CValue*)value
{
	if (type != value->type)
	{
		[self getCompatibleTypes:value];
	}
	
	switch (type)
	{
		case 0:
			return (intValue == value->intValue);
		case 1:
			return (doubleValue == value->doubleValue);
		case 2:
			return [stringValue compare:value->stringValue] == 0;
	}
	return NO;
}
-(BOOL)greater:(CValue*)value
{
	if (type != value->type)
	{
		[self getCompatibleTypes:value];
	}
	
	switch (type)
	{
		case 0:
			return (intValue >= value->intValue);
		case 1:
			return (doubleValue >= value->doubleValue);
		case 2:
			return [stringValue compare:value->stringValue] >= 0;
	}
	return NO;
}
-(BOOL)lower:(CValue*)value
{
	if (type != value->type)
	{
		[self getCompatibleTypes:value];
	}
	
	switch (type)
	{
		case 0:
			return (intValue <= value->intValue);
		case 1:
			return (doubleValue <= value->doubleValue);
		case 2:
			return [stringValue compare:value->stringValue] <= 0;
	}
	return NO;
}
-(BOOL)greaterThan:(CValue*)value
{
	if (type != value->type)
	{
		[self getCompatibleTypes:value];
	}
	
	switch (type)
	{
		case 0:
			return (intValue > value->intValue);
		case 1:
			return (doubleValue > value->doubleValue);
		case 2:
			return [stringValue compare:value->stringValue] > 0;
	}
	return false;
}
-(BOOL)lowerThan:(CValue*)value
{
	if (type != value->type)
	{
		[self getCompatibleTypes:value];
	}
	
	switch (type)
	{
		case 0:
			return (intValue < value->intValue);
		case 1:
			return (doubleValue < value->doubleValue);
		case 2:
			return [stringValue compare:value->stringValue] < 0;
	}
	return NO;
}
-(BOOL)notEqual:(CValue*)value
{
	if (type != value->type)
	{
		[self getCompatibleTypes:value];
	}
	
	switch (type)
	{
		case 0:
			return (intValue != value->intValue);
		case 1:
			return (doubleValue != value->doubleValue);
		case 2:
			return [stringValue compare:value->stringValue] != 0;
	}
	return NO;
}


-(NSString*)description
{
	switch (type)
	{
		case 0:
			return [NSString stringWithFormat:@"CValue int: '%i'", intValue];
		case 1:
			return [NSString stringWithFormat:@"CValue double: '%f'", (float)doubleValue];
		case 2:
			return [NSString stringWithFormat:@"CValue string: '%@'", stringValue];
	}
	return nil;
}


@end
