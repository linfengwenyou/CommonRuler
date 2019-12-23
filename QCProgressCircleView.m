//
//  QCProgressCircleView.m
//  Records
//
//  Created by Cyfuer on 2019/12/16.
//  Copyright © 2019 DuoRong Technology Co., Ltd. All rights reserved.
//

#import "QCProgressCircleView.h"

@interface QCProgressCircleView ()
/**
 标签信息
 */
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@property (strong, nonatomic) IBOutlet UIView *containerView;

/**
 底景图
 */
@property (nonatomic, strong) CAShapeLayer *circleBackLayer;

/**
 前景图
 */
@property (nonatomic, strong) CAShapeLayer *circleForeGroundLayer;
@end

@implementation QCProgressCircleView


- (instancetype)init {
    if (self = [super init]) {
        [self initSubViews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initSubViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    if (!self.containerView) {  // containerView为最外层容器
        self.containerView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].firstObject;
        [self addSubview:self.containerView];
        [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.mas_offset(0);
        }];
    }
    
    [self layoutIfNeeded];
    _backColor = kColorFromRGB(0xE8EAED);
    _forgroundColor = kColorFromRGB(0x00CF87);
    _width = 4;
    _progress = 0.5;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self drawCircleView];
}

/**
 环形进度条视图展示
 */
- (void)drawCircleView {
    
    // 环, M_PI_2 开始滑动
    
    [self.circleBackLayer removeFromSuperlayer];
    [self.circleForeGroundLayer removeFromSuperlayer];
    
    
    CGFloat minWidth = MIN(self.containerView.width, self.containerView.height);
    
    CGFloat cornerRadius = minWidth / 2.0f - self.width;
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:self.containerView.center radius:cornerRadius startAngle:-M_PI_2 endAngle:M_PI_2*3 clockwise:YES];

    // 环形layer，底图，没有进度的颜色显示此
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    circleLayer.fillColor = [UIColor clearColor].CGColor;
    circleLayer.strokeColor = self.backColor.CGColor;
    circleLayer.lineWidth = self.width;
    circleLayer.path = circlePath.CGPath;
    circleLayer.strokeEnd = 1;
//    circleLayer.magnificationFilter = kCAFilterNearest;
    circleLayer.contentsScale = [UIScreen mainScreen].scale;
    [self.layer addSublayer:circleLayer];
    self.circleBackLayer = circleLayer;


    // 环形进度layer
    CAShapeLayer *progressLayer = [CAShapeLayer layer];
    progressLayer.fillColor = [UIColor clearColor].CGColor;
    progressLayer.strokeColor = self.forgroundColor.CGColor;
    progressLayer.lineCap = kCALineCapRound;
    progressLayer.lineWidth = self.width;
    progressLayer.path = circlePath.CGPath;
//    progressLayer.magnificationFilter = kCAFilterNearest;
    progressLayer.contentsScale = [UIScreen mainScreen].scale;
    progressLayer.strokeEnd = self.progress;
    [self.layer addSublayer:progressLayer];
    self.circleForeGroundLayer = progressLayer;
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    if (_progress < 0) {
        _progress = 0;
    }
    if (_progress > 1) {
        _progress = 1;
    }
    
    self.circleForeGroundLayer.strokeEnd = _progress;
}

- (void)setBackColor:(UIColor *)backColor {
    _backColor = backColor;
    self.circleBackLayer.strokeColor = _backColor.CGColor;
}

- (void)setForgroundColor:(UIColor *)forgroundColor {
    _forgroundColor = forgroundColor;
    self.circleForeGroundLayer.strokeColor = _forgroundColor.CGColor;
}


- (void)setTitle:(NSString *)title {
    _title = title;
    self.tipLabel.text = _title;
}

-(void)setTitleFont:(UIFont *)titleFont {
    _titleFont = titleFont;
    [self.tipLabel setFont:titleFont];
}
@end
