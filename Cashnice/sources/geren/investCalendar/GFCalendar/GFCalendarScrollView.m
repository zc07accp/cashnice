//
//  GFCalendarScrollView.m
//
//  Created by Mercy on 2016/11/9.
//  Copyright © 2016年 Mercy. All rights reserved.
//

#import "GFCalendarScrollView.h"
#import "GFCalendarCell.h"
#import "GFCalendarMonth.h"
#import "NSDate+GFCalendar.h"

@interface GFCalendarScrollView() <UICollectionViewDataSource, UICollectionViewDelegate>{
    
    
    Boolean   _isSelected;
    NSInteger _selectedMonth;
    NSInteger _selectedYear;
    NSInteger _selectedDay;
    
    UICollectionView *prevCollectionView;
    NSIndexPath      *preIndexPath;
    
    
    // 星期头部栏高度
    CGFloat _weekHeaderHeight;
    CGFloat _monthViewHeight ;
    
}

@property (nonatomic, strong) UICollectionView *collectionViewL;
@property (nonatomic, strong) UICollectionView *collectionViewM;
@property (nonatomic, strong) UICollectionView *collectionViewR;

@property (nonatomic, strong) NSDate *currentMonthDate;

@property (nonatomic, strong) NSMutableArray *monthArray;

@end

@implementation GFCalendarScrollView
#define kCalendarBasicColor [UIColor colorWithRed:1 green:1 blue:1 alpha:1.0]
//#define kCalendarBasicColor [UIColor colorWithRed:231.0 / 255.0 green:85.0 / 255.0 blue:85.0 / 255.0 alpha:1.0]
//#define kCalendarBasicColor [UIColor colorWithRed:252.0 / 255.0 green:60.0 / 255.0 blue:60.0 / 255.0 alpha:1.0]

static NSString *const kCellIdentifier = @"cell";


CGFloat preOffset = 0.0f;

#pragma mark - Initialiaztion

- (instancetype)initWithFrame:(CGRect)frame {
    
    if ([super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.pagingEnabled = YES;
        self.bounces = YES;
        self.delegate = self;
        
        
        
        _weekHeaderHeight = 0.75 * (self.width / 7.0);
        _monthViewHeight = self.height - _weekHeaderHeight;
        
        
        self.contentSize = CGSizeMake(3 * self.bounds.size.width, self.height);
        [self setContentOffset:CGPointMake(self.bounds.size.width, 0.0) animated:NO];
        preOffset = self.contentOffset.x;
        
        
        _currentMonthDate = [NSDate date];
        [self setupCollectionViews];
        
    }
    
    return self;
    
}

- (void)setMonthHightPoint:(NSArray *)dateArray{
    GFCalendarMonth *monthInfo = self.monthArray[1];
    NSInteger firstWeekday = monthInfo.firstWeekday;
    //NSInteger totalDays = monthInfo.totalDays;
    
    
    for (NSString *date in dateArray) {
        NSArray *components = [date componentsSeparatedByString:@"-"];
        if (components.count == 3) {
            NSInteger day = [components[2] integerValue];
            NSInteger idx = firstWeekday + day - 1;
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx inSection:0];
            GFCalendarCell *cell = (GFCalendarCell *)[_collectionViewM cellForItemAtIndexPath:indexPath];
            cell.underPoint.hidden = NO;
        }
    }
    
}

- (NSMutableArray *)monthArray {
    
    if (_monthArray == nil) {
        
        _monthArray = [NSMutableArray arrayWithCapacity:4];
        
        NSDate *previousMonthDate = [_currentMonthDate previousMonthDate];
        NSDate *nextMonthDate = [_currentMonthDate nextMonthDate];
        
        [_monthArray addObject:[[GFCalendarMonth alloc] initWithDate:previousMonthDate]];
        [_monthArray addObject:[[GFCalendarMonth alloc] initWithDate:_currentMonthDate]];
        [_monthArray addObject:[[GFCalendarMonth alloc] initWithDate:nextMonthDate]];
        [_monthArray addObject:[self previousMonthDaysForPreviousDate:previousMonthDate]]; // 存储左边的月份的前一个月份的天数，用来填充左边月份的首部
        
        // 发通知，更改当前月份标题
        [self notifyToChangeCalendarHeader];
    }
    
    return _monthArray;
}

