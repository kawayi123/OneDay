//
//  calendarViewController.m
//  OneDay
//
//  Created by 段志鑫 on 15/9/21.
//  Copyright (c) 2015年 Mr.ZhixinDuan. All rights reserved.
//

#import "calendarViewController.h"

@interface calendarViewController ()
{
    NSMutableDictionary *_eventsByDate;
    NSDate *_dateSelected;
}

@end

@implementation calendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _rawArray = nil;
    _rawArray = [NSMutableArray new];
    _targetArray = nil;
    _targetArray = [NSMutableArray new];
    _dateSelected = [[NSDate date] dateAtStartOfDay];
    [self calendars];
    [self requestDataForMe];
}
- (void)tagCloudView{
    [_rawArray removeAllObjects];
    for (PFObject *obj in _objectsForShow) {
        NSString *sn = obj[@"Schedulename"];
        NSLog(@"%@", sn);
        [_rawArray addObject:sn];
    }
    NSLog(@"_rawArray = %@", _rawArray);
    [_tagListView.tags removeAllObjects];
    [_tagListView.tags addObjectsFromArray:_rawArray];
    [self.tagListView setCompletionBlockWithSeleted:^(NSInteger index) {
        if ([_targetArray containsObject:[NSString stringWithFormat:@"%ld", (long)index]]) {
            [_targetArray removeObject:[NSString stringWithFormat:@"%ld", (long)index]];
        } else {
            [_targetArray addObject:[NSString stringWithFormat:@"%ld", (long)index]];
        }
        NSLog(@"%@", _targetArray);
    }];
    _tagListView.canSeletedTags = YES;
    _tagListView.tagColor = [UIColor orangeColor];
    _tagListView.tagCornerRadius = 5.0f;
    [self.tagListView.collectionView reloadData];
}
- (void)requestDataForMe{
    
    PFUser *currentUser = [PFUser currentUser];
    NSLog(@"currentUser = %@", currentUser);
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Publisher == %@", currentUser];
    NSLog(@"_dateSelected = %@", [_dateSelected description]);
    PFQuery *query = [PFQuery queryWithClassName:@"Schedule" predicate:predicate];
    //PFQuery *query = [PFQuery queryWithClassName:@"Schedule"];
    [query whereKey:@"StartDate" equalTo:_dateSelected];
    [query selectKeys:@[@"Schedulename", @"StartTime"]];
    //[query includeKey:@"Publisher"];
    
    UIActivityIndicatorView *aiv = [Utilities getCoverOnView:self.view];
    [query findObjectsInBackgroundWithBlock:^(NSArray *returnedObjects, NSError *error) {
        [aiv stopAnimating];
        //[rc endRefreshing];
        if (!error) {
            _objectsForShow = returnedObjects;
            [self tagCloudView];
            
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarDayView *)dayView
{
    dayView.hidden = NO;
    
    // Other month
    if([dayView isFromAnotherMonth]){
        dayView.hidden = YES;
    }
    // Today
    else if([_calendarManager.dateHelper date:[NSDate date] isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor blueColor];
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    // Selected date
    else if(_dateSelected && [_calendarManager.dateHelper date:_dateSelected isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor redColor];
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    // Another day of the current month
    else{
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor redColor];
        dayView.textLabel.textColor = [UIColor blackColor];
    }
    
    if([self haveEventForDay:dayView.date]){
        dayView.dotView.hidden = NO;
    }
    else{
        dayView.dotView.hidden = YES;
    }
}
-(void)calendars
{
    _calendarManager = [JTCalendarManager new];
    _calendarManager.delegate = self;
    
    // Generate random events sort by date using a dateformatter for the demonstration
    [self createRandomEvents];
    
    _calendarMenuView.contentRatio = .75;
    _calendarManager.settings.weekDayFormat = JTCalendarWeekDayFormatSingle;
    _calendarManager.dateHelper.calendar.locale = [NSLocale localeWithLocaleIdentifier:@"fr_FR"];
    
    [_calendarManager setMenuView:_calendarMenuView];
    [_calendarManager setContentView:_calendarContentView];
    [_calendarManager setDate:[NSDate date]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//下面两段代码二级页面不在能进行左滑操作
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"enablePanGes" object:self];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"disablePanGes" object:self];
}


- (void)calendar:(JTCalendarManager *)calendar didTouchDayView:(JTCalendarDayView *)dayView
{
    _dateSelected = dayView.date;
    
    // Animation for the circleView
    dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
    [UIView transitionWithView:dayView
                      duration:.3
                       options:0
                    animations:^{
                        dayView.circleView.transform = CGAffineTransformIdentity;
                        [_calendarManager reload];
                    } completion:nil];
    
    
    // Load the previous or next page if touch a day from another month
    
    if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
        if([_calendarContentView.date compare:dayView.date] == NSOrderedAscending){
            [_calendarContentView loadNextPageWithAnimation];
        }
        else{
            [_calendarContentView loadPreviousPageWithAnimation];
        }
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm:ss"];
    _date =  [dateFormatter stringFromDate:_dateSelected];
    [self requestDataForMe];
}

#pragma mark - Views customization

- (UIView *)calendarBuildMenuItemView:(JTCalendarManager *)calendar
{
    UILabel *label = [UILabel new];
    
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"Helvetica" size:18];
    
    return label;
}

- (void)calendar:(JTCalendarManager *)calendar prepareMenuItemView:(UILabel *)menuItemView date:(NSDate *)date
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"yyyy年-M月";
        
        dateFormatter.locale = _calendarManager.dateHelper.calendar.locale;
        dateFormatter.timeZone = _calendarManager.dateHelper.calendar.timeZone;
    }
    
    menuItemView.text = [dateFormatter stringFromDate:date];
}

