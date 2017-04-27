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
    
    NSDictionary *viewsDict = NSDictionaryOfVariableBindings(_scrollView,_xAxisView,_yAxisView,_chartBackgroundView);//
    CGFloat yWidth = 50;
    if (_axisAttributes[yMargin]) {
        yWidth = [_axisAttributes[yMargin] floatValue];
    }
    CGFloat xHeight = 30;
    if (_axisAttributes[xMargin]) {
        xHeight = [_axisAttributes[xMargin] floatValue];
    }
    CGFloat xInterval = 50;
    if (_axisAttributes[xElementInterval]) {
        xInterval = [_axisAttributes[xElementInterval] floatValue];
    }
    NSUInteger xElements = 0;
    if (_delegate && [_delegate respondsToSelector:@selector(numberOfElementsCountWithAxisType:)]) {
        xElements = [_delegate numberOfElementsCountWithAxisType:AxisTypeX];
    }
    CGFloat scrollHeight = CGRectGetHeight(self.frame);
    CGFloat scrollWidth = CGRectGetWidth(self.frame)-yWidth;
    CGFloat yHeight = CGRectGetHeight(self.frame)-xHeight;
    CGFloat xWidth = CGRectGetWidth(self.frame)-yWidth;
    if (xWidth<(xElements+1)*xInterval) {
        xWidth=(xElements+1)*xInterval;
    }
    _scrollView.contentSize = CGSizeMake(xWidth, scrollHeight);
    
    NSDictionary *metrics = @{@"yWidth": @(yWidth),
                              @"xWidth": @(xWidth),
                              @"xHeight": @(xHeight),
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
  

}

- (void)reloadData {
    [_xAxisView refresh];
    [_yAxisView refresh];
    [_chartBackgroundView refresh];
}
@end
