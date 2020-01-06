//
//  HomeVC.h
//  CurbSide
//
//  Created by WTS on 13/11/17.
//  Copyright © 2017 Kahan Rayjada. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeVC : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *hospitalField;
@property (weak, nonatomic) IBOutlet UITextField *doctorField;
@property (weak, nonatomic) IBOutlet UITextField *serviceField;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
- (IBAction)submitForm:(id)sender;

@property (nonatomic, strong) NSString *selectedString;
@property (nonatomic, strong) NSString *tagString;
@property (nonatomic, strong) NSString *serviceString;

@end