- (NSNumber *)previousMonthDaysForPreviousDate:(NSDate *)date {
    return [[NSNumber alloc] initWithInteger:[[date previousMonthDate] totalDaysInMonth]];
}


- (void)setupCollectionViews {
        
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    //flowLayout.itemSize = CGSizeMake(self.bounds.size.width / 7.0, self.bounds.size.width / 7.0 * 0.85);
    flowLayout.minimumLineSpacing = 0.0;
    flowLayout.minimumInteritemSpacing = 0.0;
    
    UICollectionViewFlowLayout *flowLayout2 = [[UICollectionViewFlowLayout alloc] init];
    //flowLayout2.itemSize = CGSizeMake(self.bounds.size.width / 7.0, self.bounds.size.width / 7.0 * 0.85);;
    flowLayout2.minimumLineSpacing = 0.0;
    flowLayout2.minimumInteritemSpacing = 0.0;
    
    UICollectionViewFlowLayout *flowLayout3 = [[UICollectionViewFlowLayout alloc] init];
    //flowLayout3.itemSize = CGSizeMake(self.bounds.size.width / 7.0, self.bounds.size.width / 7.0 * 0.85);
    //flowLayout3.itemSize = CGSizeMake(10,5);
    flowLayout3.minimumLineSpacing = 0.0;
    flowLayout3.minimumInteritemSpacing = 0.0;
    
    
    CGSize size5 = CGSizeMake(self.bounds.size.width / 7.0 -1, _monthViewHeight / 5);
    CGSize size6 = CGSizeMake(self.bounds.size.width / 7.0 -1, _monthViewHeight / 6);
    GFCalendarMonth *monthInfo = self.monthArray[1];;
    NSInteger items = monthInfo.firstWeekday + monthInfo.totalDays;
    if (items <= 35) {
        flowLayout2.itemSize = size5;
    }else{
        flowLayout2.itemSize = size6;
    }
    
    monthInfo = self.monthArray[0];;
    items = monthInfo.firstWeekday + monthInfo.totalDays;
    if (items <= 35) {
        flowLayout.itemSize = size5;
    }else{
        flowLayout.itemSize = size6;
    }
    
    monthInfo = self.monthArray[2];;
    items = monthInfo.firstWeekday + monthInfo.totalDays;
    if (items <= 35) {
        flowLayout3.itemSize = size5;
    }else{
        flowLayout3.itemSize = size6;
    }
    
    CGFloat selfWidth = self.bounds.size.width;
    CGFloat selfHeight = _monthViewHeight;
    
    _collectionViewL = [[UICollectionView alloc] initWithFrame:CGRectMake(0.0, _weekHeaderHeight, selfWidth, selfHeight) collectionViewLayout:flowLayout];
    _collectionViewL.dataSource = self;
    _collectionViewL.delegate = self;
    _collectionViewL.backgroundColor = [UIColor clearColor];
    [_collectionViewL registerClass:[GFCalendarCell class] forCellWithReuseIdentifier:kCellIdentifier];
    [self addSubview:_collectionViewL];
    
    _collectionViewM = [[UICollectionView alloc] initWithFrame:CGRectMake(selfWidth, _weekHeaderHeight, selfWidth, selfHeight) collectionViewLayout:flowLayout2];
    _collectionViewM.dataSource = self;
    _collectionViewM.delegate = self;
    _collectionViewM.backgroundColor = [UIColor clearColor];
    [_collectionViewM registerClass:[GFCalendarCell class] forCellWithReuseIdentifier:kCellIdentifier];
    [self addSubview:_collectionViewM];
    
    _collectionViewR = [[UICollectionView alloc] initWithFrame:CGRectMake(2 * selfWidth, _weekHeaderHeight, selfWidth, selfHeight) collectionViewLayout:flowLayout3];
    _collectionViewR.dataSource = self;
    _collectionViewR.delegate = self;
    _collectionViewR.backgroundColor = [UIColor clearColor];
    [_collectionViewR registerClass:[GFCalendarCell class] forCellWithReuseIdentifier:kCellIdentifier];
    [self addSubview:_collectionViewR];
    
    
    
    CGFloat weekWidth = self.width / 7.0;
    
    for (int i = 0; i<3; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(self.width * i, 0, self.width, _weekHeaderHeight)];
        //view.backgroundColor = [UIColor greenColor];
        
        NSArray *weekArray = @[@"一", @"二", @"三", @"四", @"五", @"六", @"日"];
        for (int i = 0; i < weekArray.count; ++i) {
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i * weekWidth, 4.0, weekWidth, _weekHeaderHeight)];
            label.backgroundColor = [UIColor clearColor];
            label.text = weekArray[i];
            label.font = CNFont_24px;
            label.textAlignment = NSTextAlignmentCenter;
            [view addSubview:label];
            
            if (i >= 5) {
                label.textColor = CN_UNI_RED;
            }else{
                label.textColor = CN_TEXT_GRAY_9;
            }
            
        }
        
        [self addSubview:view];
    }

}

