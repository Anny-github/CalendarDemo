//
//  CalendarView.m
//  CalendarDemo
//
//  Created by shan wen on 16/11/22.
//  Copyright © 2016年 WSS. All rights reserved.
//

#import "CalendarView.h"
#import "WSCalendar.h"


#define  kScreenHeight [[UIScreen mainScreen] bounds].size.height
#define  kScreenWidth [[UIScreen mainScreen] bounds].size.width
#define  CellUser @"cellUser"
#define  HeadUser @"headUser"
@interface CalendarView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UICollectionView *_collectionView;
    UICollectionViewFlowLayout *_layout;
    NSMutableArray *_dateArray;
    NSMutableArray *_dayDataArray;
    NSDate *_showDate;
    
    UILabel *_yearMonthLabel;
}
@end

@implementation CalendarView


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        //选择视图
        UIView *selectView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
        [self addSubview:selectView];
        _yearMonthLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, selectView.frame.size.height)];
        _yearMonthLabel.textAlignment = NSTextAlignmentCenter;
        [selectView addSubview:_yearMonthLabel];
        CGRect frame = _yearMonthLabel.frame;
        frame.origin.x = selectView.frame.size.width/2.0 - _yearMonthLabel.frame.size.width/2.0;
        _yearMonthLabel.frame = frame;
        
        UIButton *lastMonthBtn = [[UIButton alloc]initWithFrame:CGRectMake(_yearMonthLabel.frame.origin.x - 50, 0, 50, selectView.frame.size.height)];
        lastMonthBtn.backgroundColor = [UIColor blackColor];
        [lastMonthBtn setTitle:@"上月" forState:UIControlStateNormal];
        [lastMonthBtn addTarget:self action:@selector(lastMonthBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [selectView addSubview:lastMonthBtn];
        
        UIButton *nextMonthBtn = [[UIButton alloc]initWithFrame:CGRectMake(_yearMonthLabel.frame.origin.x + _yearMonthLabel.frame.size.width , 0, 50, selectView.frame.size.height)];
        [nextMonthBtn setTitle:@"下月" forState:UIControlStateNormal];
        nextMonthBtn.backgroundColor = [UIColor blackColor];
        [nextMonthBtn addTarget:self action:@selector(nextMonthBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [selectView addSubview:nextMonthBtn];
        
        //星期视图
        UIView *weekView = [[UIView alloc]initWithFrame:CGRectMake(0, selectView.frame.origin.y + 30, kScreenWidth, 30)];
        weekView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:weekView];
        NSArray *weekArr = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
        for (int i = 0; i < weekArr.count; i ++) {
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(i*kScreenWidth/7.0, 0, kScreenWidth/7.0, weekView.frame.size.height)];
            label.text = weekArr[i];
            label.textAlignment = NSTextAlignmentCenter;
            [weekView addSubview:label];
        }
        _layout = [[UICollectionViewFlowLayout alloc]init];
        _layout.itemSize = CGSizeMake(kScreenWidth/7.0 , kScreenWidth/7.0);
        _layout.minimumInteritemSpacing = 0;
        _layout.minimumLineSpacing = 0;
        _layout.sectionInset = UIEdgeInsetsMake(-20, 0, 0, 0);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, weekView.frame.origin.y + weekView.frame.size.height, kScreenWidth, self.frame.size.height - 60) collectionViewLayout:_layout];
        [self addSubview:_collectionView];
    }
    return self;
}

-(void)layoutSubviews{
    //初始化数据
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    _showDate = [date  dateByAddingTimeInterval: interval];
    _dateArray = [NSMutableArray arrayWithObject:_showDate];
    _dayDataArray = [NSMutableArray array];
    
    
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.pagingEnabled = YES;
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CellUser];
//    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeadUser];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    [self layoutData];
    
    
}

