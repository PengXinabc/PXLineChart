//
//  PointItemProtocol.h
//  PXLineChart
//
//  Created by Xin Peng on 17/4/15.
//  Copyright © 2017年 EB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/** 
 model protocol
 */
@protocol PointItemProtocol <NSObject>

@required
- (NSString *)px_pointYvalue; //y坐标值
- (NSString *)px_pointXvalue; //x坐标值

@optional

- (UIColor *)px_chartLineColor;//折线color
- (UIColor *)px_chartPointColor;//point color
- (UIColor *)px_pointValueColor;//
- (CGSize)px_pointSize;//point size
- (UIColor *)px_chartFillColor;////fill color - UIColor
- (BOOL)px_chartFill;//是否fill - NSNumber（@1-fill; @0-不fill）

@end

