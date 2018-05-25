//
//  YQS
//
//  Created by l on 3/18/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "PersonInfo.h"
#import "PortraitViewController.h"
#import "GeRenViewController.h"

@interface PersonInfo () {
	UserLevelType _userType;
	BOOL     _notMe;
}

@property (weak, nonatomic) IBOutlet UILabel *usertype1;
@property (weak, nonatomic) IBOutlet UILabel * infoName;
@property (weak, nonatomic) IBOutlet UILabel * infoCompany;
@property (weak, nonatomic) IBOutlet UILabel * infoJob;
@property (weak, nonatomic) IBOutlet UILabel * infoPlace;
@property (weak, nonatomic) IBOutlet UILabel * infoTime;
@property (weak, nonatomic) IBOutlet UILabel * infoFriend;
@property (strong, nonatomic) NSArray *        infoArray;
@property (strong, nonatomic) PortraitViewController *portrait;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint* con_content_width;

@property (nonatomic, strong) UILabel *vLabel;

@property (strong, nonatomic) NSDictionary *infoDict;
@property (weak, nonatomic) IBOutlet UIView *pictureView;

@end

@implementation PersonInfo

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.con_content_width.constant = [ZAPP.zdevice getDesignScale:390];

	[self load];
    [self.pictureView addSubview:self.vLabel];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	_userType = UserLevel_Unauthed;
	[self ui];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

/*
   #pragma mark - Navigation

   // In a storyboard-based application, you will often want to do a little preparation before navigation
   - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
   }
 */

- (NSArray *)infoArray {
	if (_infoArray == nil) {
		_infoArray = @[self.infoName, self.infoCompany, self.infoJob, self.infoPlace, self.infoTime, self.infoFriend];
	}
	return _infoArray;
}

- (void)load {
	[self loadUserInfo];
}

- (void)viewDidLayoutSubviews{
    self.vLabel.bottom = self.pictureView.bottom;
    self.vLabel.right = self.pictureView.right;
}
- (void)ui {
	[self updateUserType];
	[self updateUserInfo];
}

- (void)loadUserInfo {
	for (UILabel *lb in self.infoArray) {
		lb.text      = @"";
		lb.textColor = ZCOLOR(COLOR_TEXT_GRAY);
		lb.font      = [UtilFont systemLarge];
	}
	self.infoTime.textColor = ZCOLOR(COLOR_TEXT_LIGHT_GRAY);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue destinationViewController] isKindOfClass:[PortraitViewController class]]) {
        self.portrait  = ((PortraitViewController*)[segue destinationViewController]);
    }
}

//- (IBAction)editButtonAction:(id)sender {
//    GeRenViewController *vc = (GeRenViewController *)self.parentViewController;
//    if ([vc respondsToSelector:@selector(editUserProfile)]) {
//        [vc editUserProfile];
//    }
//}

- (void)updateUserInfo {
    self.infoName.text = [Util getUserRealNameOrNickName:self.infoDict];
        NSString *gongsitext =  [self.infoDict objectForKey:NET_KEY_ORGANIZATIONNAME];//@"xxx公司";
        if ([gongsitext notEmpty]) {
            gongsitext = [NSString stringWithFormat:@"%@ ", gongsitext];
        }
        else {
            gongsitext = @"";
        }
        self.infoCompany.text = gongsitext;
        self.infoJob.text     = [self.infoDict objectForKey:NET_KEY_ORGANIZATIONDUTY];//@"xxx职务";
        
        NSString *province = [self.infoDict objectForKey:NET_KEY_provincename];
        NSString *city = [self.infoDict objectForKey:NET_KEY_cityname];
        
        NSString *juzhu = @"";
        if (!ISNSNULL(province) && !ISNSNULL(city) && [province notEmpty] && [city notEmpty]) {
            juzhu = [NSString stringWithFormat:@"%@ %@ ", province, city];
        }
        else {
            juzhu = @"";
        }
        self.infoPlace.text   = juzhu;//北京 朝阳";
            [self.portrait setImageUrl:[self.infoDict objectForKey:NET_KEY_HEADIMG]];
        NSString *str = [Util shortDateFromFullFormat:[self.infoDict objectForKey:NET_KEY_CREATETIME]];
        self.infoTime.text = [NSString stringWithFormat:@"%@加入", str];//@"2014-09-11加入";

        int thetype = [[self.infoDict objectForKey:NET_KEY_USERLEVEL] intValue];
        _userType = thetype;
        [self updateUserType];
        
        int numFriend = [[self.infoDict objectForKey:NET_KEY_CREDITEACHOTHERCOUNT] intValue] + [[self.infoDict objectForKey:NET_KEY_CREDITMECOUNT] intValue];
        CGFloat creditVal = [[self.infoDict objectForKey:NET_KEY_CREDITLIMIT] doubleValue];
        int val = (int)(creditVal / 1e4);
        self.infoFriend.text = [NSString stringWithFormat:@"好友:%d人  信用额度:%d万", numFriend, val];
    
    if (thetype == UserLevel_VIP) {
        self.vLabel.hidden = NO;
    }else{
        self.vLabel.hidden = YES;
    }
    [self.view setNeedsLayout];
}

- (void)updateUserType {
	self.usertype1.backgroundColor = _userType == UserLevel_Unauthed ? ZCOLOR(COLOR_TEXT_LIGHT_GRAY) : ZCOLOR(COLOR_BILL_BG_YELLOW);
	NSString *userstring = [UtilString getUserType:_userType];
	userstring          = _userType == UserLevel_Unauthed ? userstring :[NSString stringWithFormat:@"V%@", userstring];
	self.usertype1.text = [NSString stringWithFormat:@" %@ ", userstring];
}

- (void)setTheInfoDict:(NSDictionary *)dict {
	self.infoDict = dict;
	[self updateUserInfo];
}

- (void)setIsNotMe:(BOOL)notme {
    _notMe = notme;
}

- (UILabel *)vLabel{
    if (! _vLabel) {
        CGFloat vLableWidth = [ZAPP.zdevice getDesignScale:22];
        _vLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, vLableWidth, vLableWidth)];
        _vLabel.layer.cornerRadius = vLableWidth/2;
        _vLabel.layer.masksToBounds = YES;
        _vLabel.backgroundColor = ZCOLOR(COLOR_BILL_BG_YELLOW);
        _vLabel.font = [UtilFont systemLargeNormal];
        _vLabel.textColor = [UIColor whiteColor];
        _vLabel.textAlignment = NSTextAlignmentCenter;
        _vLabel.text = @"V";
    }
    return _vLabel;
}

@end
