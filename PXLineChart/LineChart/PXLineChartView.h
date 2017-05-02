//
//  PXLineChartView.h
//  PXLineChart
//
//  Created by Xin Peng on 17/4/12.
//  Copyright © 2017年 EB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PXLineChartConst.h"
#import "PointItemProtocol.h"

typedef NS_ENUM(NSUInteger, AxisType) {
    AxisTypeY,//y
    AxisTypeX //x
};

@protocol PXLineChartViewDelegate <NSObject>

@required

/**折线个数*/
- (NSUInteger)numberOfChartlines;

/**每条折线对应的points
 
  @param lineIndex index of lines
 
  @return 每条折线对应的数据点，元素必须实现PointItemProtocol协议
 
 */
- (NSArray<id<PointItemProtocol>> *)plotsOflineIndex:(NSUInteger)lineIndex;

/**x轴y轴对应的元素个数
 
  @param axisType x\y type
 
  @return x/y轴对应的元素个数
 
 */
- (NSUInteger)numberOfElementsCountWithAxisType:(AxisType)axisType;

/**x轴y轴对应的元素视图
 
  @param axisType  (AxisTypeY-y轴 AxisTypeX-x轴)
 
  @param index -轴坐标对应的索引
 
  @return x轴y轴对应的元素视图
 
 */
- (UILabel *)elementWithAxisType:(AxisType)axisType index:(NSUInteger)index;

@optional

/** 坐标轴可选配置参数，目前可选配置key如下：
 
 1、yElementsCount; //y轴坐标个数
 
 2、yElementInterval; //y轴坐标间隔
 
 3、xElementInterval; //x轴坐标间隔
 
 4、yMargin; //y轴距superview边距
 
 5、xMargin; //x轴距superview边距
 
 6、yAxisColor; //y轴color - UIColor
 
 7、xAxisColor; //x轴color - UIColor
 
 8、gridColor; //纹理color - UIColor
 
 9、gridHide; //显示纹理 - NSNumber（@1-不显示; @0-显示）
 
 10、pointFont; //point font - UIFont
 
 11、pointHide; // 显示point - NSNumber（@1-不显示; @0-显示）
 
 @return 坐标轴配置参数 key值参见 PXLineChartConst.h
 
 @see PXLineChartConst.h
 */
- (NSDictionary<NSString*, id> *)lineChartViewAxisAttributes;


/**点击触发响应回调
 
 @param superidnex  -line index of points
 
 @param subindex - point index of points
 
 */
- (void)elementDidClickedWithPointSuperIndex:(NSUInteger)superidnex pointSubIndex:(NSUInteger)subindex;


@optional

@end

@interface PXLineChartView : UIView

@property (nonatomic, weak) id<PXLineChartViewDelegate> delegate;

- (void)reloadData;

- (void)scrollAnimationIfcanScroll;
@end
