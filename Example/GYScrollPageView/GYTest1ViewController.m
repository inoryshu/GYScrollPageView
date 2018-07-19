//
//  GYTest1ViewController.m
//  GYScrollPageView_Example
//
//  Created by inoryxun on 2018/7/17.
//  Copyright © 2018 Apocalypse. All rights reserved.
//

#import "GYTest1ViewController.h"
#import "GYTestItemView1.h"
@interface GYTest1ViewController ()
@property(nonatomic,retain)GYScrollPageView *pageView;

@end

@implementation GYTest1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    self.view.backgroundColor=[UIColor orangeColor];
    [self pageView];
 
}
- (GYScrollPageView *)pageView{
    if (_pageView == nil) {
     
        GYScrollPageItemBaseView *v1 = [[GYTestItemView1 alloc] initWithPageTitle:@"推荐"];
        GYScrollPageItemBaseView *v2 = [[GYTestItemView1 alloc] initWithPageTitle:@"全部"];
        GYScrollPageItemBaseView *v3 = [[GYTestItemView1 alloc] initWithPageTitle:@"关注"];
        GYScrollPageItemBaseView *v4 = [[GYTestItemView1 alloc] initWithPageTitle:@"游戏"];
        GYScrollPageItemBaseView *v5 = [[GYTestItemView1 alloc] initWithPageTitle:@"热榜"];
        NSArray *vs = @[v1,v2,v3,v4,v5];
        GYScrollPageParam *param = [[GYScrollPageParam alloc] init];

        //头部高度
        param.headerHeight = 40;
        //默认第3个
        param.segmentParam.startIndex = 2;
        //排列类型
        param.segmentParam.type = GYPageContentBetween;
        //底部线颜色
        param.segmentParam.lineColor = [UIColor purpleColor];
        //背景颜色
        param.segmentParam.bgColor = [UIColor whiteColor];
        //正常字体颜色
        param.segmentParam.textColor = [GYTest1ViewController intColorFromColor:[UIColor darkTextColor]];
        //选中的颜色
        param.segmentParam.textSelectedColor = [GYTest1ViewController intColorFromColor:[UIColor redColor]];
        param.segmentParam.margin_spacing=60;
        CGFloat statusBarH = ([UIApplication sharedApplication].statusBarFrame.size.height + 44.0);

        _pageView = [[GYScrollPageView alloc] initWithFrame:self.view.bounds dataViews:vs setParam:param];
    [self.view addSubview:_pageView];
    }
    return _pageView;
}
+(int)intColorFromColor:(UIColor *)color{
    return [self longColorFromHex:[self hexFromUIColor:color]];
}

+(int)longColorFromHex:(NSString *)hexString{
    return (int)[hexString cStringUsingEncoding:NSUnicodeStringEncoding];
}
+ (NSString *) hexFromUIColor: (UIColor*) color {
    if (CGColorGetNumberOfComponents(color.CGColor) < 4) {
        const CGFloat *components = CGColorGetComponents(color.CGColor);
        color = [UIColor colorWithRed:components[0]
                                green:components[0]
                                 blue:components[0]
                                alpha:components[1]];
    }
    
    if (CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor)) != kCGColorSpaceModelRGB) {
        return [NSString stringWithFormat:@"#FFFFFF"];
    }
    
    return [NSString stringWithFormat:@"%d%d%d", (int)((CGColorGetComponents(color.CGColor))[0]*255.0),
            (int)((CGColorGetComponents(color.CGColor))[1]*255.0),
            (int)((CGColorGetComponents(color.CGColor))[2]*255.0)];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end


