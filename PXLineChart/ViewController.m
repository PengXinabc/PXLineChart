//
//  ViewController.m
//  PXLineChart
//
//  Created by Xin Peng on 17/4/12.
//  Copyright © 2017年 EB. All rights reserved.
//

#import "ViewController.h"
#import "PXLineChartView.h"
#import "PointItem.h"

@interface ViewController ()<PXLineChartViewDelegate>

@property (nonatomic, weak) IBOutlet PXLineChartView *pXLineChartView;
@property (nonatomic, strong) NSArray *lines;//line count
@property (nonatomic, strong) NSArray *xElements;//x轴数据
@property (nonatomic, strong) NSArray *yElements;//y轴数据
@end

#pragma mark -

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _pXLineChartView.delegate = self;
    _xElements = @[@"16-2",@"16-3",@"16-4",@"16-5",@"16-6",@"16-7",@"16-8",@"16-9",@"16-10",@"16-11",@"16-12",@"17-01",@"17-02",@"17-03",@"17-04",@"17-05"];
    _yElements = @[@"1000",@"2000",@"3000",@"4000",@"5000"];
    
    self.lines = [self lines:NO];
    // Do any additional setup after loading the view, typically from a nib.
}

- (NSArray *)lines:(BOOL)fill {
    NSArray *pointsArr = @[@{@"xValue" : @"16-2", @"yValue" : @"1000"},
                           @{@"xValue" : @"16-4", @"yValue" : @"2000"},
                           @{@"xValue" : @"16-6", @"yValue" : @"1700"},
                           @{@"xValue" : @"16-8", @"yValue" : @"3100"},
                           @{@"xValue" : @"16-9", @"yValue" : @"3500"},
                           @{@"xValue" : @"16-12", @"yValue" : @"3400"},
                           @{@"xValue" : @"17-02", @"yValue" : @"1100"},
                           @{@"xValue" : @"17-04", @"yValue" : @"1500"}];
    
    NSArray *pointsArr1 = @[@{@"xValue" : @"16-2", @"yValue" : @"2000"},
                            @{@"xValue" : @"16-3", @"yValue" : @"2200"},
                            @{@"xValue" : @"16-4", @"yValue" : @"3000"},
                            @{@"xValue" : @"16-6", @"yValue" : @"3750"},
                            @{@"xValue" : @"16-7", @"yValue" : @"3800"},
                            @{@"xValue" : @"16-8", @"yValue" : @"4000"},
                            @{@"xValue" : @"16-10", @"yValue" : @"2000"}];
    
    NSMutableArray *points = @[].mutableCopy;
    for (int i = 0; i < pointsArr.count; i++) {
        PointItem *item = [[PointItem alloc] init];
        NSDictionary *itemDic = pointsArr[i];
        item.price = itemDic[@"yValue"];
        item.time = itemDic[@"xValue"];
        item.chartLineColor = [UIColor redColor];
        item.chartPointColor = [UIColor redColor];
        item.pointValueColor = [UIColor redColor];
        if (fill) {
            item.chartFillColor = [UIColor colorWithRed:0 green:0.5 blue:0.2 alpha:0.5];
            item.chartFill = YES;
        }
        [points addObject:item];
    }
    
    NSMutableArray *pointss = @[].mutableCopy;
    for (int i = 0; i < pointsArr1.count; i++) {
        PointItem *item = [[PointItem alloc] init];
        NSDictionary *itemDic = pointsArr1[i];
        item.price = itemDic[@"yValue"];
        item.time = itemDic[@"xValue"];
        item.chartLineColor = [UIColor colorWithRed:0.2 green:1 blue:0.7 alpha:1];
        item.chartPointColor = [UIColor colorWithRed:0.2 green:1 blue:0.7 alpha:1];
        item.pointValueColor = [UIColor colorWithRed:0.2 green:1 blue:0.7 alpha:1];
        if (fill) {
            item.chartFillColor = [UIColor colorWithRed:0.5 green:0.1 blue:0.8 alpha:0.5];
            item.chartFill = YES;
        }
        [pointss addObject:item];
    }
    //两条line
    return @[pointss,points];
}

#pragma mark PXLineChartViewDelegate
//通用设置
- (NSDictionary<NSString*, NSString*> *)lineChartViewAxisAttributes {
    return @{yElementInterval : @"40",
             xElementInterval : @"40",
             yMargin : @"50",
             xMargin : @"25",
             yAxisColor : [UIColor colorWithRed:200.0/255 green:200.0/255 blue:200.0/255 alpha:1],
             xAxisColor : [UIColor colorWithRed:200.0/255 green:200.0/255 blue:200.0/255 alpha:1],
             gridColor : [UIColor colorWithRed:244.0/255 green:244.0/255 blue:244.0/255 alpha:1],
             gridHide : @0,
             pointHide : @0,
             pointFont : [UIFont systemFontOfSize:10],
             firstYAsOrigin : @1,
             scrollAnimation : @1,
             scrollAnimationDuration : @"2"};
}
//line count
- (NSUInteger)numberOfChartlines {
    return self.lines.count;
}
//x轴y轴对应的元素count
- (NSUInteger)numberOfElementsCountWithAxisType:(AxisType)axisType {
    return (axisType == AxisTypeY)? _yElements.count : _xElements.count;
}
//x轴y轴对应的元素view
- (UILabel *)elementWithAxisType:(AxisType)axisType index:(NSUInteger)index {
    UILabel *label = [[UILabel alloc] init];
    NSString *axisValue = @"";
    if (axisType == AxisTypeX) {
        axisValue = _xElements[index];
        label.textAlignment = NSTextAlignmentCenter;//;
    }else if(axisType == AxisTypeY){
        axisValue = _yElements[index];
        label.textAlignment = NSTextAlignmentRight;//;
    }
    label.text = axisValue;
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor blackColor];
    return label;
}
//每条line对应的point数组
- (NSArray<id<PointItemProtocol>> *)plotsOflineIndex:(NSUInteger)lineIndex {
    return self.lines[lineIndex];
}
//点击point回调响应
- (void)elementDidClickedWithPointSuperIndex:(NSUInteger)superidnex pointSubIndex:(NSUInteger)subindex {
    PointItem *item = self.lines[superidnex][subindex];
    NSString *xTitle = item.time;
    NSString *yTitle = item.price;
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:yTitle
                                                                       message:[NSString stringWithFormat:@"x：%@ \ny：%@",xTitle,yTitle] preferredStyle:UIAlertControllerStyleAlert];
    [alertView addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alertView animated:YES completion:nil];
}

static bool fill = NO;
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    fill = !fill;
    self.lines = [self lines:fill];
    [_pXLineChartView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
