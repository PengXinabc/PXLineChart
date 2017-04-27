//
//  PXXview.h
//  PXLineChart
//
//  Created by Xin Peng on 17/4/13.
//  Copyright © 2017年 EB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PXLineChartView.h"

@interface PXXview : UIView

@property (nonatomic, strong) NSDictionary *axisAttributes;
@property (nonatomic, weak) id<PXLineChartViewDelegate> delegate;

/**坐标转换
 
 @param xAxisValue x坐标对应的文本text
 
 @return x轴坐标位置
 */
- (CGFloat)pointOfXcoordinate:(NSString *)xAxisValue;

- (void)refresh;
@end
