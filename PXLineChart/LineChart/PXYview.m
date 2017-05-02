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
@property (strong, nonatomic) NSString *firstYvalue;
@property (strong, nonatomic) NSString *lastYvalue;
@end

#pragma mark - 

@implementation PXYview

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self == [super initWithFrame:frame]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    _yElementInterval = 40;
    _ylineView = UIView.new;
    _ylineView.backgroundColor = [UIColor grayColor];
    _firstYvalue = @"0";
    _lastYvalue = @"0";
}

- (void)reset {
    _perPixelOfYvalue = -1;
}

- (void)setDelegate:(id<PXLineChartViewDelegate>)delegate {
    _delegate = delegate;
}

- (void)reloadYaxis {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self reset];
    self.ylineView.frame = CGRectMake(CGRectGetWidth(self.frame) - 1, 0, 1, CGRectGetHeight(self.frame));
    [self addSubview:self.ylineView];
    if (self.axisAttributes[xAxisColor]) {
        self.ylineView.backgroundColor = self.axisAttributes[xAxisColor];
    }
    NSUInteger elementCons = 0;
    if (_delegate && [_delegate respondsToSelector:@selector(numberOfElementsCountWithAxisType:)]) {
        elementCons = [_delegate numberOfElementsCountWithAxisType:AxisTypeY];
    }
    NSUInteger firstIndex = 1;
    for (int i = 0; i < elementCons; i++) {
        UILabel *elementView = [[UILabel alloc] init];
        if (_delegate && [_delegate respondsToSelector:@selector(elementWithAxisType:index:)]) {
            elementView = (UILabel *)[_delegate elementWithAxisType:AxisTypeY index:i];
        }
        NSDictionary *attr = @{NSFontAttributeName : elementView.font};
        CGSize elementSize = [@"y" sizeWithAttributes:attr];
        if ([_axisAttributes[firstYAsOrigin] boolValue]) {
            firstIndex = 0;
        }
        elementView.frame = CGRectMake(0,
                                       CGRectGetHeight(self.frame)-((elementSize.height/2)+_yElementInterval*(i+firstIndex)),
                                       CGRectGetWidth(self.frame)-5,
                                       elementSize.height);
        if(i == 0 && [_axisAttributes[firstYAsOrigin] boolValue]) _firstYvalue = elementView.text;
        if(i == elementCons - 1) _lastYvalue = elementView.text;
        [self addSubview:elementView];
    }
    if ([_firstYvalue length] && [_lastYvalue length]) {
        if (_lastYvalue.floatValue && _firstYvalue.floatValue >=0 && (_lastYvalue.floatValue > _firstYvalue.floatValue)) {
            _perPixelOfYvalue = _yElementInterval*(elementCons-1+firstIndex)/(_lastYvalue.floatValue - _firstYvalue.floatValue);
        }
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
    return CGRectGetHeight(self.frame)-(yAxisValue.floatValue - _firstYvalue.floatValue)*_perPixelOfYvalue;
}

- (void)refresh {
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

@end
