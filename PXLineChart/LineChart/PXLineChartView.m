//
//  PXLineChartView.m
//  PXLineChart
//
//  Created by Xin Peng on 17/4/12.
//  Copyright © 2017年 EB. All rights reserved.
//

#import "PXLineChartView.h"
#import "PXXview.h"
#import "PXYview.h"
#import "PXChartBackgroundView.h"

@interface PXLineChartView ()


@property (nonatomic, strong) NSDictionary *axisAttributes;
@property (nonatomic, strong) PXXview *xAxisView;
@property (nonatomic, strong) PXYview *yAxisView;
@property (nonatomic, strong) PXChartBackgroundView *chartBackgroundView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) CGFloat yWidth;
@property (nonatomic, assign) CGFloat xHeight;
@property (nonatomic, assign) CGFloat xInterval;
@property (nonatomic, assign) CGFloat xElements;

@end

#pragma mark - 

@implementation PXLineChartView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
        [self setupView];
    return self;
}

- (void)setupView {
    
    _yWidth = 50;
    _xHeight = 30;
    _xInterval = 50;
    
    _xAxisView = PXXview.new;
    _yAxisView = PXYview.new;
    _chartBackgroundView = [[PXChartBackgroundView alloc] initWithXaxisView:_xAxisView yAxisView:_yAxisView];
    _scrollView = UIScrollView.new;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.bounces = NO;
    _xAxisView.translatesAutoresizingMaskIntoConstraints = NO;
    _yAxisView.translatesAutoresizingMaskIntoConstraints = NO;
    _chartBackgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addSubview:_yAxisView];
    [self addSubview:_scrollView];
    [self.scrollView addSubview:_xAxisView];
    [self.scrollView addSubview:_chartBackgroundView];
    
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setupInitialConstraints];
}

- (void)setDelegate:(id<PXLineChartViewDelegate>)delegate {
    _delegate = delegate;
    _yAxisView.delegate = self.delegate;
    _xAxisView.delegate = self.delegate;
    _chartBackgroundView.delegate = self.delegate;
    if (_delegate && [_delegate respondsToSelector:@selector(lineChartViewAxisAttributes)]) {
        _yAxisView.axisAttributes = [_delegate lineChartViewAxisAttributes];
        _xAxisView.axisAttributes = [_delegate lineChartViewAxisAttributes];
        _chartBackgroundView.axisAttributes = [_delegate lineChartViewAxisAttributes];
        _axisAttributes = [_delegate lineChartViewAxisAttributes];
    }
}

- (void)setupInitialConstraints {
    [self clearSubConstraints:self];
    NSDictionary *viewsDict = NSDictionaryOfVariableBindings(_scrollView,_xAxisView,_yAxisView,_chartBackgroundView);//
    if (_axisAttributes[yMargin]) {
        _yWidth = [_axisAttributes[yMargin] floatValue];
    }
    if (_axisAttributes[xMargin]) {
        _xHeight = [_axisAttributes[xMargin] floatValue];
    }
    if (_axisAttributes[xElementInterval]) {
        _xInterval = [_axisAttributes[xElementInterval] floatValue];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(numberOfElementsCountWithAxisType:)]) {
        _xElements = [_delegate numberOfElementsCountWithAxisType:AxisTypeX];
    }
    CGFloat scrollHeight = CGRectGetHeight(self.frame);
    CGFloat scrollWidth = CGRectGetWidth(self.frame)-_yWidth;
    CGFloat yHeight = CGRectGetHeight(self.frame)-_xHeight;
    CGFloat xWidth = CGRectGetWidth(self.frame)-_yWidth;
    if (xWidth<(_xElements+1)*_xInterval) {
        xWidth=(_xElements+1)*_xInterval;
    }
    _scrollView.contentSize = CGSizeMake(xWidth, scrollHeight);
    
    NSDictionary *metrics = @{@"yWidth": @(_yWidth),
                              @"xWidth": @(xWidth),
                              @"xHeight": @(_xHeight),
                              @"yHeight": @(yHeight),
                              @"scrollHeight": @(scrollHeight),
                              @"scrollWidth": @(scrollWidth),
                              };
    
    [self addConstraints:[NSLayoutConstraint
                                constraintsWithVisualFormat:
                                @"H:|[_yAxisView(==yWidth)][_scrollView]|"
                                options:0
                                metrics:metrics
                                views:viewsDict]];
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:
                          @"V:|[_scrollView(==scrollHeight)]"
                          options:0
                          metrics:metrics
                          views:viewsDict]];
    
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:
                          @"V:|[_yAxisView(==yHeight)]|"
                          options:0
                          metrics:metrics
                          views:viewsDict]];
    [_scrollView addConstraints:[NSLayoutConstraint
                                 constraintsWithVisualFormat:
                                 @"H:|[_xAxisView(==xWidth)]|"
                                 options:0
                                 metrics:metrics
                                 views:viewsDict]];
    
    [_scrollView addConstraints:[NSLayoutConstraint
                                 constraintsWithVisualFormat:
                                 @"H:|[_chartBackgroundView(==xWidth)]"
                                 options:0
                                 metrics:metrics
                                 views:viewsDict]];
    [_scrollView addConstraints:[NSLayoutConstraint
                                 constraintsWithVisualFormat:
                                 @"V:|[_chartBackgroundView(==yHeight)][_xAxisView(==xHeight)]|"
                                 options:0
                                 metrics:metrics
                                 views:viewsDict]];
  
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentSize.width-CGRectGetWidth(self.scrollView.frame), 0)];

    [self scrollAnimationIfcanScroll];
}

-(void)clearSubConstraints: (UIView *)targetView {
    if (targetView != self) {
        [NSLayoutConstraint deactivateConstraints:targetView.constraints];
    }
    for (UIView *subView in targetView.subviews) {
        [self clearSubConstraints:subView];
    }
}

- (void)scrollAnimationIfcanScroll {
    [self.layer removeAllAnimations];
    [self.scrollView.layer removeAllAnimations];
    float duration = 0.5;
    if (_axisAttributes[scrollAnimationDuration]) {
        duration = [_axisAttributes[scrollAnimationDuration] floatValue];
    }
    if ([_axisAttributes[scrollAnimation] boolValue] && self.scrollView.contentSize.width > CGRectGetWidth(self.scrollView.frame)) {
        [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            [self.scrollView setContentOffset:CGPointMake(0,0)];
            
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)reloadData {
    [self setNeedsLayout];
    [self layoutIfNeeded];
    [_xAxisView refresh];
    [_yAxisView refresh];
    [_chartBackgroundView refresh];
}

@end