#pragma mark -

- (void)notifyToChangeCalendarHeader {
    
    GFCalendarMonth *currentMonthInfo = self.monthArray[1];
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithCapacity:2];
    
    [userInfo setObject:[[NSNumber alloc] initWithInteger:currentMonthInfo.year] forKey:@"year"];
    [userInfo setObject:[[NSNumber alloc] initWithInteger:currentMonthInfo.month] forKey:@"month"];
    
    NSNotification *notify = [[NSNotification alloc] initWithName:@"ChangeCalendarHeaderNotification" object:nil userInfo:userInfo];
    [[NSNotificationCenter defaultCenter] postNotification:notify];
    
}

- (void)refreshToCurrentMonth {
    
    // 如果现在就在当前月份，则不执行操作
    GFCalendarMonth *currentMonthInfo = self.monthArray[1];
    if ((currentMonthInfo.month == [[NSDate date] dateMonth]) && (currentMonthInfo.year == [[NSDate date] dateYear])) {
        return;
    }
    
    _currentMonthDate = [NSDate date];
    
    NSDate *previousMonthDate = [_currentMonthDate previousMonthDate];
    NSDate *nextMonthDate = [_currentMonthDate nextMonthDate];
    
    [self.monthArray removeAllObjects];
    [self.monthArray addObject:[[GFCalendarMonth alloc] initWithDate:previousMonthDate]];
    [self.monthArray addObject:[[GFCalendarMonth alloc] initWithDate:_currentMonthDate]];
    [self.monthArray addObject:[[GFCalendarMonth alloc] initWithDate:nextMonthDate]];
    [self.monthArray addObject:[self previousMonthDaysForPreviousDate:previousMonthDate]];
    
    // 刷新数据
    [_collectionViewM reloadData];
    [_collectionViewL reloadData];
    [_collectionViewR reloadData];
    
}


#pragma mark - UICollectionDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    GFCalendarMonth *monthInfo;
    NSInteger firstWeekday = 0;
    NSInteger totalDays = 0;
    
    if (collectionView == _collectionViewL) {
        
        monthInfo = self.monthArray[0];
        firstWeekday = monthInfo.firstWeekday;;
        totalDays = monthInfo.totalDays;
        
        
    }else if (collectionView == _collectionViewM) {
    
        [self notifyToChangeCalendarHeader];
        
        
        monthInfo = self.monthArray[1];
        
        firstWeekday = monthInfo.firstWeekday;;
        totalDays = monthInfo.totalDays;;
        
        
        if (self.didSelectMonthHandler) {
            self.didSelectMonthHandler(monthInfo.year, monthInfo.month);
        }
        
    }else{
        monthInfo = self.monthArray[2];
        
        firstWeekday = monthInfo.firstWeekday;;
        totalDays = monthInfo.totalDays;;
        
    }
    
    NSInteger items = monthInfo.firstWeekday + monthInfo.totalDays;
    
    if (items <= 35) {
        //UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)_collectionViewR.collectionViewLayout;
        //layout.itemSize = CGSizeMake(self.bounds.size.width / 7.0, monthViewHeight / 5);
        
        return 7 * 5;
    }else{
        //UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)_collectionViewR.collectionViewLayout;
        //layout.itemSize = CGSizeMake(self.bounds.size.width / 7.0, monthViewHeight / 6);
        
        return 7 * 6;
    }
    
}

