//
//  GYScrollPageView.h
//  GYScrollPageView
//
//  Created by Apocalypse on 2018/7/16.
//

#import <UIKit/UIKit.h>
#import "GYPageSegment.h"

@class GYScrollPageItemBaseView;
@class GYScrollPageParam;
@class GYScrollPageParam;


NS_ASSUME_NONNULL_BEGIN

@interface GYScrollPageView : UIView

- (instancetype)initWithFrame:(CGRect)frame dataViews:(NSArray<GYScrollPageItemBaseView *> *)dataViews;
- (instancetype)initWithFrame:(CGRect)frame dataViews:(NSArray<GYScrollPageItemBaseView *> *)dataViews setParam:(GYScrollPageParam *)param;
- (instancetype)initWithFrame:(CGRect)frame dataViews:(NSArray<GYScrollPageItemBaseView *> *)dataViews setParam:(GYScrollPageParam *)param fromSegment:(UIView*)segmentSuperView;
-(void)scrollViewIndex:(NSInteger)index;
- (UIScrollView *)GYScrollView;                                    
@property(nonatomic,assign)NSInteger currenIndex;

@end
@interface GYScrollPageItemBaseView : UIView

- (instancetype)initWithPageTitle:(NSString *)title;
- (void)didAppeared;
- (void)itemViewDidLoad;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,copy)void(^didAddScrollViewBlock)(UIScrollView *scrollView ,NSInteger index);

@end
/********************************* 设置参数 ****************************/

@interface GYScrollPageParam : NSObject

+ (GYScrollPageParam *)defaultParam;
@property(nonatomic,assign)CGFloat headerHeight;              //头部分栏高度
@property(nonatomic,retain)GYPageSegmentParam *segmentParam;   //头部设置参数

@end

NS_ASSUME_NONNULL_END
