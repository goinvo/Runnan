#import <Foundation/Foundation.h>

@class CRunApp;
@class CObject;
@class CObjInfo;
@class CQualToOiList;
@class CRun;
@class CEventProgram;

typedef BOOL(*FilterFunction)(id,CObject*);

@interface ObjectSelection : NSObject
{
@private
	CRunApp* rhPtr;
	CRun* run;
	CEventProgram* eventProgram;
}
/*!
 @method  initWithRunHeader:
 @abstract Initializes the ObjectSelection class with the CRunApp instance
 @param runApp The current CRunApp instance of the level
*/
-(id)initWithRunHeader:(CRunApp*)runApp;

/*!
 @method  selectAll:
 @abstract Modifies the selected objects list by reselecting all objects of the given type
 @param Oi The type (Oi) of the object to modify in the selected objects list
 */
-(void)selectAll:(short)OiList;

/*!
 @method  selectNone:
 @abstract Modifies the selected objects list by deselecting all objects if the given type
 @param Oi The type (Oi) of the object to modify in the selected objects list
 */
-(void)selectNone:(short)OiList;

/*!
 @method  selectOneObject:
 @abstract Modifies the selected objects list by selecting only one given instance of a type.
 @param object The object to select - this will be the only of it's type to be selected.
 */
-(void)selectOneObject:(CObject*)object;

/*!
 @method  selectObjects:withObjects:andCount
 @abstract Modifies the selected objects list by selecting all the objects from the list. They must all be of the type Oi.
 @param Oi The type (Oi) of the objects in the 'objects' array.
 @param objects Array of objects to select
 @param count Number of objects in the 'objects' array
 */
-(void)selectObjects:(short)OiList withObjects:(CObject**)objects andCount:(int)count;

/*!
 @method  filterObjects:andOi:andNegate:andFilterFunction:
 @abstract Filters the object list of the given type with a callback function.
 @param tag An object you wish to be passed to the filterFunction - typically your the caller class ('self')
 @param Oi The type of object you wish to run the filter on (can be both normal and qualifier type)
 @param negate Pass YES if the object selection should be negated
 @param filter Function pointer to the filter function of the type 'FilterFunction'
 */
-(BOOL)filterObjects:(id)tag andOi:(short)OiList andNegate:(BOOL)negate andFilterFunction:(FilterFunction)filter;

/*!
 DEPRECATED: Use the 'isOfType:' method in CObject* instances instead
 @method objectIsOfType:type:
 @abstract Returns YES if the object is of the given type (works for qualifier Oi's as well)
 @param obj The object to test
 @param Oi The object type to test for. Can be a normal Oi or a qualifier Oi
 */
-(BOOL)objectIsOfType:(CObject*)obj type:(short)OiList;

/*!
 @method getNumberOfSelected:
 @abstract Returns the number of selected objects for a given object type
 @param Oi The object type to test for. Can be a normal Oi or a qualifier Oi.
 */
-(int)getNumberOfSelected:(short)OiList;

@end