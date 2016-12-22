//
//  WSCalendar.h
//  CalendarDemo
//
//  Created by shan wen on 16/11/22.
//  Copyright © 2016年 WSS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WSCalendar : NSObject


/**
 这个月几天
*/
+(NSInteger)numOfDays:(NSDate*)date;

/**
 这个月几周 按日历每行一周算 几行
 */
+(NSInteger)numOfWeek:(NSDate*)date;


/**
 第一天周几 1:表示周日  以此类推
 */
+(NSInteger)weekDayOfFirstDay:(NSDate*)date;


+(NSDate *)lastDay:(NSDate*)date;
+(NSDate *)nextDay:(NSDate*)date;
+(NSDate *)lastMonthDate:(NSDate*)date;
+(NSDate *)nextMonthDate:(NSDate*)date;
+(NSInteger)yearOfDate:(NSDate*)date;
+(NSInteger)monthOfDate:(NSDate*)date;
+(NSInteger)dayOfDate:(NSDate*)date;
+(BOOL)isToday:(NSDate*)date;


@end