#pragma mark --填充数据
-(void)layoutData{
    [_dayDataArray removeAllObjects];
    NSInteger weekFirstDay = [WSCalendar weekDayOfFirstDay:_showDate];
    //第一天前面加空day
    for (int i = 1; i <= weekFirstDay - 1; i ++) {
        [_dayDataArray addObject:@""];
    }
    NSInteger days = [WSCalendar numOfDays:_showDate];
    for (int i = 1; i <= days; i ++ ) {
        [_dayDataArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    [_collectionView reloadData];
    NSInteger year = [WSCalendar yearOfDate:_showDate];
    NSInteger month = [WSCalendar monthOfDate:_showDate];
    _yearMonthLabel.text = [NSString stringWithFormat:@"    %ld年%ld月",year,month];
}

#pragma mark --buttonEvent--
-(void)lastMonthBtnClick{
    NSInteger index = [_dateArray indexOfObject:_showDate];
    if (index == 0) {
        NSDate *lastMonth = [WSCalendar lastMonthDate:_showDate];
        [_dateArray insertObject:lastMonth atIndex:0];
        _showDate = lastMonth;
    }else{
        _showDate = _dateArray[index - 1];
    }
    [self layoutData];
    
}

-(void)nextMonthBtnClick{
    NSInteger index = [_dateArray indexOfObject:_showDate];
    if (index == _dateArray.count - 1) {
        NSDate *nextMonth = [WSCalendar nextMonthDate:_showDate];
        [_dateArray addObject:nextMonth];
        _showDate = nextMonth;
    }else{
        _showDate = _dateArray[index + 1];
    }
    [self layoutData];

}

#pragma mark --CollectionViewDataSource--
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _dayDataArray.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellUser forIndexPath:indexPath];
    UIView *greenV = [[UIView alloc]initWithFrame:cell.bounds];
    greenV.layer.cornerRadius = greenV.frame.size.width/2.0;
    greenV.layer.masksToBounds = YES;
    greenV.backgroundColor = [UIColor greenColor];
    cell.selectedBackgroundView = greenV;
    
    
    UILabel *day = [cell viewWithTag:100];
    if (day == nil) {
        day = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, cell.bounds.size.width-0.5, cell.bounds.size.height - 0.5)];
        day.textAlignment = NSTextAlignmentCenter;
        day.tag = 100;
        [cell addSubview:day];
    }
    day.text = _dayDataArray[indexPath.row];
    
    if (([WSCalendar yearOfDate:[NSDate date]] == [WSCalendar yearOfDate:_showDate])&&([WSCalendar monthOfDate:[NSDate date]] == [WSCalendar monthOfDate:_showDate]) && day.text.integerValue == [WSCalendar dayOfDate:_showDate]) {
        UIView *redV = [[UIView alloc]initWithFrame:cell.bounds];
        redV.layer.cornerRadius = greenV.frame.size.width/2.0;
        redV.layer.masksToBounds = YES;
        redV.backgroundColor = [UIColor redColor];
        cell.backgroundView = redV;
        cell.selectedBackgroundView = nil;
    }else{
        cell.backgroundView = nil;
    }
    //占位cell无需响应
    if (day.text.length < 1) {
        cell.selectedBackgroundView = nil;
    }
    return cell;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    NSString *day = _dayDataArray[indexPath.row];
    if (day.length < 1) { //不响应事件

    }
    self.selectedDayOfDate([day integerValue],_showDate);
}

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath{
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return  CGSizeMake(kScreenWidth, 30);
}
//-(UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
//    if (kind == UICollectionElementKindSectionHeader) {
//        UIView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeadUser forIndexPath:indexPath];
//        UILabel *yearL = [headerView viewWithTag:999];
//
//        if (yearL == nil) {
//            
//            yearL = [[UILabel alloc]initWithFrame:headerView.bounds];
//            yearL.textColor = [UIColor lightGrayColor];
//            [headerView addSubview:yearL];
//            yearL.tag = 999;
//        }
//        
//        NSInteger year = [WSCalendar yearOfDate:_dateArray[indexPath.section]];
//        NSInteger month = [WSCalendar monthOfDate:_dateArray[indexPath.section]];
//        yearL.text = [NSString stringWithFormat:@"    %ld年%ld月",year,month];
//        
//        return (UICollectionReusableView*)headerView;
//    }
//    
//    return nil;
//}


@end
