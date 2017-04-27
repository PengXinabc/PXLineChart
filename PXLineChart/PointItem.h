//
//  PointItem.h
//  PXLineChart
//
//  Created by Xin Peng on 17/4/15.
//  Copyright © 2017年 EB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PointItem : NSObject

@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) UIColor *chartLineColor;
@property (nonatomic, strong) UIColor *chartPointColor;
@property (nonatomic, strong) UIColor *pointValueColor;
@property (nonatomic, strong) UIColor *chartFillColor;
@property (nonatomic, assign) BOOL chartFill;
@end
