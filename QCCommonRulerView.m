//
//  QCCommonRulerView.m
//  Records
//
//  Created by Cyfuer on 2019/12/14.
//  Copyright © 2019 DuoRong Technology Co., Ltd. All rights reserved.
//

#import "QCCommonRulerView.h"

@interface QCCommonRulerView ()<UIScrollViewDelegate>
/**
 锚点视图，锚点信息
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *anchorViewWdith;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *anchorViewHeight;
@property (weak, nonatomic) IBOutlet UIView *anchorView;


/**
 三角形
 */
@property (weak, nonatomic) IBOutlet UIImageView *trangleImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trangleHeight; // 如果没有三角形为0

@property (strong, nonatomic) IBOutlet UIView *containerView;

/**
 尺子容器展示
 */
@property (weak, nonatomic) IBOutlet UIScrollView *rulerContainer;

@property (nonatomic, strong) NSMutableArray *lines;
@property (nonatomic, strong) NSMutableArray <UILabel *> *bottomLabels;   // 底部标签数值

/**
 上一次索引
 */
@property (nonatomic, assign) NSInteger lastIndex;
@end

@implementation QCCommonRulerView


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
    
    // 初始化信息
    [self layoutIfNeeded];
    
    _minValue = 0;
    _maxValue = 5;
    _minimumScale = 0.5;
    _minimumScaleWidth = 10;
    
    _showBottomLabel = YES;
    _bottomLabelColor = kColorFromRGB(0xA5A5A8);
    _bottomLabelFontSize = 15.0f;
    
    _isShowAnchorView = NO;
    _anchorViewColor = UIColor.redColor;
    
    _isShowGradient = YES;
    _currentValue = _minValue;
    _rulerBackColor = UIColor.clearColor;
    
    _mainLineColor = kColorFromRGB(0x29282B);
    _viceLineColor = kColorFromRGB(0xDFDFDF);
    
    _mainLineWidth = 2;
    _viceLineWidth = 1.5;
    
    _mainLineHeight = 30;
    _viceLineHeight = 15;
    
    _numberScalesOfPerMainScale = 10;

    self.rulerContainer.delegate = self;
    
    kWeakSelf
    // 监听contentOffset改变
    [self bk_addObserverForKeyPath:@"rulerContainer.contentOffset" task:^(id target) {
        [weakSelf updateLines];
    }];
    
}

- (void)startDrawRulerView {
    // 开始绘制视图
    [self drawRuler];
}

- (void)dealloc {
    [self bk_removeAllBlockObservers];
}


#pragma mark - delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offSetX = scrollView.contentOffset.x + self.frame.size.width / 2;
    
    if (offSetX < 0 || offSetX > self.lines.count * self.minimumScaleWidth) {
        DLog(@"超出区域范围，不再展示");
        return;
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    // 获取索引位置
    
    CGFloat offsetX = scrollView.contentOffset.x + self.bounds.size.width / 2.0f;   // 加上左右的偏移量
 
    NSInteger index = (int)roundf(offsetX / self.minimumScaleWidth);
    
    if (index < 0) {
        index = 0;
    }
    
    CGFloat maxIndex = self.lines.count - 1;        // 多出一个刻度展示
    if (index >= maxIndex) {
        index = maxIndex;
    }
    
    CGFloat newOffsetX = index * self.minimumScaleWidth;
    //    NSLog(@"当前的位置为：%ld 旧位置为：%.2f 新位置为：%2.f",value, offSetX, newOffsetX);
    
    CGPoint endPoint = CGPointMake(newOffsetX - self.bounds.size.width/2.0f, 0);
    *targetContentOffset = endPoint;
    
    if (self.lastIndex != index) {
        // 返回得到的位置索引
        CGFloat value = index *self.minimumScale + self.minValue;
        if (value > self.maxValue) {
            value = self.maxValue;
        }
        if (value < self.minValue) {
            value = self.minValue;
        }
        _currentValue = value;
        DR_SAFE_BLOCK(self.didSelectedCurrentValue, value);
        
        DLog(@"当前选中的刻度为:%.2f",value);
        self.lastIndex = index;
    }
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self drawRuler];
}

#pragma mark - 绘制尺子

