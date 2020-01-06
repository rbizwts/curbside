//
//  SelectionVC.h
//  CurbSide
//
//  Created by WTS on 13/11/17.
//  Copyright © 2017 Kahan Rayjada. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectionVC : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *selectTable;
@property (nonatomic, strong) NSString *tag;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backTomain;
- (IBAction)backToHome:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *searchButton;
- (IBAction)searchSelection:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *otherSelectionField;
- (IBAction)doneSelection:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *orLbl;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableTop;
@property (weak, nonatomic) IBOutlet UILabel *specifyNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *noteLbl;
@property (weak, nonatomic) IBOutlet UILabel *tableHeaderLbl;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end
