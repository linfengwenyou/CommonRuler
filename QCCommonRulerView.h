//
//  QCCommonRulerView.h
//  Records
//
//  Created by Cyfuer on 2019/12/14.
//  Copyright © 2019 DuoRong Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, QCommonRuleScalePosition) {
    QCommonRuleScalePositionTop = 0,                 // 刻度顶部对齐
    QCommonRuleScalePositionCenter,                  // 刻度居中对齐
};

@interface QCCommonRulerView : UIView

#pragma mark - 配置信息
/**
 尺子背景色，默认为透明
 */
@property (nonatomic, strong) UIColor * rulerBackColor;

/**
 最大最小值
 */
@property (nonatomic, assign) CGFloat minValue;
@property (nonatomic, assign) CGFloat maxValue;

/**
 最小刻度，0.1 代表 1 中间有10个小刻度值, 默认为0.5, 最大为1
 */
@property (nonatomic, assign) CGFloat minimumScale;

/**
 每个大刻度有多少个小刻度， 默认为10个
 */
@property (nonatomic, assign) NSInteger numberScalesOfPerMainScale;

/**
 是否显示锚点视图，中心位置的竖线, 默认不显示，颜色默认为红色
 */
@property (nonatomic, assign) BOOL isShowAnchorView;
@property (nonatomic, strong) UIColor * anchorViewColor;

/**
 最小刻度宽度，默认为10
 */
@property (nonatomic, assign) NSInteger minimumScaleWidth;

/**
 箭头，无则不展示时
 */
@property (nonatomic, strong) UIImage *triangleImage;


/**
 线条颜色
 */
@property (nonatomic, strong) UIColor * mainLineColor; // 主线条（大刻度） 0x29282B
@property (nonatomic, strong) UIColor * viceLineColor; // 次线条（小刻度）0xDFDFDF


/**
 线条宽度
 */
@property (nonatomic, assign) CGFloat mainLineWidth;    // 主线条宽度，默认2
@property (nonatomic, assign) CGFloat viceLineWidth;    // 次线条宽度 默认1.5

@property (nonatomic, assign) CGFloat mainLineHeight;    // 主线条高度 默认为30
@property (nonatomic, assign) CGFloat viceLineHeight;    // 次线条高度 默认为15

/**
 是否显示底部值，默认为YES
 */
@property (nonatomic, assign) BOOL showBottomLabel;
@property (nonatomic, strong) UIColor * bottomLabelColor;
@property (nonatomic, assign) CGFloat bottomLabelFontSize;


/**
 是否中间突出展示，两边展示渐变
 */
@property (nonatomic, assign) BOOL isShowGradient;

/**
 当前值
 */
@property (nonatomic, assign) CGFloat currentValue;

/**
 block使用 返回当前值
 */
@property (nonatomic, copy) void (^didSelectedCurrentValue)(CGFloat value);
/**
 刻度对齐方式, 默认顶部对齐
 */
@property (nonatomic, assign) QCommonRuleScalePosition type;

#pragma mark - 使用展示
/**
 开始绘制展示
 */
- (void)startDrawRulerView;
@end

NS_ASSUME_NONNULL_END
