//
//  SelectionVC.m
//  CurbSide
//
//  Created by WTS on 13/11/17.
//  Copyright © 2017 Kahan Rayjada. All rights reserved.
//

#import "SelectionVC.h"
#import "HomeVC.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "FCAlertView.h"
#import "HospitalLocation.h"
#import "DoctorDetail.h"
#import "Helper.h"

@interface SelectionVC () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, FCAlertViewDelegate> {
    NSArray *hospitalArr;
    NSArray *doctorArr;
    NSArray *serviceArr;
    BOOL isSearch;
    NSArray *responseArray;
    HospitalLocation *hospitalLoc;
    DoctorDetail *docDetail;
}

@property (nonatomic, strong) UIView *searchView;
@property (nonatomic, strong) UITextField *searchField;
@property (nonatomic, strong) UIButton *closeButton;

@end

@implementation SelectionVC

NSArray *searchArr;

- (UIView*)searchView {
    if (!_searchView) {
        _searchView = [[UIView alloc] initWithFrame: self.navigationController.navigationBar.frame];
        CGRect frame = _searchView.frame;
        frame.size.height = frame.size.height + 20;
        frame.origin.y = -64;
        _searchView.frame = frame;
        
        _searchView.backgroundColor = Navigation_Color;
        
        _searchField = [[UITextField alloc] initWithFrame:CGRectMake(10, 25, CGRectGetWidth(_searchView.frame) - 70, 30)];
        _searchField.delegate = self;
        if ([_tag isEqualToString:@"1"])
            _searchField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Search locations" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.64 green:0.64 blue:0.64 alpha:1.0], NSFontAttributeName : [UIFont systemFontOfSize:8.0]}];
        else
            _searchField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Search doctor" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.64 green:0.64 blue:0.64 alpha:1.0], NSFontAttributeName : [UIFont systemFontOfSize:8.0]}];
        
        _searchField.font = [UIFont systemFontOfSize:16];
        _searchField.textColor = [UIColor whiteColor];
        _searchField.backgroundColor = [UIColor whiteColor];
        
        _searchField.layer.cornerRadius = 4.0;
        _searchField.layer.borderColor = [UIColor colorWithRed:0.83 green:0.83 blue:0.83 alpha:0.5].CGColor;
        _searchField.layer.borderWidth = 1.0;
        
        _searchField.leftViewMode = UITextFieldViewModeAlways;
        UIImageView *leftView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 25, 25)];
        leftView.image = [UIImage imageNamed:@"Search-Gray"];
        leftView.contentMode = UIViewContentModeScaleAspectFit;
        [_searchField setLeftView:leftView];
        
        [_searchView addSubview:_searchField];
        
        _closeButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(_searchView.frame) - 40, 25, 30, 30)];
        [_closeButton setImage:[UIImage imageNamed:@"Close"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(closeSearch:) forControlEvents:UIControlEventTouchUpInside];
        [_closeButton setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
        _closeButton.tintColor = [UIColor whiteColor];
        [_searchView addSubview:_closeButton];
        
    }
    return _searchView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    isSearch = NO;
    
    [self.navigationController.navigationBar setBarTintColor:Navigation_Color];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    hospitalArr  =@[@"Sentara Obici", @"Norfolk General Hospital", @"Sentara Princess Anne", @"Sentara Virginia Beach", @"Sentara Belle Harbour", @"Sentara Independence", @"Sentara Leigh"];
    doctorArr = @[@"Aberkorn", @"Adair", @"Basil Skenderis", @"Danso"];
    serviceArr = @[@"Bayview Medical Group"];
    
    _selectTable.tableFooterView = [UIView new];
//    [self.view addSubview: [self searchView]];
    
    [self getAllRecords:_tag];
    
    if ([_tag isEqualToString:@"1"]) {
        _orLbl.hidden = YES;
        _otherSelectionField.hidden = YES;
        _doneButton.hidden = YES;
        _specifyNameLbl.hidden = YES;
        _noteLbl.hidden = YES;
        _tableHeaderLbl.hidden = YES;
        _lineView.hidden = YES;
        self.title = @"LOCATIONS";
        _tableTop.constant = -145;
    }
    else {
        _orLbl.hidden = NO;
        _otherSelectionField.hidden = NO;
        _doneButton.hidden = NO;
        _specifyNameLbl.hidden = NO;
        _noteLbl.hidden = NO;
        _tableHeaderLbl.hidden = NO;
        _lineView.hidden = NO;
        self.title = @"PRIMARY CARE DOCTORS";
        _tableTop.constant = 0;
    }
    
    NSLog(@"tag - %@", _tag);
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _otherSelectionField.delegate = self;
    _otherSelectionField.layer.cornerRadius = 4.0;
    _otherSelectionField.layer.borderColor = [UIColor colorWithRed:0.83 green:0.83 blue:0.83 alpha:0.5].CGColor;
    _otherSelectionField.layer.borderWidth = 1.0;
    
    _otherSelectionField.leftViewMode = UITextFieldViewModeAlways;
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 35)];
    [_otherSelectionField setLeftView:leftView];
    
    _searchField.autocorrectionType = NO;
    _otherSelectionField.autocorrectionType = NO;
    
    [_doneButton setBackgroundColor:Submit_Button_Color];
}