- (NSString *)dateStringWithDayNumber:(NSInteger)day{
    
    if(day < 10)
        return [NSString stringWithFormat:@"0%ld", day];
    else
        return [NSString stringWithFormat:@"%ld", day];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    GFCalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    if (collectionView == _collectionViewL) {
        
        cell.SelectedCircle.hidden  =  YES;
        
        GFCalendarMonth *monthInfo = self.monthArray[0];
        NSInteger firstWeekday = monthInfo.firstWeekday;
        NSInteger totalDays = monthInfo.totalDays;
        
        // 当前月
        if (indexPath.row >= firstWeekday && indexPath.row < firstWeekday + totalDays) {
            cell.todayLabel.text = [self dateStringWithDayNumber: indexPath.row - firstWeekday + 1];
            cell.todayLabel.textColor = CN_TEXT_GRAY;
            
            // 标识今天
            if ((monthInfo.month == [[NSDate date] dateMonth]) && (monthInfo.year == [[NSDate date] dateYear])) {
                if (indexPath.row == [[NSDate date] dateDay] + firstWeekday - 1) {
                    cell.todayCircle.hidden = NO;
                    //cell.todayLabel.textColor = [UIColor whiteColor];
                } else {
                    cell.todayCircle.hidden = YES;
                }
            } else {
                cell.todayCircle.hidden = YES;
            }
            cell.userInteractionEnabled = YES;
        }
        // 补上前后月的日期，淡色显示
        else if (indexPath.row < firstWeekday) {
            int totalDaysOflastMonth = [self.monthArray[3] intValue];
            cell.todayLabel.text = [self dateStringWithDayNumber:  totalDaysOflastMonth - (firstWeekday - indexPath.row) + 1];
            cell.todayLabel.textColor = HexRGB(0XCCCCCC);
            cell.todayCircle.hidden = YES;
            cell.userInteractionEnabled = NO;
        } else if (indexPath.row >= firstWeekday + totalDays) {
            cell.todayLabel.text = [self dateStringWithDayNumber:  indexPath.row - firstWeekday - totalDays + 1];
            cell.todayLabel.textColor = HexRGB(0XCCCCCC);
            cell.todayCircle.hidden = YES;
            cell.userInteractionEnabled = NO;
        }
        
    }
    else if (collectionView == _collectionViewM) {
        
        GFCalendarMonth *monthInfo = self.monthArray[1];
        NSInteger firstWeekday = monthInfo.firstWeekday;
        NSInteger totalDays = monthInfo.totalDays;
        
        // 当前月
        if (indexPath.row >= firstWeekday && indexPath.row < firstWeekday + totalDays) {
            cell.todayLabel.text = [self dateStringWithDayNumber:  indexPath.row - firstWeekday + 1];
            cell.todayLabel.textColor = CN_TEXT_GRAY;
            cell.userInteractionEnabled = YES;
            
            // 标识今天
            if ((monthInfo.month == [[NSDate date] dateMonth]) && (monthInfo.year == [[NSDate date] dateYear])) {
                if (indexPath.row == [[NSDate date] dateDay] + firstWeekday - 1) {
                    cell.todayCircle.hidden = NO;
                    //cell.todayLabel.textColor = [UIColor whiteColor];
                } else {
                    cell.todayCircle.hidden = YES;
                }
            } else {
                cell.todayCircle.hidden = YES;
            }
            
        }
        // 补上前后月的日期，淡色显示
        else if (indexPath.row < firstWeekday) {
            GFCalendarMonth *lastMonthInfo = self.monthArray[0];
            NSInteger totalDaysOflastMonth = lastMonthInfo.totalDays;
            cell.todayLabel.text = [self dateStringWithDayNumber:  totalDaysOflastMonth - (firstWeekday - indexPath.row) + 1];
            cell.todayLabel.textColor = HexRGB(0XCCCCCC);
            cell.todayCircle.hidden = YES;
            cell.userInteractionEnabled = NO;
        } else if (indexPath.row >= firstWeekday + totalDays) {
            cell.todayLabel.text = [self dateStringWithDayNumber: indexPath.row - firstWeekday - totalDays + 1];
            cell.todayLabel.textColor = HexRGB(0XCCCCCC);
            cell.todayCircle.hidden = YES;
            cell.userInteractionEnabled = NO;
        }
        
        
        //////////////////////////////////////////////////////////////////
        //////////////////////////////////////////////////////////////////
        //////////////////////////////////////////////////////////////////
        // 标识已选择
        if ((monthInfo.month == _selectedMonth) && (monthInfo.year == _selectedYear)) {
            if (indexPath.row == _selectedDay + firstWeekday - 1) {
                cell.SelectedCircle.hidden  =  NO;
                //cell.todayLabel.textColor = [UIColor whiteColor];
            } else {
                cell.SelectedCircle.hidden  =  YES;
            }
        } else {
            cell.SelectedCircle.hidden  =  YES;
        }
        
    }
    else if (collectionView == _collectionViewR) {
        
        GFCalendarMonth *monthInfo = self.monthArray[2];
        NSInteger firstWeekday = monthInfo.firstWeekday;
        NSInteger totalDays = monthInfo.totalDays;
        
        cell.SelectedCircle.hidden  =  YES;
        
        // 当前月
        if (indexPath.row >= firstWeekday && indexPath.row < firstWeekday + totalDays) {
            
            cell.todayLabel.text = [self dateStringWithDayNumber:  indexPath.row - firstWeekday + 1];
            cell.todayLabel.textColor = CN_TEXT_GRAY;
            
            // 标识今天
            if ((monthInfo.month == [[NSDate date] dateMonth]) && (monthInfo.year == [[NSDate date] dateYear])) {
                if (indexPath.row == [[NSDate date] dateDay] + firstWeekday - 1) {
                    cell.todayCircle.hidden = NO;
                    //cell.todayLabel.textColor = [UIColor whiteColor];
                } else {
                    cell.todayCircle.hidden = YES;
                }
            } else {
                cell.todayCircle.hidden = YES;
            }
            
        }
        // 补上前后月的日期，淡色显示
        
        else if (indexPath.row < firstWeekday) {
            GFCalendarMonth *lastMonthInfo = self.monthArray[1];
            NSInteger totalDaysOflastMonth = lastMonthInfo.totalDays;
            cell.todayLabel.text = [self dateStringWithDayNumber: totalDaysOflastMonth - (firstWeekday - indexPath.row) + 1];
            cell.todayLabel.textColor = HexRGB(0XCCCCCC);
            cell.todayCircle.hidden = YES;
        } else if (indexPath.row >= firstWeekday + totalDays) {
            cell.todayLabel.text = [self dateStringWithDayNumber:  indexPath.row - firstWeekday - totalDays + 1];
            cell.todayLabel.textColor = HexRGB(0XCCCCCC);
            cell.todayCircle.hidden = YES;
        }
        
        cell.userInteractionEnabled = NO;
        
    }
    
    cell.todayLabel.frame = cell.bounds;
    
    CGRect frame = cell.frame;
    CGFloat circleSize = frame.size.width-(frame.size.width-frame.size.height) - 2;
    frame = CGRectMake((frame.size.width - circleSize)/2, (frame.size.height-circleSize)/2, circleSize, circleSize);
    cell.SelectedCircle.frame = frame;
    cell.SelectedCircle.layer.cornerRadius = 0.5 * frame.size.width;
    
    cell.todayCircle.frame = frame;
    cell.todayCircle.layer.cornerRadius = 0.5 * frame.size.width;
    
    //红点
    cell.underPoint.center = CGPointMake(cell.width*.5, cell.height*0.75 );
    cell.underPoint.hidden = YES;
    //cell.backgroundColor = [UIColor orangeColor];
    
    
    return cell;
    
}


