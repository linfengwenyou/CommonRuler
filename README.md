# CommonRuler

### 使用方式

```
 		self.heightRulerView.minValue = 100;
    self.heightRulerView.maxValue = 250;
    self.heightRulerView.minimumScale = 1;
    self.heightRulerView.numberScalesOfPerMainScale = 10;
    
    self.weightRulerView.minValue = 25;
    self.weightRulerView.maxValue = 250;
    self.weightRulerView.minimumScale = 0.1;
    self.heightRulerView.numberScalesOfPerMainScale = 10;
    
    
    // 初始值
    self.weightRulerView.currentValue = 60;
    self.heightRulerView.currentValue = 160;
    
    
    [self.heightRulerView startDrawRulerView];
    [self.weightRulerView startDrawRulerView];
    
    
    self.weightLabel.text = @"60";
    self.heightLabel.text = @"160";
    
    kWeakSelf
    
    self.weightRulerView.didSelectedCurrentValue = ^(CGFloat value) {
        weakSelf.weightLabel.text = [NSString stringWithFormat:@"%.1f",value];
    };
    
    self.heightRulerView.didSelectedCurrentValue = ^(CGFloat value) {
        weakSelf.heightLabel.text = [NSString stringWithFormat:@"%.0f",value];
    };
    
```

