
#import "UnlockTestViewController.h"
#import "GestureViewController.h"
#import "GestureVerifyViewController.h"
#import "PCCircleViewConst.h"

@interface UnlockTestViewController ()<UIAlertViewDelegate>

- (IBAction)BtnClick:(UIButton *)sender;

@end

@implementation UnlockTestViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"手势解锁";
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    NSArray *titles = @[@"设置手势密码", @"登陆手势密码", @"验证手势密码", @"修改手势密码"];
    
    for (int i = 1; i<=4; i++) {
        
        UIButton *b1 = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [b1 setTitle:titles[i-1] forState:UIControlStateNormal];
        //b1.titleLabel.text = titles[i-1];
        //b1.titleLabel.textColor = [UIColor blueColor];
        [b1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [b1 sizeToFit];
        b1.center = CGPointMake(kScreenW/2, 40 * i);
        b1.tag = i;
        [self.view addSubview:b1];
        
        [b1 addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
}

- (IBAction)BtnClick:(UIButton *)sender {
    
    switch (sender.tag) {
        case 1:
        {
            
            //self.navigationController.navigationBarHidden = YES;
            
            //设置手势密码
            GestureViewController *gestureVc = [[GestureViewController alloc] init];
            gestureVc.type = GestureViewControllerTypeSetting;
            
            [self presentViewController:[[UINavigationController alloc] initWithRootViewController:gestureVc] animated:YES completion:^{
                ;
            }];
            //[self.navigationController pushViewController:gestureVc animated:YES];
        }
            break;
        case 2:
        {
            //登陆手势密码
            if ([[PCCircleViewConst getGestureWithKey:gestureFinalSaveKey] length]) {
                GestureViewController *gestureVc = [[GestureViewController alloc] init];
                [gestureVc setType:GestureViewControllerTypeLogin];
                [self.navigationController pushViewController:gestureVc animated:YES];
            } else {
                UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"暂未设置手势密码，是否前往设置" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
                [alerView show];
            }
        }
            break;
        case 3:
        {
            //验证手势密码
            GestureVerifyViewController *gestureVerifyVc = [[GestureVerifyViewController alloc] init];
            [self.navigationController pushViewController:gestureVerifyVc animated:YES];
        }
            break;
            
        case 4:
        {
            //修改手势密码
            GestureVerifyViewController *gestureVerifyVc = [[GestureVerifyViewController alloc] init];
            gestureVerifyVc.isToSetNewGesture = YES;
            [self.navigationController pushViewController:gestureVerifyVc animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        GestureViewController *gestureVc = [[GestureViewController alloc] init];
        gestureVc.type = GestureViewControllerTypeSetting;
        [self.navigationController pushViewController:gestureVc animated:YES];
    }
}

@end
