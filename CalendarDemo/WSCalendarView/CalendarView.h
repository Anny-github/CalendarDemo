//
//  CalendarView.h
//  CalendarDemo
//
//  Created by shan wen on 16/11/22.
//  Copyright © 2016年 WSS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarView : UIView
@property(nonatomic,copy)void(^selectedDayOfDate)(NSInteger day,NSDate *date);

@end
