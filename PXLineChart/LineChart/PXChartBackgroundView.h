//
//  PXChartBackgroundView.h
//  PXLineChart
//
//  Created by Xin Peng on 17/4/13.
//  Copyright © 2017年 EB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PXLineChartView.h"

@class PXXview,PXYview;
@interface PXChartBackgroundView : UIView

@property (nonatomic, weak) id<PXLineChartViewDelegate> delegate;
@property (nonatomic, strong) NSDictionary *axisAttributes;


- (instancetype)initWithXaxisView:(PXXview *)xAxisView
                        yAxisView:(PXYview *)yAxisView;

- (void)refresh;
@end
