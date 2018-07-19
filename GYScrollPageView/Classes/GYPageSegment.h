//
//  GYPageSegment.h
//  GYScrollPageView
//
//  Created by inoryxun on 2018/7/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class GYPageSegmentParam;
typedef NS_ENUM(NSInteger, GYPageContentType) {
    GYPageContentLeft = 0,                    //从左到右依次排列
    GYPageContentBetween = 1,                 //平均排列一屏
};
@interface GYPageSegment : UIView
- (void)updataDataArray:(NSArray<NSString *> *)data;                                //更新数据源
- (void)setAssociatedScroll;                                                        //设置关联滚动
- (void)selectIndex:(NSInteger)index animated:(BOOL)animated;                       //设置选择
- (instancetype)initWithFrame:(CGRect)frame setParam:(GYPageSegmentParam *)param;    //初始化
@property(nonatomic,copy)void(^didSelectedIndexBlock)(NSInteger index);             //选择回调
@property(nonatomic,copy)void(^associatedSscrollBlock)(UIScrollView *scrollView);   //关联滚动

@end
@interface GYPageSegmentParam : NSObject
+ (GYPageSegmentParam *)defaultParam;
@property(nonatomic,assign)GYPageContentType type;      //排列类型
@property(nonatomic,assign)NSInteger startIndex;       //默认选中的item
@property(nonatomic,retain)UIColor *bgColor;           //背景颜色
@property(nonatomic,assign)CGFloat margin_spacing;     //左右边缘间距
@property(nonatomic,assign)CGFloat spacing;            //中间间距
@property(nonatomic,assign)int textSelectedColor;      //选中的颜色
@property(nonatomic,assign)int textColor;              //正常的颜色
@property(nonatomic,assign)CGFloat lineWidth;          //底部线宽
@property(nonatomic,retain)UIColor *lineColor;         //底部线颜色
@property(nonatomic,assign)CGFloat fontSize;           //字体大小
@property(nonatomic,assign)CGFloat selectedfontSize;   //选择字体大小
@property(nonatomic,retain)UIColor *topLineColor;      //上边框颜色
@property(nonatomic,retain)UIColor *botLineColor;      //下边框颜色
@property(nonatomic,assign)CGFloat itemWidth;          //宽度
@property(nonatomic,assign)BOOL showLine;              //显示底部线

@end
/******************************* Cell *********************************/

@interface GYPageSegmentCell : UICollectionViewCell
@property(nonatomic,weak)GYPageSegmentParam *param;
- (void)updateText:(NSString *)text param:(GYPageSegmentParam *)param;
- (void)didSelected:(BOOL)selected;
@property(nonatomic,retain)UILabel *textLabel;

@end
NS_ASSUME_NONNULL_END
