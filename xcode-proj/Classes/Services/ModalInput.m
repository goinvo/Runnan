#import "ModalInput.h"

@implementation ModalInput

@synthesize textField;
@synthesize passwordField;
@synthesize text;
@synthesize password;

-(id)initStringWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle okButtonTitle:(NSString *)okayButtonTitle
{
	textField = passwordField = self.textField = self.passwordField = nil;
	
    if ((self = [super initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:okayButtonTitle, nil]))
    {
		if([self respondsToSelector:@selector(setAlertViewStyle:)])
		{
			[self setAlertViewStyle:UIAlertViewStylePlainTextInput];
			self.textField = [self textFieldAtIndex:0];
		}
		else
		{
			UITextField *theTextField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 45.0, 260.0, 25.0)];
			[theTextField setBackgroundColor:[UIColor whiteColor]];
			self.textField = theTextField;
			[self addSubview:theTextField];
			[theTextField release];
			CGAffineTransform translate = CGAffineTransformMakeTranslation(0.0, 0.0);
			[self setTransform:translate];
		}
	}
    return self;
}

-(id)initNumberWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle okButtonTitle:(NSString *)okayButtonTitle
{
	textField = passwordField = self.textField = self.passwordField = nil;
	
    if ((self = [super initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:okayButtonTitle, nil]))
    {
		if([self respondsToSelector:@selector(setAlertViewStyle:)])
		{
			[self setAlertViewStyle:UIAlertViewStylePlainTextInput];
			[[self textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeNumberPad];
			self.textField = [self textFieldAtIndex:0];
		}
		else
		{
			UITextField *theTextField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 45.0, 260.0, 25.0)];
			theTextField.keyboardType = UIKeyboardTypeNumberPad;
			[theTextField setBackgroundColor:[UIColor whiteColor]];
			[self addSubview:theTextField];
			self.textField = theTextField;
			[theTextField release];
			CGAffineTransform translate = CGAffineTransformMakeTranslation(0.0, 0.0);
			[self setTransform:translate];
		}
    }
    return self;
}

-(id)initNamePasswordWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle okButtonTitle:(NSString *)okayButtonTitle
{
	textField = passwordField = self.textField = self.passwordField = nil;
	
    if ((self = [super initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:okayButtonTitle, nil]))
    {
		if([self respondsToSelector:@selector(setAlertViewStyle:)])
		{
			[self setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
			self.textField = [self textFieldAtIndex:0];
			self.passwordField = [self textFieldAtIndex:0];
		}
		else
		{
			UITextField *theTextField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 45.0, 260.0, 25.0)];
			UITextField *thePasswordField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 75.0, 260.0, 25.0)];
			self.textField = theTextField;
			self.passwordField = thePasswordField;
			thePasswordField.secureTextEntry = YES;
			[theTextField setBackgroundColor:[UIColor whiteColor]];
			[thePasswordField setBackgroundColor:[UIColor whiteColor]];
			[self addSubview:theTextField];
			[self addSubview:thePasswordField];
			[theTextField release];
			[thePasswordField release];
		}
    }
    return self;
}

- (void)show
{
	if([self respondsToSelector:@selector(setAlertViewStyle:)])
		[super show];
	else
	{
		[textField becomeFirstResponder];
		[super show];

		double add = 30.0;
		double pos = 0;
		if(passwordField != nil)
			add += 30.0;
		
		Class buttonClass = NSClassFromString(@"UIThreePartButton");
		for(UIView* subview in self.subviews)
		{
			if([subview isKindOfClass:[UILabel class]])
				pos = MAX(subview.frame.origin.y+subview.frame.size.height, pos);
			else if([subview isKindOfClass:buttonClass])
				subview.frame = CGRectMake(subview.frame.origin.x, subview.frame.origin.y+add, subview.frame.size.width, subview.frame.size.height);
		}
		
		textField.frame = CGRectMake(12.0, pos+5.0, 260.0, 25.0);
		if(passwordField != nil)
			passwordField.frame = CGRectMake(12.0, pos+35.0, 260.0, 25.0);
		
		self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height+add+10);
	}
}


- (NSString *)text
{
	if([self respondsToSelector:@selector(setAlertViewStyle:)])
	{
		NSString* theLoginString = [[self textFieldAtIndex:0] text];
		if(theLoginString != nil)
			return theLoginString;
	}
	else
	{
		if(textField != nil)
			return textField.text;
	}
	return @"";
}

- (NSString *)password
{
	if([self respondsToSelector:@selector(setAlertViewStyle:)])
	{
		switch (self.alertViewStyle)
		{
			case UIAlertViewStylePlainTextInput:
			{
				NSString* theLoginString = [[self textFieldAtIndex:0] text];
				if(theLoginString == nil)
					return @"";
				return theLoginString;
			}
				break;
			case UIAlertViewStyleLoginAndPasswordInput:
			{
				NSString* thePasswordString = [[self textFieldAtIndex:1] text];
				if(thePasswordString == nil)
					return @"";
				return thePasswordString;
			}
				break;
			default:
				break;
		}
	}
	else
	{
		if(passwordField != nil)
			return passwordField.text;
	}
	
	return @"";
}

-(void)resignTextField
{
if(![self respondsToSelector:@selector(setAlertViewStyle:)])
	[textField resignFirstResponder];
}


- (void)dealloc
{
	if(textField != nil)
		[textField release];
	if(passwordField != nil)
		[passwordField release];
    [super dealloc];
}


@end