//
//  PXChartBackgroundView.m
//  PXLineChart
//
//  Created by Xin Peng on 17/4/13.
//  Copyright © 2017年 EB. All rights reserved.
//

#import "PXChartBackgroundView.h"
#import "PXXview.h"
#import "PXYview.h"
#import <objc/runtime.h>

@interface UIButton (Touch)

- (void)actionWithEvent:(UIControlEvents)event withBlock:(void(^)(id sender))block;

@end

@implementation UIButton (Touch)

static char OperationKey;

- (void)actionWithEvent:(UIControlEvents)event withBlock:(void(^)(id sender))block {
    
    objc_setAssociatedObject(self, &OperationKey, block, OBJC_ASSOCIATION_RETAIN);
    
    [self addTarget:self action:@selector(callActionBlock:) forControlEvents:event];
    
}

- (void)callActionBlock:(UIButton *)sender {
    
    void(^block)(id sender) = objc_getAssociatedObject(self, &OperationKey);
    
    if (block) block(self);
    
}

@end

@interface PXChartBackgroundView ()

@property (nonatomic, strong) PXXview *xAxisView;
@property (nonatomic, strong) PXYview *yAxisView;
@end

#pragma mark - 

@implementation PXChartBackgroundView

- (instancetype)initWithXaxisView:(PXXview *)xAxisView  yAxisView:(PXYview *)yAxisView {
    
    if (self == [super init]) {
        _xAxisView = xAxisView;
        _yAxisView = yAxisView;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self drawLineAndPointsInRect:rect];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.opaque = NO;
}

- (void)setDelegate:(id<PXLineChartViewDelegate>)delegate {
    _delegate = delegate;
}

