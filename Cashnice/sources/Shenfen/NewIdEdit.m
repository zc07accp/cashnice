//
//  NewBorrowViewController.m
//  YQS
//
//  Created by l on 3/17/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "NewIdEdit.h"
#import "EditIntro.h"

#import "FabuJiekuanTableViewCell.h"
#import "FabuStep2.h"
#import "EditProvince.h"
#import "NonRotateImgPicker.h"
#import "GeRenTableViewCell.h"
#import "ValidcodeCell.h"

@interface NewIdEdit () {
    BOOL          mSelectImage;
    BOOL          mUploadSuc;
    NSDictionary *uploadDict;
    
    NSString *savedPhone;
    BOOL alreadySent;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *const_id_image_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *const_table_height;
@property (strong, nonatomic) NSArray *                   nameArray;
@property (strong, nonatomic) NSArray *                   imageArray;
@property (strong, nonatomic) IBOutlet UITableView *      table;
@property (strong, nonatomic) IBOutlet UIImageView *      img;
@property (strong, nonatomic) IBOutlet UIView *           imgBorder;
@property (weak, nonatomic) UITextField *                 tf0;
@property (weak, nonatomic) UITextField *                 tf1;
@property (weak, nonatomic) UITextField *                 tf2;
@property (weak, nonatomic) UITextField *                 tf3;
@property (strong, nonatomic) UIImagePickerController *   mypicker;

@property (strong, nonatomic) NextButtonViewController *        next;
@property (strong, nonatomic) MKNetworkOperation *              op;

@property (strong, nonatomic) UIButton *                validateButton;
@property (strong, nonatomic) UILabel *                 validateLabel;

@end

@implementation NewIdEdit

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor         = ZCOLOR(COLOR_BG_GRAY);
    self.table.allowsSelection        = NO;
    self.imgBorder.layer.cornerRadius = [Util getCornerRadiusSmall];
    
    self.const_id_image_height.constant = 0;
    self.imgBorder.hidden = YES;
    
    self.authUserType = [ZAPP.myuser getUserLevel]>=UserLevel_Normal; //[ZAPP.myuser hasIdCardByUserLevel];
    
    self.const_table_height.constant = [ZAPP.zdevice getDesignScale:self.authUserType ? 172 : 200];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

BLOCK_NAV_BACK_BUTTON

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setNavButton];
    [MobClick beginLogPageView:@"身份证"];
    
    if (self.authUserType) {
        self.title = @"查看身份信息";
    }
    else {
        self.title = @"表明身份";
    }
    
    
    [self hide];
    [self tapBackground];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self hide];
    
    [self didChanged:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [MobClick endLogPageView:@"身份证"];
    [self hide];
}

-(void)tapBackground
{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    [tap setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:tap];
}
- (void)sendPressed {
    
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue destinationViewController] isKindOfClass:[NextButtonViewController class]]) {
        ((NextButtonViewController *)[segue destinationViewController]).delegate    = self;
        ((NextButtonViewController *)[segue destinationViewController]).titleString = @"提交审核";
        self.next                                                                   =        ((NextButtonViewController *)[segue destinationViewController]);
    }
}



- (void)uploadIdCardPressed {
    [self selectImageButtonPressed];
}

- (void)selectImageButtonPressed {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CNLocalizedString(@"alert.title.newIdEdit", nil) message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"从相机拍照", @"从照片选择", nil];
    alert.tag = 10;
    [alert show];
}

- (void)selectFromCamera {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self.navigationController presentViewController:picker animated:YES completion:^{[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];}];
}

- (void)selectFromPhoto {
    [self.navigationController presentViewController:self.mypicker animated:YES completion:^{[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];}];
}

