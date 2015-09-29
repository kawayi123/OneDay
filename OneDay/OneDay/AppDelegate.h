//
//  AppDelegate.h
//  OneDay
//
//  Created by 段志鑫 on 15/9/18.
//  Copyright (c) 2015年 Mr.ZhixinDuan. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "leftViewController.h"
#import "TabBarController.h"
//#import "SplashscreenViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,UIViewControllerAnimatedTransitioning, ECSlidingViewControllerDelegate, ECSlidingViewControllerLayout>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *
persistentStoreCoordinator;
@property(strong,nonatomic)ECSlidingViewController *slidingViewController;
@property(assign,nonatomic)ECSlidingViewControllerOperation operation;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