- (UIView<JTCalendarWeekDay> *)calendarBuildWeekDayView:(JTCalendarManager *)calendar
{
    JTCalendarWeekDayView *view = [JTCalendarWeekDayView new];
    
    for(UILabel *label in view.dayViews){
        label.textColor = [UIColor blackColor];
        label.font = [UIFont fontWithName:@"Helvetica" size:15];
    }
    
    return view;
}

- (UIView<JTCalendarDay> *)calendarBuildDayView:(JTCalendarManager *)calendar
{
    JTCalendarDayView *view = [JTCalendarDayView new];
    
    view.textLabel.font = [UIFont fontWithName:@"Helvetica" size:17.5];
    
    view.circleRatio = .8;
    view.dotRatio = 1. / .9;
    
    return view;
}

#pragma mark - Fake data

// Used only to have a key for _eventsByDate
- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"yyyy年-M月-dd日";
    }
    
    return dateFormatter;
}

- (BOOL)haveEventForDay:(NSDate *)date
{
    NSString *key = [[self dateFormatter] stringFromDate:date];
    
    if(_eventsByDate[key] && [_eventsByDate[key] count] > 0){
        return YES;
    }
    
    return NO;
    
}

- (void)createRandomEvents
{
    _eventsByDate = [NSMutableDictionary new];
    
    for(int i = 0; i < 30; ++i){
        // Generate 30 random dates between now and 60 days later
        NSDate *randomDate = [NSDate dateWithTimeInterval:(rand() % (3600 * 24 * 60)) sinceDate:[NSDate date]];
        
        // Use the date as key for eventsByDate
        NSString *key = [[self dateFormatter] stringFromDate:randomDate];
        
        if(!_eventsByDate[key]){
            _eventsByDate[key] = [NSMutableArray new];
        }
        
        [_eventsByDate[key] addObject:randomDate];
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


- (IBAction)ToView:(UIButton *)sender {
    _tagView.hidden = NO;
}

- (IBAction)deleteTagCloud:(UIButton *)sender {
    [self.tagListView.tags removeObjectsInArray:self.tagListView.seletedTags];
    [self.tagListView.seletedTags removeAllObjects];
    [self.tagListView.collectionView reloadData];
//    [self.tagListView setCompletionBlockWithSeleted:^(NSInteger index) {
//        [self.tagListView.tags removeObjectsInArray:self.tagListView.seletedTags];
//    }];
//    for (int i = 0; i < _objectsForShow.count; i ++) {
//        if ([_targetArray containsObject:[NSString stringWithFormat:@"%d", i]]) {
//            PFObject *obj = [_objectsForShow objectAtIndex:i];
//            [obj deleteInBackground];
//            [_targetArray removeObject:[NSString stringWithFormat:@"%d", i]];
//        }
//    }
    for (NSString *index in _targetArray) {
        PFObject *obj = [_objectsForShow objectAtIndex:[index integerValue]];
        [obj deleteInBackground];
        [_targetArray removeObject:index];
    }
}

- (IBAction)cancel:(UIButton *)sender {
    
    _tagView.hidden = YES;
}

- (IBAction)menuAction:(UIBarButtonItem *)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"leftSwitch" object:self];
}
-(void)dealloc
{
    
}
@end
