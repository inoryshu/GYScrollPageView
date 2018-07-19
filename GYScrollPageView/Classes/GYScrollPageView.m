//
//  GYScrollPageView.m
//  GYScrollPageView
//
//  Created by Apocalypse on 2018/7/16.
//
#import <WebKit/WebKit.h>

#import "GYScrollPageView.h"
@interface GYScrollPageView()<UIScrollViewDelegate>
@property(nonatomic,retain)UIScrollView *scrollView;
@property(nonatomic,retain)GYPageSegment *segment;
@property(nonatomic,retain)NSArray<GYScrollPageItemBaseView *> *dataViews;
@property(nonatomic,retain)GYScrollPageParam *param;
@end
@implementation GYScrollPageView

- (instancetype)initWithFrame:(CGRect)frame dataViews:(NSArray<GYScrollPageItemBaseView *> *)dataViews{
    return [self initWithFrame:frame dataViews:dataViews setParam:nil];
}
- (instancetype)initWithFrame:(CGRect)frame dataViews:(NSArray<GYScrollPageItemBaseView *> *)dataViews setParam:(GYScrollPageParam *)param{
    return [self initWithFrame:frame dataViews:dataViews setParam:param fromSegment:nil];
}
- (instancetype)initWithFrame:(CGRect)frame dataViews:(NSArray<GYScrollPageItemBaseView *> *)dataViews setParam:(GYScrollPageParam *)param fromSegment:(UIView*)segmentSuperView{
    if (self=[super initWithFrame:frame]){
        if (param==nil){param=[GYScrollPageParam defaultParam];}
        self.param=param;
        self.dataViews=dataViews;
        NSMutableArray *titles=[NSMutableArray array];
        [_dataViews enumerateObjectsUsingBlock:^(GYScrollPageItemBaseView * itemView, NSUInteger idx, BOOL * _Nonnull stop) {
            [titles addObject:(itemView.title == nil ? [NSString stringWithFormat:@"%ld",idx] : itemView.title)];
            itemView.frame = CGRectMake(idx*self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
            [self.scrollView addSubview:itemView];
            [itemView itemViewDidLoad];
            if (idx == param.segmentParam.startIndex) {
                [itemView didAppeared];
            }
        }];
        self.scrollView.contentSize = CGSizeMake(_dataViews.count*self.scrollView.frame.size.width, 0);
        if (segmentSuperView==nil){[self addSubview:self.segment];}else{[segmentSuperView addSubview:self.segment];}
        [self.segment updataDataArray:titles];
        [self.segment setAssociatedScroll];
        if (param.segmentParam.startIndex > 0) {
            [self.scrollView setContentOffset:CGPointMake(param.segmentParam.startIndex * self.scrollView.frame.size.width , 0) animated:false];
        }
    }
    return self;
}
- (UIScrollView *)GYScrollView{
    return self.scrollView;
}


- (UIScrollView *)scrollView{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.param.headerHeight, self.frame.size.width, self.frame.size.height-self.param.headerHeight)];
        _scrollView.pagingEnabled = true;
        _scrollView.directionalLockEnabled = true;
        _scrollView.showsHorizontalScrollIndicator = false;
        if (@available(iOS 11.0, *)) {
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [self addSubview:_scrollView];
        _scrollView.delegate = self;
    }
    return _scrollView;
}
-(void)scrollViewIndex:(NSInteger)index{
    [self.scrollView setContentOffset:CGPointMake(index * self.scrollView.frame.size.width ,0) animated:true];
    self.currenIndex=index;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.segment.associatedSscrollBlock) {
        self.segment.associatedSscrollBlock(scrollView);
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self dealWithScroll];
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self dealWithScroll];
}
- (void)dealWithScroll{
    int index = self.scrollView.contentOffset.x / self.scrollView.frame.size.width;
    if (index==self.currenIndex)return;
    GYScrollPageItemBaseView *view = [self.dataViews objectAtIndex:index];
    [view didAppeared];
    [self.segment selectIndex:index animated:false];
    self.currenIndex = index;
}
- (GYPageSegment *)segment{
    if (_segment == nil) {
        _segment = [[GYPageSegment alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.param.headerHeight) setParam:self.param.segmentParam];
        __weak GYScrollPageView *weakSelf = self;
        _segment.didSelectedIndexBlock = ^(NSInteger index) {
            [weakSelf.scrollView setContentOffset:CGPointMake(index * weakSelf.scrollView.frame.size.width , 0) animated:true];
        };
    }
    return _segment;
}
@end

/*************************** 每一项 ******************************/
@implementation GYScrollPageItemBaseView
- (instancetype)initWithPageTitle:(NSString *)title{
    self = [super init];
    if (self) {
        self.title = title;
    }
    return self;
}
- (void)didAddSubview:(UIView *)subview{
    [super didAddSubview:subview];
    if ([subview isKindOfClass:[UIScrollView class]]) {
        if (self.didAddScrollViewBlock) {
            self.didAddScrollViewBlock((UIScrollView *)subview,_index);
        }
    }else if ([subview isKindOfClass:[WKWebView class]]){
        if (self.didAddScrollViewBlock) {
            self.didAddScrollViewBlock(((WKWebView *)subview).scrollView,_index);
        }
    }else if ([subview isKindOfClass:[UIWebView class]]){
        if (self.didAddScrollViewBlock) {
            self.didAddScrollViewBlock(((UIWebView *)subview).scrollView,_index);
        }
    }else{
        for (UIView *sview in [subview subviews]) {
            if ([sview isKindOfClass:[UIScrollView class]]) {
                if (self.didAddScrollViewBlock) {
                    self.didAddScrollViewBlock((UIScrollView *)sview,_index);
                }
            }
        }
    }
}
- (void)itemViewDidLoad{}
- (void)didAppeared{}
@end
/*************************** 设置参数 ****************************/
@implementation GYScrollPageParam
+ (GYScrollPageParam *)defaultParam{
    return [[GYScrollPageParam alloc] init];
}
- (instancetype)init{
    self = [super init];
    if (self) {
        self.headerHeight = 40;
        //        self.segmentParam = [EPageSegmentParam defaultParam];
    }
    return self;
}
@end
