//
//  ViewController.m
//  CalendarDemo
//
//  Created by shan wen on 16/11/22.
//  Copyright © 2016年 WSS. All rights reserved.
//

#import "ViewController.h"
#import "WSCalendar.h"
#import "CalendarView.h"

@interface ViewController ()
{
    CalendarView *_calendarView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
  
    _calendarView = [[CalendarView alloc]initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 60+self.view.frame.size.width/7.0*7)];
    _calendarView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:_calendarView];
    _calendarView.selectedDayOfDate = ^(NSInteger day,NSDate *date){
        NSLog(@"选中了%@的%ld这一天",date,day);
    };
}




@end
