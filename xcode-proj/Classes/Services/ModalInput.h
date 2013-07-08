
#import <Foundation/Foundation.h>

@interface ModalInput : UIAlertView 
{
	UITextField *textField;
	UITextField *passwordField;
}
@property (nonatomic, retain) UITextField *textField;
@property (nonatomic, retain) UITextField *passwordField;
@property (readonly) NSString* text;
@property (readonly) NSString* password;

- (id)initStringWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle okButtonTitle:(NSString *)okButtonTitle;
- (id)initNumberWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle okButtonTitle:(NSString *)okButtonTitle;
- (id)initNamePasswordWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle okButtonTitle:(NSString *)okButtonTitle;

- (void)resignTextField;


@end