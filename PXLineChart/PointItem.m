//
//  PointItem.m
//  PXLineChart
//
//  Created by Xin Peng on 17/4/15.
//  Copyright © 2017年 EB. All rights reserved.
//

#import "PointItem.h"
#import "PointItemProtocol.h"

@interface PointItem() <PointItemProtocol>

@end

@implementation PointItem

#pragma PointItemProtocol

- (NSString *)px_pointYvalue {
    return _price;
}
- (NSString *)px_pointXvalue {
    return _time;
}
- (UIColor *)px_chartLineColor {
    return _chartLineColor;
}

- (UIColor *)px_chartPointColor {
    return _chartPointColor;
}

- (UIColor *)px_pointValueColor {
    return _pointValueColor;
}

- (UIColor *)px_chartFillColor {
    return _chartFillColor;
}

- (BOOL)px_chartFill {
    return _chartFill;
}
@end