//Get All values for doctor/hospitals
- (void) getAllRecords : (NSString *)tag {
    
    [SVProgressHUD showWithStatus:@"Fetching List..."];
    NSString *strURL;
    if ([tag isEqualToString:@"1"])
        strURL = @"http://www.wingsts.com/ts/curbside/ws/locations/all";
    if ([tag isEqualToString:@"2"])
        strURL = @"http://www.wingsts.com/ts/curbside/ws/doctors/all";
    
    AFJSONRequestSerializer *serializer = [AFJSONRequestSerializer serializer];
    [serializer setStringEncoding:NSUTF8StringEncoding];
    
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    responseSerializer.acceptableContentTypes= [NSSet setWithObjects:@"text/html",@"application/json", nil];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=serializer;
    manager.responseSerializer = responseSerializer;
    
    [manager GET:strURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [SVProgressHUD dismiss];
        
        NSLog(@"response - %@", responseObject);
        BOOL successString = [responseObject valueForKey:@"success"];
        
        if (successString == 1) {
            [SVProgressHUD dismiss];
            responseArray = [responseObject valueForKey:@"locations"];
            [_selectTable reloadData];
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

#pragma mark - UITextField Delegate methods
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == _searchField)
        isSearch = YES;
    return  YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == _searchField) {
        isSearch = YES;
        self.searchField.rightView.hidden = NO;
        NSString * proposedNewString = [textField.text stringByAppendingString:string];
        isSearch = YES;
        if (isSearch && string.length > 0) {
            NSPredicate *resultPredicate;
            
            if ([_tag isEqualToString:@"1"]) {
                NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"locations contains[c] %@", proposedNewString];
                searchArr = [responseArray filteredArrayUsingPredicate:resultPredicate];
            }
            else if ([_tag isEqualToString:@"2"]) {
                NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"doctor_name contains[c] %@", proposedNewString];
                searchArr = [responseArray filteredArrayUsingPredicate:resultPredicate];
            }
            
            [_selectTable reloadData];
        }
        else if ([string isEqualToString:@""]) {
            isSearch = NO;
            [_selectTable reloadData];
        }
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}

