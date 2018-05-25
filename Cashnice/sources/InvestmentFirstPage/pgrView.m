//
//  pgrView.m
//  Cashnice
//
//  Created by a on 2017/2/13.
//  Copyright © 2017年 l. All rights reserved.
//

#import "pgrView.h"
#import "NSTimer+timerBlock.h"


//角度转换为弧度
#define CircleDegreeToRadian(d) ((d)*M_PI)/180.0
//255进制颜色转换
#define CircleRGB(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
//宽高定义
#define CircleSelfWidth self.frame.size.width
#define CircleSelfHeight self.frame.size.height


@interface pgrView ()


@property (nonatomic, assign) CGFloat progress;/**<进度 0-1 */


@end

@implementation pgrView{
    CGFloat fakeProgress;
    CGFloat _curValEnd;
    CGFloat _curValEndA;
    NSTimer *timer;//定时器用作动画
}


//画背景线、填充线、小圆点、文字
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGFloat _strokeWidth = [ZAPP.zdevice scaledValue:5];
    
    //CGFloat _startAngle = -CircleDegreeToRadian(90);//圆起点位置
    //CGFloat _reduceValue = CircleDegreeToRadian(0);//整个圆缺少的角度
    
    /*
    //获取图形上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //设置中心点 半径 起点及终点
    CGFloat maxWidth = self.frame.size.width<self.frame.size.height?self.frame.size.width:self.frame.size.height;
    CGPoint center = CGPointMake(maxWidth/2.0, maxWidth/2.0);
    CGFloat radius = maxWidth/2.0-_strokeWidth/2.0-1;//留出一像素，防止与边界相切的地方被切平
    CGFloat endA = _startAngle + (CircleDegreeToRadian(360) - _reduceValue);//圆终点位置
    CGFloat valueEndA = _startAngle + (CircleDegreeToRadian(360)-_reduceValue)*fakeProgress;  //数值终点位置
    
    //背景线
    UIBezierPath *basePath = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:_startAngle endAngle:endA clockwise:YES];
    //线条宽度
    CGContextSetLineWidth(ctx, _strokeWidth);
    //设置线条顶端
    CGContextSetLineCap(ctx, kCGLineCapRound);
    //线条颜色
    [[UIColor lightGrayColor] setStroke];
    //把路径添加到上下文
    CGContextAddPath(ctx, basePath.CGPath);
    //渲染背景线
    CGContextStrokePath(ctx);
    
    //路径线
    UIBezierPath *valuePath = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:_startAngle endAngle:valueEndA clockwise:YES];
    //设置线条顶端
    CGContextSetLineCap(ctx, kCGLineCapRound);
    //线条颜色
    [[UIColor orangeColor] setStroke];
    //把路径添加到上下文
    CGContextAddPath(ctx, valuePath.CGPath);
    //渲染数值线
    CGContextStrokePath(ctx);
    
    */
    
    CGFloat h = 1 * self.height;
    CGFloat r = h * 2 / 3 ;
    CGFloat y = r - [ZAPP.zdevice scaledValue:5];
    CGFloat x = self.center.x ;
    
    CGFloat start = M_PI * 5 / 6 ;
    
    CGFloat radius = r - [ZAPP.zdevice scaledValue:40];
    
    CGPoint arcCenter = CGPointMake(x, y);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetRGBStrokeColor(context, 1, 0.5, 1, 1);
    
    CGContextSetLineWidth(context, 4);
    
    CGContextSetLineCap(context, kCGLineCapRound);
    
    //CGContextAddArc(context, x, y, r-20, start, M_PI * 1 / 6, 0);
    
    //背景线
    UIBezierPath *basePath = [UIBezierPath bezierPathWithArcCenter:arcCenter radius:radius startAngle:start endAngle:M_PI * 1 / 6 clockwise:YES];
    //线条宽度
    CGContextSetLineWidth(context, _strokeWidth);
    //设置线条顶端
    CGContextSetLineCap(context, kCGLineCapRound);
    //线条颜色
    [HexRGB(0XC1C1C1) setStroke];
    //把路径添加到上下文
    CGContextAddPath(context, basePath.CGPath);
    //渲染背景线
    CGContextStrokePath(context);
    
    
    //绘制 进度
    CGFloat total = M_PI * 4 / 3 ;
    CGFloat current = total * self.value * 0.01;
    _curValEnd = start + current;
    _curValEndA = start + total*fakeProgress;
    
    UIBezierPath *valuePath = [UIBezierPath bezierPathWithArcCenter:arcCenter radius:radius startAngle:start endAngle:_curValEndA clockwise:YES];
    CGContextSetLineCap(context, kCGLineCapRound);
    [CN_TEXT_BLUE setStroke];
    CGContextAddPath(context, valuePath.CGPath);
    
    CGContextStrokePath(context);
    
    //UIImage *_pointImage = [UIImage imageNamed:@"dian.png"];
    
    //CGContextDrawImage(context, CGRectMake(point.x, point.y, 10, 10), _pointImage.CGImage);
    
    
    
    
    
    //画文字
    NSString *text = [Util percentProgress:self.value];
    NSString *currentText = [NSString stringWithFormat:@"%d%%",(int)(fakeProgress*100)];
    
    //段落格式
    NSMutableParagraphStyle *textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    textStyle.lineBreakMode = NSLineBreakByWordWrapping;
    textStyle.alignment = NSTextAlignmentCenter;//水平居中
    //字体
    UIFont *font = CNFont_24px;
    //构建属性集合
    NSDictionary *attributes = @{NSFontAttributeName:font,
                                 NSParagraphStyleAttributeName:textStyle,
                                 NSForegroundColorAttributeName:CN_TEXT_BLUE,
                                 NSStrokeColorAttributeName:CN_TEXT_BLUE};
    //获得size
    CGSize stringSize = [text sizeWithAttributes:attributes];
    
    
    CGFloat angleW = acos(radius/2 / (radius + stringSize.width));
    CGFloat startW = M_PI_2 + angleW;
    CGFloat endW = M_PI_2 - angleW;
    
    CGFloat totalW = M_PI * 2 - angleW * 2;
    CGFloat valueW = totalW * self.value * 0.01;
    CGFloat curEndAW = startW + totalW * fakeProgress;
    
    UIBezierPath *wPath = [UIBezierPath bezierPathWithArcCenter:arcCenter radius:radius+stringSize.width/2+4 startAngle:startW endAngle:curEndAW clockwise:YES];
    CGContextSetLineCap(context, kCGLineCapRound);
    [[UIColor clearColor] setStroke];
    CGContextAddPath(context, wPath.CGPath);
    
    
    CGPoint point = CGContextGetPathCurrentPoint(context);
    
    CGContextStrokePath(context);
    
    CGRect textRect;
    CGFloat textWidth = stringSize.width;
    CGFloat texthight = stringSize.height;
    
    textRect = CGRectMake(point.x-textWidth/2, point.y-texthight/2, textWidth, texthight);
    
    /*
    CGFloat textRectY = point.y-4;
    
    if (textRectY + texthight > h) {
        //textRectY = h - texthight;
    }
    if (self.value <= 0.5) {
        textRect = CGRectMake(point.x - textWidth, textRectY-texthight+4, textWidth, texthight);
    }else{
        textRect = CGRectMake(point.x,  textRectY-texthight+4, textWidth, texthight);
    }
    
    if (_curValEndA < M_PI) {
        textRect = CGRectMake(point.x - textWidth, textRectY, textWidth, texthight);
    }
    
    if (_curValEndA > M_PI*2) {
        textRect = CGRectMake(point.x + 1, textRectY, textWidth, texthight);
    }
    */
    
    [currentText drawInRect:textRect withAttributes:attributes];
    
    
    
    //画小圆点
    /*
    if (YES) {
        CGContextDrawImage(ctx, CGRectMake(CircleSelfWidth/2 + ((CGRectGetWidth(self.bounds)-_strokeWidth)/2.f-1)*cosf(valueEndA)-_strokeWidth/2.0, CircleSelfWidth/2 + ((CGRectGetWidth(self.bounds)-_strokeWidth)/2.f-1)*sinf(valueEndA)-_strokeWidth/2.0, _strokeWidth, _strokeWidth), _pointImage.CGImage);
    }
    */
    
    if (NO) {
        //画文字
        NSString *currentText = [NSString stringWithFormat:@"%.2f%%",fakeProgress*100];
        //段落格式
        NSMutableParagraphStyle *textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
        textStyle.lineBreakMode = NSLineBreakByWordWrapping;
        textStyle.alignment = NSTextAlignmentCenter;//水平居中
        //字体
        UIFont *font = [UIFont systemFontOfSize:0.15*CircleSelfWidth];
        //构建属性集合
        NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:textStyle};
        //获得size
        CGSize stringSize = [currentText sizeWithAttributes:attributes];
        //垂直居中
        CGRect r = CGRectMake((CircleSelfWidth-stringSize.width)/2.0, (CircleSelfHeight - stringSize.height)/2.0,stringSize.width, stringSize.height);
        [currentText drawInRect:r withAttributes:attributes];
    }
    
}




