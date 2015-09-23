//
//  Constants.h
//  Zhong Rui
//
//  Created by Ziyao on 15/9/8.
//  Copyright (c) 2015年 Ziyao. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

//字体
#define S_Font 27
#define A_Font 17
#define B_Font 15
#define C_Font 13
#define D_Font 11

//颜色函数
#define UIColorFromRGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define UIColorFromRGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a/1.0]
// 随机色
#define HMRandomColor [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1]


//屏幕尺寸
#define UI_SCREEN_W [[UIScreen mainScreen] bounds].size.width
#define UI_SCREEN_H [[UIScreen mainScreen] bounds].size.height

//iOS版本
#define Earlier_Than_IOS_8 ([[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue] < 8.0)
#define Later_Than_IOS_8 ([[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue] >= 8.0)

//UI清理内存
#define FRelease(x) {[x removeFromSuperview]; x = nil;}

#define HMImageCount 6
/**
 * 组标题view的高度
 */
#define SectionViewH 44
/**
 *  背景ScrollView垂直方向初始的偏移距离
 */
#define ScrollViewBOffsetY 70
/**
 *  背景scrollView垂直方向上与tableView垂直方向上移动的系数比
 */
#define ScrollViewB2TableViewYFactor 0.3
/**
 *  pageContorl距离父控件中心的比例
 */
#define ScaleX 0.5
#define ScaleY 0.96
/**
 *  定时器时间间隔
 */
#define TimerDuration 2.0
/**
 *  tableView的额外滚动区域
 */
#define ContentInsetY 19
/**
 *  headView的高度
 */
#define HeadViewH 250
/**
 *  cell的行数
 */
#define CellCount 5
/**
 *  cell的高度
 */
#define CellH 44
/**
 *  自定义导航栏标题字体大小
 */
#define NavTextFont 18
/**
 *  自定义组标题字体大小
 */
#define SectionFont 18
/**
 *  高度常量
 */
#define ConstH 44
/**
 *  导航栏高度+状态栏的高度 = 64
 */
#define NavHAndStautsH 64
/**
 *  headView中显示轮播器对应内容的label的高度
 */
#define HeadViewLabel2ScrollViewB 30
#endif
