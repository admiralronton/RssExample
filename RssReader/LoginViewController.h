//
//  LoginViewController.h
//  EmptyAppExample01
//
//  Created by Randall Nickerson on 2/27/14.
//  Copyright (c) 2014 Threadbare Games. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController <UITextFieldDelegate>
{
    UIColor* textfieldPlaceholderColor;
    NSArray* textfieldPlaceholderTexts;
    
    CGFloat animatedDistance;
}

@property (strong, nonatomic) IBOutlet UITextField *txtEmail;
@property (strong, nonatomic) IBOutlet UITextField *txtPassword;


@end