#pragma mark - UICollectionViewDeleagate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.didSelectDayHandler != nil) {
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth) fromDate:_currentMonthDate];
        NSDate *currentDate = [calendar dateFromComponents:components];
        
        GFCalendarCell *cell = (GFCalendarCell *)[collectionView cellForItemAtIndexPath:indexPath];
        
        NSInteger year = [currentDate dateYear];
        NSInteger month = [currentDate dateMonth];
        NSInteger day = [cell.todayLabel.text integerValue];
        
        if (year == _selectedYear && month == _selectedMonth && day == _selectedDay) {
            _isSelected = NO;
            _selectedDay = _selectedMonth = _selectedYear = 0;
            cell.SelectedCircle.hidden = YES;
            prevCollectionView = nil;
            
            self.didDisSelectDayHandler(year, month, day); // 执行回调
        }else{
            _isSelected = YES;
            _selectedYear = year;
            _selectedMonth = month;
            _selectedDay = day;
            
            GFCalendarCell *prevCell = (GFCalendarCell *)[prevCollectionView cellForItemAtIndexPath:preIndexPath];
            prevCell.SelectedCircle.hidden = YES;
            
            cell.SelectedCircle.hidden = NO;
            prevCollectionView = collectionView;
            preIndexPath = indexPath;
            
            self.didSelectDayHandler(year, month, day); // 执行回调
        }
        
        //GFCalendarCell *cell = (GFCalendarCell *)[collectionView cellForItemAtIndexPath:indexPath];
        
    }
    
}


