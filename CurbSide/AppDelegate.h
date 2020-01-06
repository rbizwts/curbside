//
//  AppDelegate.h
//  CurbSide
//
//  Created by WTS on 13/11/17.
//  Copyright © 2017 Kahan Rayjada. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

