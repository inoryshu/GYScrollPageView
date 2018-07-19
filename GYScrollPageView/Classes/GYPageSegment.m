//
//  GYPageSegment.m
//  GYScrollPageView
//
//  Created by inoryxun on 2018/7/16.
//

#import "GYPageSegment.h"

#define GYRGBColor(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define GYFont(fontValue) [UIFont systemFontOfSize:fontValue]

@interface GYPageSegment()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic,retain)UICollectionView *collectionView;
@property(nonatomic,retain)NSArray *dataArray;
@property(nonatomic,retain)GYPageSegmentParam *param;                                        //设置参数
@property(nonatomic,assign)CGFloat itemWidth;                                               //平均宽度
@property(nonatomic,assign)NSInteger selectedIndex;                                         //当前选择
@property(nonatomic,retain)UIView *lineView;
@property(nonatomic,retain)NSMutableArray *cellArray;
@property(nonatomic,retain)NSMutableArray *cellCenterXArray;
@property (nonatomic, assign) CGFloat lastContentOffsetX;


@end
@implementation GYPageSegment

- (instancetype)initWithFrame:(CGRect)frame{
    return [self initWithFrame:frame setParam:nil data:nil];
}
- (instancetype)initWithFrame:(CGRect)frame setParam:(GYPageSegmentParam *)param{
    return [self initWithFrame:frame setParam:param data:nil];
}
- (instancetype)initWithFrame:(CGRect)frame setParam:(GYPageSegmentParam *)param data:(NSArray<NSString *> *)data{
    self = [super initWithFrame:frame];
    if (self) {
        if (param == nil) {param = [GYPageSegmentParam defaultParam];}
        self.selectedIndex = param.startIndex;
        self.param = param;
        self.lastContentOffsetX = 0;
        self.dataArray = data;
        if (_dataArray) {[self collectionView];}
        self.backgroundColor = param.bgColor;
    }
    return self;
}

