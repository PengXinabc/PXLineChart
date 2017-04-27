//
//  PXYview.m
//  PXLineChart
//
//  Created by Xin Peng on 17/4/13.
//  Copyright © 2017年 EB. All rights reserved.
//

#import "PXYview.h"

@interface PXYview ()


@property (strong, nonatomic) UIView *ylineView;
@property (nonatomic, assign) CGFloat perPixelOfYvalue;// 坐标值/y值
@end

#pragma mark - 

@implementation PXYview

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self == [super initWithFrame:frame]) {
        _yElementInterval = 40;
        _ylineView = UIView.new;
        _ylineView.backgroundColor = [UIColor grayColor];
        _perPixelOfYvalue = -1;
    }
    return self;
}

- (void)setDelegate:(id<PXLineChartViewDelegate>)delegate {
    _delegate = delegate;
}

- (void)reloadYaxis {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.ylineView.frame = CGRectMake(CGRectGetWidth(self.frame) - 1, 0, 1, CGRectGetHeight(self.frame));
    [self addSubview:self.ylineView];
    if (self.axisAttributes[xAxisColor]) {
        self.ylineView.backgroundColor = self.axisAttributes[xAxisColor];
    }
    NSUInteger elementCons = 0;
    if (_delegate && [_delegate respondsToSelector:@selector(numberOfElementsCountWithAxisType:)]) {
        elementCons = [_delegate numberOfElementsCountWithAxisType:AxisTypeY];
    }
    for (int i = 0; i < elementCons; i++) {
        UILabel *elementView = [[UILabel alloc] init];
        if (_delegate && [_delegate respondsToSelector:@selector(elementWithAxisType:index:)]) {
            elementView = (UILabel *)[_delegate elementWithAxisType:AxisTypeY index:i];
        }
        NSDictionary *attr = @{NSFontAttributeName : elementView.font};
        CGSize elementSize = [@"y" sizeWithAttributes:attr];
        elementView.frame = CGRectMake(0,
                                       CGRectGetHeight(self.frame)-((elementSize.height/2)+_yElementInterval*(i+1)),
                                       CGRectGetWidth(self.frame)-5,
                                       elementSize.height);
        if (_perPixelOfYvalue < 0) {
            if ([elementView.text length]) {
                _perPixelOfYvalue = _yElementInterval*(i+1)/([elementView.text floatValue]);
            }
        }
        [self addSubview:elementView];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self reloadYaxis];
}

- (void)setAxisAttributes:(NSDictionary *)axisAttributes {
    _axisAttributes = axisAttributes;
    if (axisAttributes[yElementInterval]) {
        self.yElementInterval = [axisAttributes[yElementInterval] floatValue];
    }
}

- (CGFloat)pointOfYcoordinate:(NSString *)yAxisValue {
    if (![yAxisValue length]) {
        return 0;
    }
    return CGRectGetHeight(self.frame)-[yAxisValue floatValue]*_perPixelOfYvalue;
}

- (void)refresh {
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

@end
