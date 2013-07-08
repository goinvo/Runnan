// --------------------------------------------------------------------------------
//
// PROTOCOLE ITOUCHES
//
// --------------------------------------------------------------------------------


@protocol ITouches	

-(BOOL)touchBegan:(UITouch*)touch;
-(void)touchMoved:(UITouch *)touch;
-(void)touchEnded:(UITouch*)touch;
-(void)touchCancelled:(UITouch*)touch;
-(void)resetTouches;


@end
