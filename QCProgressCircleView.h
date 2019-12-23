//
//  QCProgressCircleView.h
//  Records
//
//  Created by Cyfuer on 2019/12/16.
//  Copyright © 2019 DuoRong Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface QCProgressCircleView : UIView

/**
 底色 #E8EAED
 */
@property (nonatomic, strong) UIColor * backColor;

/**
 前景色 #00CF87
 */
@property (nonatomic, strong) UIColor * forgroundColor;

/**
 进度信息
 */
@property (nonatomic, assign) CGFloat progress;

/**
 进度条宽度,样式为4
 */
@property (nonatomic, assign) CGFloat width;

/**
 标题信息，字体颜色与前景色保持一致
 字体信息，默认为中粗体14号
 */
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIFont *titleFont;

@end
