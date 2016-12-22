//
//  WSCalendar.m
//  CalendarDemo
//
//  Created by shan wen on 16/11/22.
//  Copyright © 2016年 WSS. All rights reserved.
//

#import "WSCalendar.h"
#import <UIKit/UIKit.h>

#define SYSTEMVERSION  [[[UIDevice currentDevice] systemVersion] floatValue]

static NSCalendar *calendar;
@interface WSCalendar()

@end

@implementation WSCalendar


+(NSCalendar *)calendar{
        static NSCalendar *calendar;
        static dispatch_once_t once;
        
        dispatch_once(&once, ^{
#ifdef __IPHONE_8_0
            calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
#else
            calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
#endif
            calendar.timeZone = [NSTimeZone localTimeZone];
        });
        
        return calendar;
}

+(NSDateComponents*)dateComponentsYMDOfDate:(NSDate*)date{
    //NSDateComponents有8小时时差，所以计算前先将date减去8小时
    NSDate *newDate = [NSDate dateWithTimeInterval:-8*60*60 sinceDate:date];
    
    NSDateComponents *components = [[WSCalendar calendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:newDate];

    return components;
}

+(NSInteger)numOfDays:(NSDate*)date{
    
    NSRange range = [[WSCalendar calendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return range.length;
    
}


+(NSInteger)numOfWeek:(NSDate*)date{
    NSInteger totalDay = [WSCalendar numOfDays:date];
    NSInteger firstDay = [WSCalendar weekDayOfFirstDay:date];
    NSInteger weeks;
    if (firstDay == 1) {
        weeks = totalDay % 7 ? (totalDay/7 + 1):totalDay/7;

    }else{
        //第一周几天呢
        NSInteger firstWeekDays = 7 - firstDay + 1;
        NSInteger leftDays = totalDay - firstWeekDays;
        weeks = 1 + (leftDays % 7 ? (leftDays/7 + 1):leftDays/7);
    }
    
    return weeks;

}

+(NSInteger)weekDayOfFirstDay:(NSDate*)date{
    NSInteger day = [WSCalendar dayOfDate:date];
    NSDate *firstDayDate = [NSDate dateWithTimeInterval:-(day - 1)*24*60*60 sinceDate:date];
    
    NSDateComponents *weekdayComponents = [[WSCalendar calendar] components:NSCalendarUnitWeekday fromDate:firstDayDate];
    NSInteger week = [weekdayComponents weekday];
    return week;
}


/**
 dateFromComponents 返回结果错误

 */
+(NSDate *)lastMonthDate:(NSDate*)date{
    NSDateComponents *components = [NSDateComponents new];
    components.month = -1;

    NSDate *lastMonth =  [[WSCalendar calendar] dateByAddingComponents:components toDate:date options:0];
    return lastMonth;

}

+(NSDate *)nextMonthDate:(NSDate*)date{
    NSDateComponents *components = [NSDateComponents new];
    components.month = 1;
    NSDate *nextMonth =  [[WSCalendar calendar] dateByAddingComponents:components toDate:date options:0];
    
    return nextMonth;
    
}


+(NSDate*)lastDay:(NSDate*)date{
    NSDate *lastDate = [NSDate dateWithTimeInterval:-24*60*60 sinceDate:date];
    return lastDate;
}

+(NSDate*)nextDay:(NSDate*)date{
    NSDate *nextDate = [NSDate dateWithTimeInterval:-24*60*60 sinceDate:date];
    return nextDate;
    
}
+(NSInteger)yearOfDate:(NSDate*)date{
    NSDateComponents *components = [WSCalendar dateComponentsYMDOfDate:date];
    return  components.year;
}
+(NSInteger)monthOfDate:(NSDate*)date{
    NSDateComponents *components = [WSCalendar dateComponentsYMDOfDate:date];
    return  components.month;
    
}
+(NSInteger)dayOfDate:(NSDate*)date{
    NSDateComponents *components = [WSCalendar dateComponentsYMDOfDate:date];
    return  components.day;
}
+(BOOL)isToday:(NSDate*)date{
    
    NSDateComponents *dateCompo = [WSCalendar dateComponentsYMDOfDate:date];
    NSDateComponents *todayCompo = [WSCalendar dateComponentsYMDOfDate:[WSCalendar correctDate:[NSDate date]]];
    return (dateCompo.year == todayCompo.year)&&(dateCompo.month == todayCompo.month)&&(dateCompo.day == [WSCalendar dayOfDate:date]);
    
}

+(NSDate*)correctDate:(NSDate*)date{
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    date = [date  dateByAddingTimeInterval: interval];
    return date;
}
@end
