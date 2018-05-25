//
//  NewBorrowViewController.m
//  YQS
//
//  Created by l on 3/17/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "FabuStep4.h"
 
#import "AttachmentTableViewCell.h"
#import "SZTextView.h"
#import "JiekuanPreview.h"
#import "NonRotateImgPicker.h"

@interface FabuStep4 () {
    int rowHeight;
    int rowCnt;
}

@property (strong, nonatomic)IBOutletCollection(UILabel) NSArray *labels;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *con_tableH;
@property (weak, nonatomic) IBOutlet UITableView *table;

@property (strong, nonatomic) MKNetworkOperation *op;
@property (strong, nonatomic) UIImagePickerController *mypicker;
@property (strong, nonatomic) NextButtonViewController *next;

@end

@implementation FabuStep4

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.

    rowHeight = TABLE_TEXT_ROW_HEIGHT;
    rowCnt = 0;
    
    self.table.delegate = self;
    self.con_tableH.constant = [ZAPP.zdevice getDesignScale:rowCnt * rowHeight];
    self.table.allowsSelection = NO;
    
	self.view.backgroundColor = ZCOLOR(COLOR_BG_GRAY);

	for (UILabel *x in self.labels) {
		x.textColor = ZCOLOR(COLOR_TEXT_GRAY);
		x.font      = [UtilFont systemLarge];
	}
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

BLOCK_NAV_BACK_BUTTON

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
[self setNavButton];
    [MobClick beginLogPageView:@"发布借款(4/4)"];
	[self setTitle:@"发布借款(4/4)"];
	
    [self.next setTheBlue];
    
    rowCnt = (int)[[ZAPP.myuser fabuFujianArray] count];
    [self ui];
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	// Get the new view controller using [segue destinationViewController].
	// Pass the selected object to the new view controller.

	if ([[segue destinationViewController] isKindOfClass:[NextButtonViewController class]]) {
		self.next = (NextButtonViewController *)[segue destinationViewController];
		((NextButtonViewController *)[segue destinationViewController]).delegate = self;
		((NextButtonViewController *)[segue destinationViewController]).titleString = @"预览";
	}
	else if ([[segue destinationViewController] isKindOfClass:[StrokeButtonViewController class]]) {
		((StrokeButtonViewController *)[segue destinationViewController]).delegate = self;
       ((StrokeButtonViewController *)[segue destinationViewController]).titleString = @"上传附件";
	}
}



- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [MobClick endLogPageView:@"发布借款(4/4)"];
    [self.op cancel];
    self.op = nil;
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
    }
}


- (void)nextButtonPressed {
    [self blueButtonPressed];
}

- (void)strokeButtonPressed {
    if (rowCnt >= 9) {
        [Util toast:@"最多上传9张图片"];
        return;
    }

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"上传附件" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"从相机拍照", @"从照片选择", nil];
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

- (void)blueButtonPressed {
    JiekuanPreview *x = ZJKDetail(@"JiekuanPreview");
    
    [self.navigationController pushViewController:x animated:YES];
}

- (void)setData:(NSDictionary *)s {
    [ZAPP.myuser fabuAddFujian:s];
    rowCnt = (int)[[ZAPP.myuser fabuFujianArray] count];
    [self ui];
}

- (void)ui {
    self.con_tableH.constant = [ZAPP.zdevice getDesignScale:rowCnt * rowHeight];
    [self.table reloadData];
    
}
- (void)loseData {
}

- (void)connectTo:(NSString *)name withImage:(UIImage *)image {
    [self.op cancel];
    bugeili_net
    
    progress_show
    
    __weak __typeof__(self) weakSelf = self;

    self.op = [ZAPP.netEngine uploadImageFromFile:name image:image completionHandler:^(NSDictionary *s){[weakSelf setData:s];progress_hide} errorHandler:^{[weakSelf loseData];progress_hide}
               ];
}

- (UIImagePickerController *)mypicker {
    if (_mypicker == nil) {
        _mypicker = [[NonRotateImgPicker alloc] init];
        _mypicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        _mypicker.delegate = self;
    }
    return _mypicker;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    //ZCLICK
    
    UIImage *ximage = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSString *string = [info objectForKey:UIImagePickerControllerMediaURL];
    [UtilLog string:string];
    string = @"attachment.jpg";
    
    NSData *imgdata = UIImageJPEGRepresentation(ximage, 0);
    CGFloat xle = imgdata.length;
    if (xle > 4 * 1024 * 1024) {
        [Util toast:@"不能上传超过4M的图片"];
        [[UIApplication sharedApplication]
         setStatusBarStyle:UIStatusBarStyleLightContent];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    if (ximage && ximage.size.width > 0 && ximage.size.height>0 ) {
        //        NSString *xstr = [self getPictureName];
        //        [self.app.settingManager addImgForCustomBg:xstr withImage:ximage];
        //        [self.app.settingManager setBgColorIndex:-1];
        //        [self.app dispatchMessage:MESSAGE_BG_COLOR_CHANGED];
        //[Util toast:@"picked"];
        //[self.delegate pickerSetImage:ximage];
        [self dismissViewControllerAnimated:YES completion:^{
            
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
            [self connectTo:string withImage:ximage];}];
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
    
 
    //[self.navigationController setNavigationBarHidden:YES];
    [self.navigationController popViewControllerAnimated:YES];
    

}
- (void)cropViewControllerDidCancel:(PECropViewController *)controller {
    [[UIApplication sharedApplication]
     setStatusBarStyle:UIStatusBarStyleLightContent];
    //[self.navigationController setNavigationBarHidden:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadCropEditor:(UIImage *)theImage{
    PECropViewController *controller = [[PECropViewController alloc] init];
    controller.delegate = self;
    controller.image = theImage;
    controller.keepingCropAspectRatio = YES;
    controller.toolbarHidden = YES;
    controller.cropAspectRatio = 390/290.0;
    controller.rotationEnabled = NO;
    
//    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController pushViewController:controller animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return rowCnt;
}
- (BOOL)lastRow:(NSInteger)row {
    return row == rowCnt - 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [ZAPP.zdevice getDesignScale:rowHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *v = [UIView new];
    v.userInteractionEnabled = NO;
    v.backgroundColor = [UIColor clearColor];
    return v;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *v = [UIView new];
    v.userInteractionEnabled = NO;
    v.backgroundColor = [UIColor clearColor];
    return v;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AttachmentTableViewCell *cell;
    static NSString *CellIdentifier = @"cell";
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSArray *arr = [ZAPP.myuser fabuFujianArray];
    NSDictionary *dict = [arr objectAtIndex:indexPath.row];
    
    NSString *str = [dict objectForKey:NET_KEY_NAME];
    if ([str notEmpty]) {
        
    }
    else {
        str = [dict objectForKey:NET_KEY_ORGFILENAME];
    }
    cell.biaoti.text = str;
    cell.size.text = @"";
    int sz = [[dict objectForKey:@"size"] intValue];
    cell.detail.text = [NSString stringWithFormat:@"%dK", (int)roundf(sz/1024.f)];
    cell.deleteButton.tag = indexPath.row;
    cell.sepLine.hidden = [self lastRow:indexPath.row];
    cell.delegate = self;
    
    return cell;
}

- (void)delePressed:(int)idx {
    [ZAPP.myuser fabuDelete:idx];
    rowCnt = (int)[[ZAPP.myuser fabuFujianArray] count];
    [self ui];
}
@end
