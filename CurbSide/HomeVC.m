//
//  HomeVC.m
//  CurbSide
//
//  Created by WTS on 13/11/17.
//  Copyright © 2017 Kahan Rayjada. All rights reserved.
//

#import "HomeVC.h"
#import "SelectionVC.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "FCAlertView.h"
#import "Helper.h"

@interface HomeVC () <UITextFieldDelegate, FCAlertViewDelegate>

@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setBarTintColor:Navigation_Color];
    UIImageView *imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Header-Logo"]];
    [self.navigationItem setTitleView:imageview];
    
    _hospitalField.delegate = self;
    _doctorField.delegate = self;
    _serviceField.delegate = self;
    
    _serviceField.text = @"";
    _tagString = @"";
}

- (void)viewWillAppear:(BOOL)animated {
    
    _hospitalField.layer.cornerRadius = 4.0;
    _hospitalField.layer.borderColor = [UIColor colorWithRed:0.83 green:0.83 blue:0.83 alpha:0.5].CGColor;
    _hospitalField.layer.borderWidth = 1.0;
    
    _hospitalField.leftViewMode = UITextFieldViewModeAlways;
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 35)];
    [_hospitalField setLeftView:leftView];
    
    _doctorField.layer.cornerRadius = 4.0;
    _doctorField.layer.borderColor = [UIColor colorWithRed:0.83 green:0.83 blue:0.83 alpha:0.5].CGColor;
    _doctorField.layer.borderWidth = 1.0;
    
    _doctorField.leftViewMode = UITextFieldViewModeAlways;
    UIView *leftView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 35)];
    [_doctorField setLeftView:leftView1];
    
    _serviceField.layer.cornerRadius = 4.0;
    _serviceField.layer.borderColor = [UIColor colorWithRed:0.83 green:0.83 blue:0.83 alpha:0.5].CGColor;
    _serviceField.layer.borderWidth = 1.0;
    
    _serviceField.leftViewMode = UITextFieldViewModeAlways;
    UIView *leftView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 35)];
    [_serviceField setLeftView:leftView2];
    
    if (_selectedString.length > 0) {
        if ([_tagString isEqualToString:@"1"]) {
            _hospitalField.text = _selectedString;
        }
        if ([_tagString isEqualToString:@"2"]) {
            _doctorField.text = _selectedString;
            _serviceField.text = _serviceString;
        }
    }
    
    _submitButton.layer.cornerRadius = 4.0;
    [_submitButton setBackgroundColor:Submit_Button_Color];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [textField resignFirstResponder];
    
    UINavigationController *selNavVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"selectNav"];
//    SelectionVC *selVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"selectionView"];
//    selVC.tag = [NSString stringWithFormat:@"%ld", (long)textField.tag];
    
    SelectionVC *selVC = [[selNavVC viewControllers] firstObject];
    selVC.tag = [NSString stringWithFormat:@"%ld", (long)textField.tag];
    
    [self presentViewController:selNavVC animated:YES completion:nil];
    
    return NO;
}

//Submit data
- (void) submitData : (NSMutableDictionary *)paramDict {
    
    [SVProgressHUD showWithStatus:@"Submitting..."];
    NSString *strURL = @"http://www.wingsts.com/ts/curbside/ws/submitdata";
    
    AFJSONRequestSerializer *serializer = [AFJSONRequestSerializer serializer];
    [serializer setStringEncoding:NSUTF8StringEncoding];
    
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    responseSerializer.acceptableContentTypes= [NSSet setWithObjects:@"text/html",@"application/json", nil];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=serializer;
    manager.responseSerializer = responseSerializer;
    
    [manager POST:strURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [SVProgressHUD dismiss];
        
        NSLog(@"response - %@", responseObject);
        BOOL successString = [responseObject valueForKey:@"success"];
        
        if (successString == 1) {
            [SVProgressHUD dismiss];
            NSString *successMessageString = [NSString stringWithFormat:@"%@", [responseObject valueForKey:@"message"]];
            [self showErrorAlert:successMessageString];
        }
        if (successString == 0) {
            [SVProgressHUD dismiss];
            NSString *errorMessageString = [NSString stringWithFormat:@"%@", [responseObject valueForKey:@"message"]];
            [self showErrorAlert:errorMessageString];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
    }];
}

- (void) showErrorAlert : (NSString *)errorString{
    FCAlertView *alert = [[FCAlertView alloc] init];
    alert.colorScheme = Submit_Button_Color;
    alert.firstButtonBackgroundColor = [UIColor colorWithRed:0.00 green:0.50 blue:0.84 alpha:1.0];
    alert.firstButtonTitleColor = [UIColor whiteColor];
    alert.blurBackground = NO;
    alert.animateAlertInFromBottom = YES;
    alert.cornerRadius = 6;
    alert.delegate = self;
    alert.customSpacing = 40;
    alert.customHeight = 200;
    alert.animateAlertInFromBottom = YES;
    alert.animateAlertOutToBottom = YES;
    
    NSDictionary *attrib = @{
                             NSForegroundColorAttributeName: [UIColor blackColor],
                             NSFontAttributeName: [UIFont systemFontOfSize:20.0 weight:UIFontWeightRegular]
                             };
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:errorString attributes:attrib];
    
    [alert showAlertWithAttributedTitle:nil
                 withAttributedSubtitle:str
                        withCustomImage:nil
                    withDoneButtonTitle:@"OK"
                             andButtons:nil];
    
    [alert doneActionBlock:^{
        // Put your action here
        _hospitalField.text = @"";
        _doctorField.text = @"";
        _serviceField.text = @"";
    }];
}


#pragma mark - FCAlertViewDelegate Method

- (void)FCAlertDoneButtonClicked:(FCAlertView *)alertView {
    
    
}
- (void)FCAlertView:(FCAlertView *)alertView clickedButtonIndex:(NSInteger)index buttonTitle:(NSString *)title {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)submitForm:(id)sender {
    if (_hospitalField.text.length == 0 || _doctorField.text.length == 0) {
        [self showErrorAlert:@"All fields are mandatory."];
    }
    else {
        NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
        [paramDict setValue:_hospitalField.text forKey:@"location"];
        [paramDict setValue:_doctorField.text forKey:@"doctor"];
        [paramDict setValue:_serviceField.text forKey:@"service"];
        
        [self submitData:paramDict];
    }
}
@end