- (void)drawLineAndPointsInRect:(CGRect)rect {
    //y轴元素个数
    NSUInteger yCon = [_delegate numberOfElementsCountWithAxisType:AxisTypeY];
    BOOL isPointHide = NO;
    if (_axisAttributes[pointHide]) {
        isPointHide = [_axisAttributes[gridHide] boolValue];
    }
    BOOL isGridHide = NO;
    if (_axisAttributes[gridHide]) {
       isGridHide = [_axisAttributes[gridHide] boolValue];
    }
    if (!isGridHide) {//
        CGRect oldSeparateViewFrame = CGRectZero;
        for (int i = 0; i < yCon; i++) {
            UILabel *yElementlab = [_delegate elementWithAxisType:AxisTypeY index:i];
            CGFloat pointY = [_yAxisView pointOfYcoordinate:yElementlab.text];
            CGRect newRect = CGRectZero;
            if (i!=0) {
                newRect = CGRectOffset(oldSeparateViewFrame, 0, -_yAxisView.yElementInterval);
            }else{
                newRect = CGRectMake(0, pointY, CGRectGetWidth(self.frame), _yAxisView.yElementInterval);
            }
            UIColor *fillcolor = _axisAttributes[gridColor];
            if (!fillcolor) {
                fillcolor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
            }
            if (fillcolor) {
                if (i % 2 == 0) {
                    [[UIColor clearColor] setFill];
                }else{
                    [fillcolor setFill];
                }
            }
            UIBezierPath *rectPath = [UIBezierPath bezierPathWithRect:newRect];
            [rectPath fill];
            oldSeparateViewFrame = newRect;
        }
    }
    
    NSUInteger lines = 0;
    if (_delegate && [_delegate respondsToSelector:@selector(numberOfChartlines)]) {
        lines = [_delegate numberOfChartlines];
    }
    for (int i = 0; i < lines; i++) {
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        UIBezierPath *path = [[UIBezierPath alloc] init];
        CGContextSetLineWidth(ctx, 0.5);
        NSArray<id<PointItemProtocol>> *points = nil;
        if (_delegate && [_delegate respondsToSelector:@selector(plotsOflineIndex:)]) {
            points = [_delegate plotsOflineIndex:i];
        }
        id<PointItemProtocol> startPointItem = points.firstObject;
        CGFloat startX = 0.0;
        CGFloat startY = 0.0;
        if ([startPointItem respondsToSelector:@selector(px_pointXvalue)]) {
            startX = [_xAxisView pointOfXcoordinate:[startPointItem px_pointXvalue]];
        }
        if ([startPointItem respondsToSelector:@selector(px_pointYvalue)]) {
            startY = [_yAxisView pointOfYcoordinate:[startPointItem px_pointYvalue]];
        }
        UIColor *strokeColor = [UIColor greenColor];
        if ([startPointItem respondsToSelector:@selector(px_chartLineColor)]) {
            strokeColor = [startPointItem px_chartLineColor];
        }
        [strokeColor set];
        CGPoint start = CGPointMake(startX,startY);
        [path moveToPoint:start];
        for (int j = 0; j < points.count; j++) {
            id<PointItemProtocol> pointItem = points[j];
            CGFloat pointCenterX = 0.0;
            CGFloat pointCenterY = 0.0;
            NSString *pointXvalue = @"";
            NSString *pointYvalue = @"";
            if ([pointItem respondsToSelector:@selector(px_pointXvalue)]) {
                pointXvalue = [pointItem px_pointXvalue];
                pointCenterX = [_xAxisView pointOfXcoordinate:pointXvalue];
            }
            if ([pointItem respondsToSelector:@selector(px_pointYvalue)]) {
                pointYvalue = [pointItem px_pointYvalue];
                pointCenterY = [_yAxisView pointOfYcoordinate:pointYvalue];
            }
            UIButton *pointButton = nil;
            __weak typeof(self) weakSelf = self;
            if (!isPointHide) {
                pointButton = [[UIButton alloc] init];
                pointButton.tag = j;
                UIColor *pointColor = [UIColor redColor];
                if ([pointItem respondsToSelector:@selector(px_chartPointColor)]) {
                    pointColor = [pointItem px_chartPointColor];
                }
                [pointButton setBackgroundColor:pointColor];
                CGSize pSize = CGSizeMake(6, 6);
                if ([pointItem respondsToSelector:@selector(px_pointSize)]) {
                    pSize = [pointItem px_pointSize];
                }
                pointButton.frame = CGRectMake(0, 0, pSize.width, pSize.height);
                pointButton.center = CGPointMake(pointCenterX, pointCenterY);
                pointButton.layer.cornerRadius = MIN(pSize.width, pSize.height)/2;
                pointButton.layer.masksToBounds = YES;
                pointButton.userInteractionEnabled = YES;
                [pointButton actionWithEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
                    [weakSelf pointDidSelect:i subIndex:j];
                }];
                [self addSubview:pointButton];
            }
            
            UIFont *pFont = [UIFont systemFontOfSize:12];
            if (_axisAttributes[pointFont]) {
                pFont = _axisAttributes[pointFont];
            }
            NSDictionary *attr = @{NSFontAttributeName : pFont};
            CGSize buttonSize = [pointYvalue sizeWithAttributes:attr];
            UIButton *titlebutton = [[UIButton alloc] init];
            [titlebutton setTitle:pointYvalue forState:UIControlStateNormal];
            UIColor *titleColor = [UIColor grayColor];
            if ([pointItem respondsToSelector:@selector(px_pointValueColor)]) {
                titleColor = [pointItem px_pointValueColor];
            }
            [titlebutton setTitleColor:titleColor forState:UIControlStateNormal];
            titlebutton.titleLabel.font = pFont;
            titlebutton.backgroundColor = [UIColor clearColor];
            titlebutton.tag = j;
            titlebutton.userInteractionEnabled = YES;
            
            titlebutton.frame = CGRectMake(pointCenterX - buttonSize.width/2,
                                           pointCenterY - CGRectGetHeight(pointButton.frame)/2-5-buttonSize.height,
                                           buttonSize.width,
                                           buttonSize.height);
            [titlebutton actionWithEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
                [weakSelf pointDidSelect:i subIndex:j];
            }];
            [self addSubview:titlebutton];
            
            //draw lines
            [path addLineToPoint:CGPointMake(pointCenterX, pointCenterY)];
            
        }
        CGContextAddPath(ctx, path.CGPath);
        CGContextStrokePath(ctx);
    }
    
}

- (void)pointDidSelect:(NSUInteger)superIndex subIndex:(NSUInteger)subIndex {
    if (_delegate && [_delegate respondsToSelector:@selector(elementDidClickedWithPointSuperIndex:pointSubIndex:)]) {
        [_delegate elementDidClickedWithPointSuperIndex:superIndex pointSubIndex:subIndex];
    }
}
@end