#pragma mark - UIScrollViewDelegate


- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    CGFloat wid = self.bounds.size.width;
    
    // 向右滑动
    CGFloat x = scrollView.contentOffset.x;
    
    x = scrollView.contentOffset.x;
    x = scrollView.contentOffset.x;
        
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (scrollView != self) {
        return;
    }
    
    
    //CGFloat wid = self.bounds.size.width;
    //CFloat x = scrollView.contentOffset.x;
    //CGFloat y = scrollView.contentOffset.y;
    //CGFloat p = (scrollView.contentOffset.x - preOffset);
    
    
    if (fabs(scrollView.contentOffset.x - preOffset) < self.width * 0.9) {
        return;
    }
    
        // 向右滑动
    if (scrollView.contentOffset.x < self.bounds.size.width * 0.9) {
        
        
        GFCalendarMonth *current = self.monthArray[1];
        
        /*
        if (current.year == 2017 && current.month == 2) {
            if (scrollView.contentOffset.x == 0) {
                [self.monthArray setObject:_monthArray[0] atIndexedSubscript:1];
            }
            
            // 发通知，更改当前月份标题
            [self notifyToChangeCalendarHeader];
            return;
        }
        */
        
        
        NSString *currentStr = [NSString stringWithFormat:@"%zd%@", current.year, (current.month<10)?[NSString stringWithFormat:@"0%zd", current.month] : [NSString stringWithFormat:@"%zd", current.month]];
        
        if ([currentStr compare:@"201601"] <= 0) {
            
            if (scrollView.contentOffset.x == 0) {
                // 发通知，更改当前月份标题
                GFCalendarMonth *currentMonthInfo = self.monthArray[0];
                
                NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithCapacity:2];
                
                [userInfo setObject:[[NSNumber alloc] initWithInteger:currentMonthInfo.year] forKey:@"year"];
                [userInfo setObject:[[NSNumber alloc] initWithInteger:currentMonthInfo.month] forKey:@"month"];
                
                NSNotification *notify = [[NSNotification alloc] initWithName:@"ChangeCalendarHeaderNotification" object:nil userInfo:userInfo];
                [[NSNotificationCenter defaultCenter] postNotification:notify];
                if (self.didSelectMonthHandler) {
                    self.didSelectMonthHandler(currentMonthInfo.year, currentMonthInfo.month);
                }
            }
            
            preOffset = scrollView.contentOffset.x;
            return;
        }
        
        /*
        if ([currentStr compare:@"201701"] == 0) {
            [self.monthArray setObject:_monthArray[0] atIndexedSubscript:1];
            // 发通知，更改当前月份标题
            [self notifyToChangeCalendarHeader];
            return;
        }
        */
        
        
        _currentMonthDate = [_currentMonthDate previousMonthDate];
        NSDate *previousDate = [_currentMonthDate previousMonthDate];
        
        // 数组中最左边的月份现在作为中间的月份，中间的作为右边的月份，新的左边的需要重新获取
        GFCalendarMonth *currentMothInfo = self.monthArray[0];
        GFCalendarMonth *nextMonthInfo = self.monthArray[1];
        
        
        GFCalendarMonth *olderNextMonthInfo = self.monthArray[2];
        
        // 复用 GFCalendarMonth 对象
        olderNextMonthInfo.totalDays = [previousDate totalDaysInMonth];
        olderNextMonthInfo.firstWeekday = [previousDate firstWeekDayInMonth];
        olderNextMonthInfo.year = [previousDate dateYear];
        olderNextMonthInfo.month = [previousDate dateMonth];
        olderNextMonthInfo.monthDate = previousDate;
        GFCalendarMonth *previousMonthInfo = olderNextMonthInfo;
        
        NSNumber *prePreviousMonthDays = [self previousMonthDaysForPreviousDate:[_currentMonthDate previousMonthDate]];
        
        [self.monthArray removeAllObjects];
        [self.monthArray addObject:previousMonthInfo];
        [self.monthArray addObject:currentMothInfo];
        [self.monthArray addObject:nextMonthInfo];
        [self.monthArray addObject:prePreviousMonthDays];
        
    }
    // 向左滑动
    else if (scrollView.contentOffset.x > self.bounds.size.width) {
        
        _currentMonthDate = [_currentMonthDate nextMonthDate];
        NSDate *nextDate = [_currentMonthDate nextMonthDate];
        
        // 数组中最右边的月份现在作为中间的月份，中间的作为左边的月份，新的右边的需要重新获取
        GFCalendarMonth *previousMonthInfo = self.monthArray[1];
        GFCalendarMonth *currentMothInfo = self.monthArray[2];
        
        
        GFCalendarMonth *olderPreviousMonthInfo = self.monthArray[0];
        
        NSNumber *prePreviousMonthDays = [[NSNumber alloc] initWithInteger:olderPreviousMonthInfo.totalDays]; // 先保存 olderPreviousMonthInfo 的月天数
        
        // 复用 GFCalendarMonth 对象
        olderPreviousMonthInfo.totalDays = [nextDate totalDaysInMonth];
        olderPreviousMonthInfo.firstWeekday = [nextDate firstWeekDayInMonth];
        olderPreviousMonthInfo.year = [nextDate dateYear];
        olderPreviousMonthInfo.month = [nextDate dateMonth];
        olderPreviousMonthInfo.monthDate = nextDate;
        GFCalendarMonth *nextMonthInfo = olderPreviousMonthInfo;

        
        [self.monthArray removeAllObjects];
        [self.monthArray addObject:previousMonthInfo];
        [self.monthArray addObject:currentMothInfo];
        [self.monthArray addObject:nextMonthInfo];
        [self.monthArray addObject:prePreviousMonthDays];
        
    }
    
    preOffset = scrollView.contentOffset.x;
    
    CGSize size5 = CGSizeMake(self.bounds.size.width / 7.0, _monthViewHeight / 5);
    CGSize size6 = CGSizeMake(self.bounds.size.width / 7.0, _monthViewHeight / 6);
    
    //_collectionViewM
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)_collectionViewM.collectionViewLayout;
    GFCalendarMonth *monthInfo = self.monthArray[1];;
    NSInteger items = monthInfo.firstWeekday + monthInfo.totalDays;
    if (items <= 35) {
        layout.itemSize = size5;
    }else{
        layout.itemSize = size6;
    }
    
    //_collectionViewL
    layout = (UICollectionViewFlowLayout *)_collectionViewL.collectionViewLayout;
    monthInfo = self.monthArray[0];;
    items = monthInfo.firstWeekday + monthInfo.totalDays;
    if (items <= 35) {
        layout.itemSize = size5;
    }else{
        layout.itemSize = size6;
    }
    
    //_collectionViewR
    layout = (UICollectionViewFlowLayout *)_collectionViewR.collectionViewLayout;
    monthInfo = self.monthArray[2];;
    items = monthInfo.firstWeekday + monthInfo.totalDays;
    if (items <= 35) {
        layout.itemSize = size5;
    }else{
        layout.itemSize = size6;
    }
    
    //取消选中
    _isSelected = NO;
    _selectedDay = _selectedMonth = _selectedYear = 0;
    
    [_collectionViewM reloadData]; // 中间的 collectionView 先刷新数据
    [scrollView setContentOffset:CGPointMake(self.bounds.size.width, 0.0) animated:NO]; // 然后变换位置
    [_collectionViewL reloadData]; // 最后两边的 collectionView 也刷新数据
    [_collectionViewR reloadData];
    
    preOffset = scrollView.contentOffset.x;
    
    // 发通知，更改当前月份标题
    [self notifyToChangeCalendarHeader];
    
}

@end