- (void)updataDataArray:(NSArray<NSString *> *)data{
    self.dataArray = data;
    [[self collectionView] reloadData];
}
- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        CGFloat dh = self.frame.size.height;
        UICollectionViewFlowLayout *laout = [[UICollectionViewFlowLayout alloc] init];
        laout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        laout.sectionInset = UIEdgeInsetsMake(0, _param.margin_spacing, 0, _param.margin_spacing);
        laout.minimumLineSpacing = _param.spacing;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, dh) collectionViewLayout:laout];
        _collectionView.showsHorizontalScrollIndicator = false;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[GYPageSegmentCell class] forCellWithReuseIdentifier:@"cell"];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [self addSubview:_collectionView];
        [self lineView];
        
        UIView *bline = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-0.5, self.frame.size.width, 0.5)];
        bline.backgroundColor = _param.botLineColor;
        UIView *tline = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0.5)];
        tline.backgroundColor = _param.topLineColor;
        [self addSubview:bline];
        [self addSubview:tline];
    }
    return _collectionView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat dh = self.frame.size.height;
    return CGSizeMake(self.itemWidth, dh);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.associatedSscrollBlock == nil) {
        self.selectedIndex = indexPath.row;
        [collectionView reloadData];
    }
    if (self.didSelectedIndexBlock) {
        self.didSelectedIndexBlock(indexPath.row);
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    GYPageSegmentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell updateText:_dataArray[indexPath.row] param:self.param];
    [cell didSelected:(indexPath.row == self.selectedIndex)];
    if (self.cellArray == nil) {self.cellArray = [NSMutableArray array];}
    if (self.cellCenterXArray == nil) {self.cellCenterXArray = [NSMutableArray array];}
    if (![self.cellArray containsObject:cell]) {
        [self.cellArray addObject:cell];
        [self.cellCenterXArray addObject:@(cell.center.x)];
    }
    return cell;
}
- (void)selectIndex:(NSInteger)index animated:(BOOL)animated{
    self.selectedIndex = index;
    [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:true scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
}
- (void)setAssociatedScroll{
    __weak GYPageSegment *weakSelf = self;
    self.associatedSscrollBlock = ^(UIScrollView *scrollView) {
        if (weakSelf.collectionView.contentSize.width <= 0) {return;}
        int page = scrollView.contentOffset.x / scrollView.frame.size.width;
        CGFloat dx = scrollView.contentOffset.x;
        if (dx < 0.0) {dx = 0;page = -1;}
        if (dx > scrollView.contentSize.width-scrollView.frame.size.width) {
            dx = scrollView.contentSize.width-scrollView.frame.size.width;
            page = -1;
        }
        CGRect frame=weakSelf.lineView.frame;
        CGFloat hx=(weakSelf.itemWidth+weakSelf.param.spacing)*dx/scrollView.frame.size.width;
        frame.origin.x=weakSelf.param.margin_spacing+hx;
        weakSelf.lineView.frame=frame;
        if (page>=0){
            CGFloat dspace = weakSelf.itemWidth + weakSelf.param.spacing;
            [weakSelf.cellArray enumerateObjectsUsingBlock:^(GYPageSegmentCell *cell, NSUInteger idx, BOOL * _Nonnull stop) {
                CGFloat scale = fabs(cell.center.x-weakSelf.lineView.center.x)/dspace;
                if (scale <= 1.0) {
                    CGFloat fontSize = weakSelf.param.selectedfontSize + (weakSelf.param.fontSize - weakSelf.param.selectedfontSize)*scale;
                    cell.textLabel.font = GYFont(fontSize);
                    float sr = (float)((weakSelf.param.textSelectedColor & 0xFF0000) >> 16);
                    float sg = (float)((weakSelf.param.textSelectedColor & 0xFF00) >> 8);
                    float sb = (float)(weakSelf.param.textSelectedColor & 0xFF);
                    float r = (float)((weakSelf.param.textColor & 0xFF0000) >> 16);
                    float g = (float)((weakSelf.param.textColor & 0xFF00) >> 8);
                    float b = (float)(weakSelf.param.textColor & 0xFF);
                    cell.textLabel.textColor = [UIColor colorWithRed: (sr+(r-sr)*scale)/255.0 green:(sg+(g-sg)*scale)/255.0 blue:(sb+(b-sb)*scale)/255.0 alpha:1];
                }else{
                    cell.textLabel.textColor = GYRGBColor(weakSelf.param.textColor);
                    cell.textLabel.font = GYFont(weakSelf.param.fontSize);
                }
            }];
        }
    };
}
- (UIColor *)changeRGB:(UIColor *)color changeValue:(CGFloat)value{
    NSArray *nextViewRgbArray = [self getRGBWithColor:color];
    color = [UIColor colorWithRed:[nextViewRgbArray[0] doubleValue] + value green:[nextViewRgbArray[1] doubleValue] blue:[nextViewRgbArray[2] doubleValue] alpha:[nextViewRgbArray[3] doubleValue]];
    return color;
}
- (NSArray *)getRGBWithColor:(UIColor *)color{
    double red = 0.0;
    double green = 0.0;
    double blue = 0.0;
    double alpha = 0.0;
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    return @[@(red), @(green), @(blue), @(alpha)];
}
- (UIView *)lineView{
    if (_lineView == nil) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(_param.margin_spacing+(self.itemWidth+_param.spacing)*_param.startIndex, self.collectionView.frame.size.height-2, self.itemWidth, 2)];
        _lineView.hidden = !_param.showLine;
        CGFloat lineW = self.param.lineWidth < 0 ? self.itemWidth*0.6 : self.param.lineWidth;
        UIView *sline = [[UIView alloc] initWithFrame:CGRectMake((_lineView.frame.size.width-lineW)*0.5, 0, lineW, _lineView.frame.size.height)];
        [_lineView addSubview:sline];
        sline.backgroundColor = self.param.lineColor;
        [self.collectionView addSubview:_lineView];
        [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:self.param.startIndex inSection:0] animated:true scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    }
    return _lineView;
}
- (CGFloat)itemWidth{
    if (_itemWidth <= 0) {
        switch (self.param.type) {
            case GYPageContentLeft:
                _itemWidth = self.param.itemWidth;
                break;
            case GYPageContentBetween:
                _itemWidth = (_collectionView.frame.size.width - 2*_param.margin_spacing - (_dataArray.count-1)*_param.spacing)/_dataArray.count;
                break;
            default:
                break;
        }
    }
    return _itemWidth;
}


@end
@implementation GYPageSegmentParam

+ (GYPageSegmentParam *)defaultParam{
    return [[GYPageSegmentParam alloc] init];
}
- (instancetype)init{
    if ([super init]) {
        self.type = GYPageContentBetween;
        self.spacing = 5;
        self.margin_spacing = 5;
        self.textSelectedColor = 0x000000;
        self.textColor = 0x000000;
        self.showLine = true;
        self.lineWidth = -1;
        self.lineColor = [UIColor redColor];
        self.fontSize = 15;
        self.selectedfontSize = 15;
        self.startIndex = 0;
        self.bgColor = [UIColor clearColor];
        self.topLineColor = [UIColor clearColor];
        self.botLineColor = [UIColor clearColor];
        self.itemWidth = 80;
    }
    return self;
}
@end

/******************************* Cell *********************************/
@implementation GYPageSegmentCell

- (void)updateText:(NSString *)text param:(GYPageSegmentParam *)param{
    self.param = param;
    self.textLabel.frame = self.contentView.bounds;
    self.textLabel.text = text;
}

- (void)didSelected:(BOOL)selected{
    self.textLabel.textColor = selected ? GYRGBColor(_param.textSelectedColor) : GYRGBColor(_param.textColor);
    self.textLabel.font = selected ? GYFont(_param.selectedfontSize) : GYFont(_param.fontSize);
}

- (UILabel *)textLabel{
    if (_textLabel == nil) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = [UIFont systemFontOfSize:self.param.fontSize];
        _textLabel.textColor = GYRGBColor(self.param.textColor);
        _textLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_textLabel];
    }
    return _textLabel;
}

@end