- (void)textFieldChanged:(UITextField *)textField
{
    if (textField == _searchField) {
        if (textField.text.length == 0) {
            isSearch = NO;
            [_selectTable reloadData];
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _searchField) {
        isSearch = NO;
        [_selectTable reloadData];
    }
    
    return YES;
}

#pragma mark - UITableView Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([_tag isEqualToString:@"1"]) {
        if (!isSearch)
            return responseArray.count;
        else
            return searchArr.count;
    }
    else {
        if (!isSearch)
            return responseArray.count;
        else
            return searchArr.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"selectCell" forIndexPath:indexPath];
    
    if (!isSearch) {
        UILabel *nameLbl = (UILabel *)[cell viewWithTag:1];
        UIImageView *hospitalImg = (UIImageView *)[cell viewWithTag:2];
        
        if ([_tag isEqualToString:@"1"]) {
            hospitalLoc = [[HospitalLocation alloc] initWithDictionary:[responseArray objectAtIndex:indexPath.row]];
            nameLbl.text = hospitalLoc.locations;
            hospitalImg.image = [UIImage imageNamed:@"Hospital"];
            return cell;
        }
        else {
            docDetail = [[DoctorDetail alloc] initWithDictionary:[responseArray objectAtIndex:indexPath.row]];
            nameLbl.text = docDetail.doctorName;
            hospitalImg.image = [UIImage imageNamed:@"Doctor"];
            return cell;
        }
    }
    else {
        UILabel *nameLbl = (UILabel *)[cell viewWithTag:1];
        if ([_tag isEqualToString:@"1"]) {
            NSString *locations = [[HospitalLocation alloc] initWithDictionary:[searchArr objectAtIndex:indexPath.row]].locations;
            nameLbl.text = locations;
            return cell;
        }
        else {
            NSString *docName = [[DoctorDetail alloc] initWithDictionary:[searchArr objectAtIndex:indexPath.row]].doctorName;
            nameLbl.text = docName;
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UINavigationController *nav = (UINavigationController *)self.presentingViewController;
    HomeVC *homeVC = [[nav viewControllers] firstObject];
    
    if (!isSearch) {
        if ([_tag isEqualToString:@"1"]) {
            hospitalLoc = [[HospitalLocation alloc] initWithDictionary:[responseArray objectAtIndex:indexPath.row]];
            homeVC.selectedString = hospitalLoc.locations;
            homeVC.tagString = @"1";
        }
        else if ([_tag isEqualToString:@"2"]) {
            docDetail = [[DoctorDetail alloc] initWithDictionary:[responseArray objectAtIndex:indexPath.row]];
            homeVC.selectedString = docDetail.doctorName;
            homeVC.tagString = @"2";
            homeVC.serviceString = docDetail.admittingService;
        }
        else {
            homeVC.selectedString = [NSString stringWithFormat:@"%@", [serviceArr objectAtIndex:indexPath.row]];
            homeVC.tagString = @"3";
        }
    }
    else {
        if ([_tag isEqualToString:@"1"]) {
            hospitalLoc = [[HospitalLocation alloc] initWithDictionary:[responseArray objectAtIndex:indexPath.row]];
            homeVC.selectedString = hospitalLoc.locations;
            homeVC.tagString = @"1";
        }
        else if ([_tag isEqualToString:@"2"]) {
            docDetail = [[DoctorDetail alloc] initWithDictionary:[responseArray objectAtIndex:indexPath.row]];
            homeVC.selectedString = docDetail.doctorName;
            homeVC.tagString = @"2";
            homeVC.serviceString = docDetail.admittingService;
        }
        else {
            homeVC.selectedString = [NSString stringWithFormat:@"%@", [searchArr objectAtIndex:indexPath.row]];
            homeVC.tagString = @"3";
        }
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
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

- (IBAction)backToHome:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)searchSelection:(id)sender {
//     self.navigationController.navigationBar.hidden = YES;
    [[UIApplication sharedApplication].keyWindow addSubview:[self searchView]];
    [UIView animateWithDuration:0.6f delay:0.0f options:UIViewAnimationOptionTransitionNone animations:^{
        _searchView.frame = CGRectMake(_searchView.frame.origin.x, 0, _searchView.frame.size.width, 64);
    } completion:^(BOOL finished) {
        
     }];
}

- (void)closeSearch : (UIButton *)sender {
    __weak typeof (self) weakSelf = self;
    [UIView animateWithDuration:0.6f delay:0.0f options:UIViewAnimationOptionTransitionNone animations:^{
        _searchView.frame = CGRectMake(_searchView.frame.origin.x, -64, _searchView.frame.size.width,  64);
    } completion:^(BOOL finished) {
        [[weakSelf searchView] removeFromSuperview];
//         _searchView.hidden = YES;
//         self.navigationController.navigationBar.hidden = NO;
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
        if ([errorString isEqualToString:@"Profile Updated Successfully!"]) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}


#pragma mark - FCAlertViewDelegate Method

- (void)FCAlertDoneButtonClicked:(FCAlertView *)alertView {
    
    
}
- (void)FCAlertView:(FCAlertView *)alertView clickedButtonIndex:(NSInteger)index buttonTitle:(NSString *)title {
    
}

- (IBAction)doneSelection:(id)sender {
    if (_otherSelectionField.text.length == 0) {
        [self showErrorAlert:@"Please enter name in field or select one from list."];
    }
    else {
        
        UINavigationController *nav = (UINavigationController *)self.presentingViewController;
        HomeVC *homeVC = [[nav viewControllers] firstObject];
        
        if ([_tag isEqualToString:@"1"]) {
            homeVC.selectedString = _otherSelectionField.text;
            homeVC.tagString = @"1";
        }
        else if ([_tag isEqualToString:@"2"]) {
            homeVC.selectedString = _otherSelectionField.text;
            homeVC.tagString = @"2";
            homeVC.serviceString = @"";
            
            for (int i = 0; i < responseArray.count; i++) {
                if ([_otherSelectionField.text isEqualToString:[[DoctorDetail alloc] initWithDictionary:[responseArray objectAtIndex:i]].doctorName]) {
                    homeVC.serviceString = [[DoctorDetail alloc] initWithDictionary:[responseArray objectAtIndex:i]].admittingService;
                }
            }
            if (homeVC.serviceString.length == 0)
                homeVC.serviceString = @"Sentara Medical Group";
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
@end