- (void)pickerDismissed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)pickerSetImage:(UIImage *)img {
    self.img.image = img;
    self.const_id_image_height.constant = [ZAPP.zdevice getDesignScale:270];
    self.imgBorder.hidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setData:(NSDictionary *)imgServerDict {
    mUploadSuc = YES;
    uploadDict = imgServerDict;
    [self connectToCommit];
}

- (void)loseData {
}

- (void)connectToUpload {
    [self.op cancel];
    bugeili_net
    mUploadSuc = NO;
    progress_show
    self.op = [ZAPP.netEngine uploadImageFromFile:@"idcard.jpg" image:self.img.image completionHandler:^(NSDictionary* s){[self setData:s]; progress_hide} errorHandler:^{[self loseData]; progress_hide}];
}

- (void)setCommitData {
    BOOL res = YES;
    if (res) {
        [Util toastStringOfLocalizedKey:@"tip.submittedForReview"];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)connectToCommit {
    [self.op cancel];
    bugeili_net
    //[self setCommitData];
    progress_show
    self.op = [ZAPP.netEngine commitIdcardWithComplete:^{[self setCommitData]; progress_hide} error:^{[self loseData]; progress_hide}  realname:self.tf0.text idnumber:self.tf1.text attach:uploadDict];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != [alertView cancelButtonIndex]) {
        if (alertView.tag == 10) {
            if (buttonIndex == 1) {
                [self selectFromCamera];
            }
            else if (buttonIndex == 2) {
                [self selectFromPhoto];
            }
            
        }
        else {
            //NSString *uuid = [ZAPP.myuser.sendValidateCodeRespondDict objectForKey:NET_KEY_VALIDATEUUID];
            //[self connectToCommitPhoneAndCode:uuid code:savedPhone];
            [self connectToUpload];
        }
    }
}

- (void)nextButtonPressed {
    
    [self hide];
    if (! [self.tf0.text notEmpty]) {
        [Util toastStringOfLocalizedKey:@"tip.form.realname"];
        return;
    }
    if (! [self.tf1.text notEmpty]) {
        [Util toastStringOfLocalizedKey:@"tip.form.idcardNumber"];
        return;
    }
    if (! mSelectImage) {
        [Util toastStringOfLocalizedKey:@"tip.form.idcardPicture"];
        return;
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CNLocalizedString(@"alert.title.newIdEdit.next", nil) message:nil delegate:self cancelButtonTitle:@"返回修改" otherButtonTitles:@"提交审核", nil];
    [alert show];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (section == 0 ? 1 : 2); //(self.authUserType ? 1 : 0 )
}
- (BOOL)lastRow:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return YES;
    }
    else {
        return (indexPath.row == 1);
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [ZAPP.zdevice getDesignScale:44];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [ZAPP.zdevice getDesignScale:20];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *v = [UIView new];
    v.userInteractionEnabled = NO;
    v.backgroundColor        = [UIColor clearColor];
    return v;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *v = [UIView new];
    v.userInteractionEnabled = NO;
    v.backgroundColor        = [UIColor clearColor];
    return v;
}

- (NSArray *)imageArray {
    if (_imageArray == nil) {
        _imageArray =@[@"user", @"degree"];
    }
    return _imageArray;
}
- (NSArray *)nameArray {
    if (_nameArray == nil) {
        _nameArray = @[@"请输入真实姓名", @"请输入身份证号"];
    }
    return _nameArray;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        GeRenTableViewCell *cell;
        static NSString *CellIdentifier2 = @"cell2";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
        
        NSString *str1 = [ZAPP.myuser limitLoanAmountForNormalUser];
        
        NSString *tt = [NSString stringWithFormat:@"认证成功: 获得授信额度%@，借款额度%@", str1, str1];
        cell.biaoti.text = tt;
        cell.detail.text = @"";
        cell.arrow.hidden = YES;
        cell.sepLine.hidden = YES;
        
        return cell;
    }
    else {
        if (indexPath.row == 0) {
            FabuJiekuanTableViewCell *cell;
            static NSString *         CellIdentifier = @"cell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            cell.txtImg.hidden   = NO;
            cell.moneyImg.hidden = YES;
            [cell.tf setEnabled:YES];
            
            cell.sepLine.hidden = [self lastRow:indexPath];
            cell.tf.placeholder = [self.nameArray objectAtIndex:indexPath.row];
            cell.tf.delegate    = self;
            
            cell.txtImg.image    = [UIImage imageNamed:[self.imageArray objectAtIndex:indexPath.row]];
            cell.detail.text     = @"";
            cell.tf.keyboardType = UIKeyboardTypeDefault;
            self.tf0     = cell.tf;
            cell.tf.clearButtonMode = UITextFieldViewModeWhileEditing;
            if (self.authUserType) {
                cell.tf.userInteractionEnabled = NO;
                cell.tf.text = [ZAPP.myuser getUserRealName];
            }
            else {
                cell.tf.userInteractionEnabled = YES;
                if ([ZAPP.myuser hasIdCardInUserInfo]) {
                    cell.tf.text = [ZAPP.myuser getUserRealName];
                }
            }
            [self didChanged:nil];
            cell.contentView.clipsToBounds = YES;
            return cell;
        }
        else {
            ValidcodeCell *cell;
            cell = [tableView dequeueReusableCellWithIdentifier:@"cell3"];
            cell.contentView.clipsToBounds = YES;
            
            [cell.tf setEnabled:YES];
            
            cell.sepLine.hidden = [self lastRow:indexPath];
            cell.tf.placeholder = [self.nameArray objectAtIndex:indexPath.row];
            cell.tf.delegate    = self;
            
            cell.txtImg.image       = [UIImage imageNamed:[self.imageArray objectAtIndex:indexPath.row]];
            cell.tf.keyboardType    = UIKeyboardTypeDefault;
            cell.tf.clearButtonMode = UITextFieldViewModeWhileEditing;
            cell.delegate           = self;
            
            self.tf1             = cell.tf;
            
            
            cell.validButton.tag = 100;
            [cell setUploadImageStyle];
            
            
            [self didChanged:nil];
            
            if (self.authUserType) {
                cell.tf.text = [ZAPP.myuser getIdCard];
                cell.tf.userInteractionEnabled = NO;
                cell.buttonView.hidden = YES;
            }
            else {
                cell.tf.userInteractionEnabled = YES;
                cell.buttonView.hidden = NO;
                if ([ZAPP.myuser hasIdCardInUserInfo]) {
                    cell.tf.text = [ZAPP.myuser getIdCard];
                }
            }
            
            return cell;
        }
    }
}