- (void)drawRuler {
    
    if (self.maxValue <= 0) {
        return;
    }
    [self.rulerContainer.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.lines removeAllObjects];
    [self.bottomLabels removeAllObjects];
    
    // 计算小格子的数量
    NSInteger numberOfScale = self.numberScalesOfPerMainScale;
    NSInteger totalLines = (self.maxValue - self.minValue) * 1/self.minimumScale;
    
    for (int i = 0; i <= totalLines; i++) {
        UIView *lineV = [[UIView alloc] init];
        lineV.layer.cornerRadius = 1.5;
        lineV.layer.masksToBounds = YES;
        
        if (i % numberOfScale == 0) {  // 长线
            CGFloat x = self.minimumScaleWidth * i - self.mainLineWidth/2;    // 宽度为3
            
            CGFloat y = self.type == QCommonRuleScalePositionTop ? 0 : (self.rulerContainer.height - self.mainLineHeight) / 2;
            
            lineV.frame = CGRectMake(x , y, self.mainLineWidth, self.mainLineHeight);
            lineV.backgroundColor = self.mainLineColor;
            
            if (self.showBottomLabel) {
                // 添加刻度值信息
                UILabel *label = [[UILabel alloc] init];
                [self.bottomLabels addObject:label];
                label.font = [UIFont dr_PingFangSC_RegularWithSize:self.bottomLabelFontSize];
                label.textColor = self.bottomLabelColor;
                label.textAlignment = NSTextAlignmentCenter;
                label.text = [NSString stringWithFormat:@"%ld",(long)(self.minValue + i * self.minimumScale)];
                
                CGFloat width = 50;
                CGFloat height = 20;
                label.frame = CGRectMake(self.minimumScaleWidth * i - width/2, self.rulerContainer.height - height, width, height);
                [self.rulerContainer addSubview:label];
            }
            
        }  else {   // 短线
            CGFloat x = self.minimumScaleWidth * i - self.viceLineWidth/2;    // 宽度为3
            CGFloat y = self.type == QCommonRuleScalePositionCenter ? (self.rulerContainer.height - self.viceLineHeight) / 2 : 0;
            lineV.frame = CGRectMake(x , y, self.viceLineWidth, self.viceLineHeight);
            lineV.backgroundColor = self.viceLineColor;
        }
        
        
        [self.lines addObject:lineV];
        [self.rulerContainer addSubview:lineV];
    }
    
    self.rulerContainer.contentInset = UIEdgeInsetsMake(0, self.bounds.size.width/2.0f, 0,   self.bounds.size.width / 2.0f);
    self.rulerContainer.contentSize = CGSizeMake(totalLines * self.minimumScaleWidth,0);
    
    // 默认初始化
    // 滑动到指定位置，需要放到布局完成后
    NSInteger index = (self.currentValue - self.minValue) / self.minimumScale;
    CGFloat offsetX = index * self.minimumScaleWidth  - self.bounds.size.width/2.0f;
    self.rulerContainer.contentOffset = CGPointMake(offsetX, 0);
    
    // 锚点处理
    self.anchorViewWdith.constant = self.mainLineWidth;
    self.anchorViewHeight.constant = self.mainLineHeight;
}


- (void)updateLines {
    
    if (!self.isShowGradient) {
        return;
    }
    
    for (int i = 0; i < self.lines.count; i++) {
        UIView *lineV = self.lines[i];
        CGFloat distance = fabs(self.rulerContainer.contentOffset.x + self.size.width/2.0 - lineV.centerX);
        if (distance > 120) {
            lineV.alpha = 0;
        } else {
            lineV.alpha = 1 - (distance / 120);
        }
    }
    
    for (int i = 0; i< self.bottomLabels.count; i++) {
        UIView *lineV = self.bottomLabels[i];
        CGFloat distance = fabs(self.rulerContainer.contentOffset.x + self.size.width/2.0 - lineV.centerX);
        if (distance > 120) {
            lineV.alpha = 0;
        } else {
            lineV.alpha = 1 - (distance / 120);
        }
    }
}


#pragma mark - setter & getter

- (void)setTriangleImage:(UIImage *)triangleImage {
    _triangleImage = triangleImage;
    self.trangleImageView.image = _triangleImage;
    self.trangleHeight.constant = _triangleImage ? 19 : 0;
}

- (CGFloat)minimumScale {
    if (_minimumScale <= 0) {
        _minimumScale = 0.5;
    }
    return _minimumScale;
}

- (NSMutableArray *)lines {
    if (!_lines) {
        _lines = @[].mutableCopy;
    }
    return _lines;
}

- (NSMutableArray<UILabel *> *)bottomLabels {
    if (!_bottomLabels) {
        _bottomLabels = @[].mutableCopy;
    }
    return _bottomLabels;
}

- (void)setIsShowAnchorView:(BOOL)isShowAnchorView {
    _isShowAnchorView = isShowAnchorView;
    // 锚点处理
    self.anchorView.hidden = !_isShowAnchorView;
}

- (void)setAnchorViewColor:(UIColor *)anchorViewColor {
    _anchorViewColor = anchorViewColor;
    self.anchorView.backgroundColor = _anchorViewColor;
}

- (void)setRulerBackColor:(UIColor *)rulerBackColor {
    _rulerBackColor = rulerBackColor;
    self.rulerContainer.backgroundColor = _rulerBackColor;
}
@end
