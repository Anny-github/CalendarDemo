//
//  AppDelegate.h
//  CalendarDemo
//
//  Created by shan wen on 16/11/22.
//  Copyright © 2016年 WSS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