- (IBAction)dismissKeyboard:(id)sender {
    [self hide];
}

- (void)hide {
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


- (UIImagePickerController *)mypicker {
    if (_mypicker == nil) {
        _mypicker           = [[NonRotateImgPicker alloc] init];
        _mypicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        _mypicker.delegate  = self;
    }
    return _mypicker;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    //ZCLICK
    
    UIImage *ximage = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (ximage && ximage.size.width > 0 && ximage.size.height>0 ) {
        //        NSString *xstr = [self getPictureName];
        //        [self.app.settingManager addImgForCustomBg:xstr withImage:ximage];
        //        [self.app.settingManager setBgColorIndex:-1];
        //        [self.app dispatchMessage:MESSAGE_BG_COLOR_CHANGED];
        //[Util toast:@"picked"];
        //[self.delegate pickerSetImage:ximage];
        //		[self dismissViewControllerAnimated:NO completion:^{[self loadCropEditor:ximage]; }];
        
        self.img.image = ximage;
        self.const_id_image_height.constant = [ZAPP.zdevice getDesignScale:270];
        self.imgBorder.hidden = NO;
        mSelectImage = YES;
        [self didChanged:nil];
        
        [[UIApplication sharedApplication]
         setStatusBarStyle:UIStatusBarStyleLightContent];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        [[UIApplication sharedApplication]
         setStatusBarStyle:UIStatusBarStyleLightContent];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [[UIApplication sharedApplication]
     setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    //[Util toast:@"canceled"];
}

- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage {
    [[UIApplication sharedApplication]
     setStatusBarStyle:UIStatusBarStyleLightContent];
    
    if (croppedImage != nil) {
        self.img.image = croppedImage;
        
    }
    //[self.navigationController setNavigationBarHidden:YES];
    [self.navigationController popViewControllerAnimated:YES];
    
    mSelectImage = YES;
    [self didChanged:nil];
    //mUploadSuc = NO;
    //[self didChanged:nil];
}
- (void)cropViewControllerDidCancel:(PECropViewController *)controller {
    [[UIApplication sharedApplication]
     setStatusBarStyle:UIStatusBarStyleLightContent];
    //[self.navigationController setNavigationBarHidden:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadCropEditor:(UIImage *)theImage {
    PECropViewController *controller = [[PECropViewController alloc] init];
    controller.delegate               = self;
    controller.image                  = theImage;
    controller.keepingCropAspectRatio = YES;
    controller.toolbarHidden          = YES;
    controller.cropAspectRatio        = 679/471.0;
    controller.rotationEnabled        = NO;
    
    //	[self.navigationController setNavigationBarHidden:NO];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)didChanged:(id)sender {
    if (self.authUserType) {
        self.next.view.hidden = YES;
    }
    else {
        self.next.view.hidden = NO;
    }
    //[self.next setTheEnabled:[self.tf0.text notEmpty] && [self.tf1.text notEmpty] && mSelectImage];
}
@end
