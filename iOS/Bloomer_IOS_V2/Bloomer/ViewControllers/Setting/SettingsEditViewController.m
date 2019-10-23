//
//  SettingsEditViewController.m
//  Xinh
//
//  Created by Truong Thuan Tai on 12/10/14.
//  Copyright (c) 2014 Glassegg. All rights reserved.
//

#import "SettingsEditViewController.h"

@interface SettingsEditViewController ()
{
    NSArray *genderArray;
    NSIndexPath *selectedIndex;
    UserDefaultManager *userDefaultManager;
    NSString *name;
    NSString *date;
    NSInteger gender;
}
@end

@implementation SettingsEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background.png"]];
    
    [self hideAllView];
    
    switch (_viewType) {
        case 0:
            [self loadNameView];
            break;
        case 1:
            [self loadEmailView];
            break;
        case 3:
            [self loadDateView];
            break;
        case 4:
            [self loadGenderView];
            break;
        default:
            break;
    }
    
    userDefaultManager = [[UserDefaultManager alloc] init];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"DONE" style:UIBarButtonItemStylePlain target:self action:@selector(touchDoneButton)];
    doneButton.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = doneButton;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:TRUE];
    [userDefaultManager saveBackFromSettingsEditorState:TRUE];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return genderArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"GenderCell";
    GenderTableViewCell *cell = (GenderTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"GenderTableViewCell" bundle:nil] forCellReuseIdentifier:identifier];
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    }
    
    cell.title.text = [genderArray objectAtIndex:indexPath.row];
    
    if (indexPath.row == _profileData.gender)
    {
        [cell.check setHidden:FALSE];
        selectedIndex = indexPath;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GenderTableViewCell *previousSelectedCell = (GenderTableViewCell*)[tableView cellForRowAtIndexPath:selectedIndex];
    [previousSelectedCell.check setHidden:TRUE];
    
    GenderTableViewCell *cell = (GenderTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    [cell.check setHidden:FALSE];
    
    selectedIndex = indexPath;
    gender = indexPath.row;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)hideAllView
{
    [_nameView setHidden:TRUE];
    [_emailView setHidden:TRUE];
    [_dateView setHidden:TRUE];
    [_genderView setHidden:TRUE];
}

- (void)loadNameView
{
    [_nameView setHidden:FALSE];
    
    UILabel * titleView = [[UILabel alloc] initWithFrame:CGRectZero];
    titleView.backgroundColor = [UIColor clearColor];
    titleView.font = [UIFont systemFontOfSize:20.0];
    titleView.shadowColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    titleView.shadowOffset = CGSizeMake(0.0f, 1.0f);
    titleView.textColor = [UIColor whiteColor]; // Your color here
    titleView.text = @"Display Name";
    self.navigationItem.titleView = titleView;
    [titleView sizeToFit];
    
    _nameEditor.text = _profileData.name;
    [_nameEditor performSelector:@selector(selectAll:) withObject:_nameEditor afterDelay:0.f];
}

- (void)loadEmailView
{
    [_emailView setHidden:FALSE];
    
    UILabel * titleView = [[UILabel alloc] initWithFrame:CGRectZero];
    titleView.backgroundColor = [UIColor clearColor];
    titleView.font = [UIFont systemFontOfSize:20.0];
    titleView.shadowColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    titleView.shadowOffset = CGSizeMake(0.0f, 1.0f);
    titleView.textColor = [UIColor whiteColor]; // Your color here
    titleView.text = @"Email";
    self.navigationItem.titleView = titleView;
    [titleView sizeToFit];
    
    _emailEditor.text = _profileData.email;
}

- (void)loadDateView
{
    [_dateView setHidden:FALSE];
    
    UILabel * titleView = [[UILabel alloc] initWithFrame:CGRectZero];
    titleView.backgroundColor = [UIColor clearColor];
    titleView.font = [UIFont systemFontOfSize:20.0];
    titleView.shadowColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    titleView.shadowOffset = CGSizeMake(0.0f, 1.0f);
    titleView.textColor = [UIColor whiteColor]; // Your color here
    titleView.text = @"D.O.B";
    self.navigationItem.titleView = titleView;
    [titleView sizeToFit];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    _datePicker.date = [dateFormatter dateFromString:_profileData.birthday];
    date = [dateFormatter stringFromDate:_datePicker.date];
}

- (void)loadGenderView
{
    [_genderView setHidden:FALSE];
    genderArray = [NSArray arrayWithObjects:@"Female", @"Male", nil];
    
    UILabel * titleView = [[UILabel alloc] initWithFrame:CGRectZero];
    titleView.backgroundColor = [UIColor clearColor];
    titleView.font = [UIFont systemFontOfSize:20.0];
    titleView.shadowColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    titleView.shadowOffset = CGSizeMake(0.0f, 1.0f);
    titleView.textColor = [UIColor whiteColor]; // Your color here
    titleView.text = @"Gender";
    self.navigationItem.titleView = titleView;
    [titleView sizeToFit];
}

- (IBAction)emailEditingDidEnd:(id)sender {
    _profileData.email = _emailEditor.text;
}

- (IBAction)datePickerValueChanged:(id)sender {
    NSDate *chosenDate = _datePicker.date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    date = [dateFormatter stringFromDate:chosenDate];
}

- (void)touchDoneButton
{
    switch (_viewType) {
        case 0:
            _profileData.name = _nameEditor.text;
            break;
        case 1:
            [self loadEmailView];
            break;
        case 3:
            _profileData.birthday = date;
            break;
        case 4:
            _profileData.gender = gender;
            break;
        default:
            break;
    }
    
    [self.navigationController popViewControllerAnimated:TRUE];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
       shouldReceiveTouch:(UITouch *)touch {
    if ([[touch view] isKindOfClass:[UIButton class]]){
        [self.view endEditing:TRUE];
        return TRUE;
    }
    
    if (![[touch view] isKindOfClass:[UITextField class]])
    {
        [self.view endEditing:TRUE];
        return TRUE;
    }
        
    
    return TRUE;
}

@end
