//
//  LoginViewController.m
//  EmptyAppExample01
//
//  Created by Randall Nickerson on 2/27/14.
//  Copyright (c) 2014 Threadbare Games. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end



@implementation LoginViewController

static const bool SHOW_NAV_BAR = NO;

static const CGFloat KEYBOARD_ANIMATION_DURATION  = 0.3f;
static const CGFloat ANIMATION_DISTANCE_PORTRAIT  = 40.0f;
static const CGFloat ANIMATION_DISTANCE_LANDSCAPE = ANIMATION_DISTANCE_PORTRAIT * 0.75f;
static const NSInteger EMAIL_ADDRESS_FIELD_TAG    = 0;
static const NSInteger PASSWORD_FIELD_TAG         = 1;


- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        //
    }
    
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];

    [self txtEmail].delegate = self;
    [self txtPassword].delegate = self;
    
    textfieldPlaceholderColor = [UIColor colorWithRed:216/255.0f green:240/255.0f blue:255/255.0f alpha:1.0f];
    NSMutableArray* placeholders = [[NSMutableArray alloc] init];
    [placeholders insertObject:@"Email Address" atIndex:EMAIL_ADDRESS_FIELD_TAG];
    [placeholders insertObject:@"Password" atIndex:PASSWORD_FIELD_TAG];
    textfieldPlaceholderTexts = [NSArray arrayWithArray:placeholders];
    [self txtEmail].placeholder = [textfieldPlaceholderTexts objectAtIndex:EMAIL_ADDRESS_FIELD_TAG];
    [self txtPassword].placeholder = [textfieldPlaceholderTexts objectAtIndex:PASSWORD_FIELD_TAG];
    
    [[self txtEmail] setValue:textfieldPlaceholderColor forKeyPath:@"_placeholderLabel.textColor"];
    [[self txtPassword] setValue:textfieldPlaceholderColor forKeyPath:@"_placeholderLabel.textColor"];
    
    [self.navigationController setNavigationBarHidden:SHOW_NAV_BAR];

}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self txtEmail] resignFirstResponder];
    [[self txtPassword] resignFirstResponder];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if (textField)
    {
        [textField resignFirstResponder];
    }
    
    if (([self authenticateWithEmail:[self txtEmail].text andPassword:[self txtPassword].text]))
    {
        [self performSegueWithIdentifier:@"ToNewsList" sender:self];
    }
    
    return NO;
}

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    
    textField.placeholder = nil;
    
    animatedDistance = 0.0f;
    
    UIInterfaceOrientation orientation =
    [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        animatedDistance = floor(ANIMATION_DISTANCE_PORTRAIT);
    }
    else
    {
        animatedDistance = floor(ANIMATION_DISTANCE_LANDSCAPE);
    }
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
    
}

- (void) textFieldDidEndEditing:(UITextField *)textField
{
    
    textField.placeholder = [textfieldPlaceholderTexts objectAtIndex:textField.tag];
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
    
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    NSLog(@"Preparing for segue [%@]", segue.identifier);
    
}


- (IBAction) authenticateTapped:(id)sender
{
    
    if (([self authenticateWithEmail:[self txtEmail].text andPassword:[self txtPassword].text]))
    {
        [self performSegueWithIdentifier:@"ToNewsList" sender:self];
    }
    
}

- (BOOL) authenticateWithEmail:(NSString*) email andPassword:(NSString*) pwd
{
    
    return (email.length > 0) && (pwd.length > 0);
    
}

- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