//设置进度
- (void)setProgress:(CGFloat)progress {
    
    fakeProgress = 0.01 * self.value;
    
    self.value = progress;
    
    progress *= 0.01;
    
    if ((_progress == progress) || progress>1.0 || progress<0.0) {
        return;
    }
    
    BOOL isReverse = progress<fakeProgress?YES:NO;
    //赋真实值
    _progress = progress;
    
    //先暂停计时器
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
    //如果为0或没有动画则直接刷新
    if (_progress == 0.0) {
        fakeProgress = _progress;
        [self setNeedsDisplay];
        return;
    }
    
    //设置每次增加的数值
    //CGFloat sameTimeIncreaseValue = _progress;
    CGFloat defaultIncreaseValue = isReverse==YES?-0.01:0.01;
    
    __weak typeof(self) weakSelf = self;
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.005 block:^{
        
        __strong typeof(weakSelf)strongSelf = weakSelf;
        
        //反方向动画
        if (isReverse) {
            if (_curValEndA >= _curValEnd || fakeProgress <= _progress || fakeProgress <= 0.0f) {
                [strongSelf dealWithLast];
                return;
            } else {
                //进度条动画
                [strongSelf setNeedsDisplay];
            }
        } else {
            //正方向动画 //_curValEndA >= _curValEnd ||
            if (fakeProgress >= _progress || fakeProgress >= 1.0f) {
                [strongSelf dealWithLast];
                return;
            } else {
                //进度条动画
                [strongSelf setNeedsDisplay];
            }
        }
        
        
        fakeProgress += defaultIncreaseValue;//进度越大动画时间越长。
        //数值增加或减少
        //if (_animationModel == CircleIncreaseSameTime) {
        //    fakeProgress += defaultIncreaseValue*sameTimeIncreaseValue;//不同进度动画时间基本相同
        //} else {
        //    fakeProgress += defaultIncreaseValue;//进度越大动画时间越长。
        //}
        
    } repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
}


//最后一次动画所做的处理
- (void)dealWithLast {
    //最后一次赋准确值
    fakeProgress = _progress;
    [self setNeedsDisplay];
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
}

@end
