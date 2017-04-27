//
//  PXYview.h
//  PXLineChart
//
//  Created by Xin Peng on 17/4/13.
//  Copyright © 2017年 EB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PXLineChartView.h"

@interface PXYview : UIView

@property (nonatomic, strong) NSDictionary *axisAttributes;
@property (nonatomic, weak) id<PXLineChartViewDelegate> delegate;
@property (nonatomic, assign) CGFloat yElementInterval;

/**坐标转换
 
 @param yAxisValue y坐标对应的文本text
 
 @return y轴坐标位置
 */
- (CGFloat)pointOfYcoordinate:(NSString *)yAxisValue;

- (void)refresh;
@end
