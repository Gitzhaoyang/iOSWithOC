//
//  ViewController.m
//  twoScrollViewLinkage
//
//  Created by mungo on 7/11/15.
//  Copyright © 2015 mungo. All rights reserved.
//

#import "ViewController.h"

//屏幕的宽和高
#define KSCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define KSCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
//最顶部状态栏的高度
#define KSTATUS_HEIGHT 20
//顶部items的scrollView的高度
#define KFIRST_SCROLLVIEW_HEIGHT 30
//根据计算，得到底部详情scrollView的高度
#define KSECOND_SCROLLVIEW_HEIGHT (KSCREEN_HEIGHT - KSTATUS_HEIGHT - KFIRST_SCROLLVIEW_HEIGHT)
//顶部scrollView每个item按钮的宽度
#define KFIRST_SCROLLVIEW_ITEM_WIDTH 70

@interface ViewController () <UIScrollViewDelegate>

//顶部items的scrollView
@property (nonatomic, weak) UIScrollView *firstScrollView;
//底部详情scrollView
@property (nonatomic, weak) UIScrollView *secondScrollView;
//item类型的数组
@property (nonatomic, strong) NSArray *itemsTitlesArray;
//为了方便，定义一个包含颜色的NSArray（自行取舍）
@property (nonatomic, strong) NSArray *colorArray;

//记录当前被点击的按钮tag
@property (nonatomic, assign) NSInteger currentButtonTag;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addFirstScrollViewOnView];//添加顶部items的scrollView
    [self addSecondScrollViewOnView];//添加底部详情的scorllView
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - lazy load
//定义items的标题
- (NSArray *) itemsTitlesArray {
    if (!_itemsTitlesArray) {
        _itemsTitlesArray = [NSArray arrayWithObjects:@"头条", @"科技", @"数码", @"热点", @"手机", @"社会", @"图片", @"直播", @"汽车", @"跟帖", @"军事", @"彩票", @"游戏", @"房产", nil];
    }
    
    return _itemsTitlesArray;
}
//颜色数组
- (NSArray *) colorArray {
    if (!_colorArray) {
        _colorArray = [NSArray arrayWithObjects:
                       [UIColor colorWithRed:240.0/255.0 green:89.0/255.0 blue:136.0/255.0 alpha:1.0],
                       [UIColor colorWithRed:0.0/255.0   green:179.0/255.0 blue:155.0/255.0 alpha:1.0],
                       [UIColor colorWithRed:244.0/255.0 green:131.0/255.0 blue:69.0/255.0 alpha:1.0],
                       [UIColor colorWithRed:241.0/255.0 green:90.0/255.0 blue:102.0/255.0 alpha:1.0],
                       [UIColor colorWithRed:0.0/255.0 green:179.0/255.0 blue:155.0/255.0 alpha:1.0],
                       [UIColor colorWithRed:255.0/255.0 green:223.0/255.0 blue:104.0/255.0 alpha:1.0],
                       nil];
    }
    
    return _colorArray;
}

#pragma mark - config the view
//添加第一个scrollview
- (void) addFirstScrollViewOnView {
    //**1.设置顶部类型scrollView
    UIScrollView *firstScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, KSTATUS_HEIGHT, KSCREEN_WIDTH, KFIRST_SCROLLVIEW_HEIGHT)];
    firstScrollView.bounces = NO;//禁止反弹
    firstScrollView.showsHorizontalScrollIndicator = NO;//禁止显示水平滚动条
    //设置scrollView的内容大小，宽度为 宏定义顶部按钮的宽度 ＊ items数组的数量
    firstScrollView.contentSize = CGSizeMake(self.itemsTitlesArray.count * KFIRST_SCROLLVIEW_ITEM_WIDTH, KFIRST_SCROLLVIEW_HEIGHT);
    self.firstScrollView = firstScrollView;
    [self.view addSubview:firstScrollView];//添加到self.view

    //**2.为第一个scrollView添加buttons
    for (int i = 0; i < self.itemsTitlesArray.count; i ++) {
        UIButton *itemButton = [[UIButton alloc] initWithFrame:CGRectMake(i * KFIRST_SCROLLVIEW_ITEM_WIDTH, 0, KFIRST_SCROLLVIEW_ITEM_WIDTH, KFIRST_SCROLLVIEW_HEIGHT)];//注意左边距的写法
        [itemButton setTitle:[self.itemsTitlesArray objectAtIndex:i] forState:UIControlStateNormal];//标题
        itemButton.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.0];//背景颜色
        [itemButton setTitleColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1.0] forState:UIControlStateNormal];//标题颜色
        itemButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [firstScrollView addSubview:itemButton];//添加到第一个scrollView
        
        //定义第一个顶部item的按钮样式
        if (i == 0) {
            itemButton.titleLabel.font = [UIFont systemFontOfSize:18.0f];
            [itemButton setTitleColor:[UIColor colorWithRed:1.0 green:0.3 blue:0.3 alpha:1.0f] forState:UIControlStateNormal];
        }
        
        itemButton.tag = 100 + i;
        [itemButton addTarget:self action:@selector(itemButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    //设置被点击的按钮tag为0
    self.currentButtonTag = 100;
    
}

//添加第二个scrollview
- (void) addSecondScrollViewOnView {
    //**1.设置底部详情scrollView
    UIScrollView *secondScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, KSTATUS_HEIGHT + KFIRST_SCROLLVIEW_HEIGHT, KSCREEN_WIDTH, KSECOND_SCROLLVIEW_HEIGHT)];
    secondScrollView.pagingEnabled = YES;//分页
    secondScrollView.bounces = NO;//禁止反弹
    secondScrollView.delegate = self;
    //设置内容大小，宽度为 屏幕的宽度 * items数组的数量
    secondScrollView.contentSize = CGSizeMake(self.itemsTitlesArray.count * KSCREEN_WIDTH, KSECOND_SCROLLVIEW_HEIGHT);
    self.secondScrollView = secondScrollView;
    [self.view addSubview:secondScrollView];
    //**2.添加Views
    for (int i = 0; i < self.itemsTitlesArray.count; i ++) {
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(i * KSCREEN_WIDTH, 0, KSCREEN_WIDTH, KSECOND_SCROLLVIEW_HEIGHT)];
        bottomView.backgroundColor = [self.colorArray objectAtIndex:(i % 6)];
        //为了方便观察，放置一个label，如果需要其它控件自行替换（如若新闻，用tableView）
        UILabel *flagLabel = [[UILabel alloc] initWithFrame:bottomView.bounds];
        flagLabel.font = [UIFont systemFontOfSize:50.0f];
        flagLabel.textColor = [UIColor whiteColor];
        flagLabel.textAlignment = NSTextAlignmentCenter;
        flagLabel.text = [NSString stringWithFormat:@"%@", [self.itemsTitlesArray objectAtIndex:i]];
        [bottomView addSubview:flagLabel];
        
        [secondScrollView addSubview:bottomView];
    }
}

#pragma mark - item button clicked 

- (void) itemButtonClicked:(UIButton *)button {
    //**1.偏移底部详情scrollView
    NSInteger buttonTag = button.tag - 100;//获取点击按钮的tag
    self.secondScrollView.contentOffset = CGPointMake(buttonTag * KSCREEN_WIDTH, 0);//设置底部scrollview的内容偏移量
    
    //**2.恢复前一个被点击的按钮的样式
    UIButton *preClickedButton = (UIButton *)[self.view viewWithTag:self.currentButtonTag];
    preClickedButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [preClickedButton setTitleColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1.0] forState:UIControlStateNormal];//标题颜色
    
    //**3.设置当前点击按钮样式
    button.titleLabel.font = [UIFont systemFontOfSize:18.0f];
    [button setTitleColor:[UIColor colorWithRed:1.0 green:0.3 blue:0.3 alpha:1.0f] forState:UIControlStateNormal];
    
    //**4.改变当前点击按钮的tag值
    self.currentButtonTag = buttonTag + 100;
}


#pragma mark - scrollView delegate
//正在滑动调用的代理方法
- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    //获取当前第二个scrollView的偏移量
    CGFloat secondScrollViewContentOffsetX = scrollView.contentOffset.x;
    //获取选中按钮的序号
    int buttonTag = (secondScrollViewContentOffsetX) / KSCREEN_WIDTH;
    //计算手指滑动了多少距离
    CGFloat fingerDistance = secondScrollViewContentOffsetX - KSCREEN_WIDTH * buttonTag;
    //获取到下一个按钮，并改变其字体大小和颜色（根据手指滑动的距离动态改变）
    UIButton *buttonNext = (UIButton *)[self.view viewWithTag:(buttonTag + 100 + 1)];
    buttonNext.titleLabel.font = [UIFont systemFontOfSize:(14.0 + fingerDistance * 4 / (KSCREEN_WIDTH))];
    [buttonNext setTitleColor:[UIColor colorWithRed:(0.4f + 3 * fingerDistance / (KSCREEN_WIDTH * 5)) green:0.3 blue:0.3 alpha:1.0] forState:UIControlStateNormal];
    //同样方法获取到当前按钮，并改变其字体大小和颜色恢复回原来样式（根据手指滑动的距离动态改变）
    UIButton *buttonCurr = (UIButton *)[self.view viewWithTag:(buttonTag + 100)];
    buttonCurr.titleLabel.font = [UIFont systemFontOfSize:(18.0 - fingerDistance * 4 / (KSCREEN_WIDTH))];
    [buttonCurr setTitleColor:[UIColor colorWithRed:(1.0f - 3 * fingerDistance / (KSCREEN_WIDTH * 5)) green:0.3 blue:0.3 alpha:1.0] forState:UIControlStateNormal];
}
//滑动结束调用的代理方法
- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //**1.获取选中详情页对应的顶部button
    //移动顶部选中的按钮
    CGFloat secondScrollViewContentOffsetX = scrollView.contentOffset.x;
    //获取选中按钮的序号
    int buttonTag = (secondScrollViewContentOffsetX) / KSCREEN_WIDTH;
    //根据按钮号码获取到顶部的按钮
    UIButton *buttonCurr = (UIButton *)[self.view viewWithTag:(buttonTag + 100)];
    //**2.(重要)设置当前选中的按钮号。如若不写，将导致滑动后再点击顶部按钮，上一个按钮颜色，字体不会改变
    self.currentButtonTag = buttonTag + 100;
    
    //**3.始终保持顶部选中按钮在中间位置
    //注意一：开始的几个按钮，和末尾的几个按钮并不需要一直保持中间。
    //注意二：对于已经放置在firstScrollView中的按钮，它的center是相对于scrollView的content而言的，注意并不是相对于self.view的bounds而言的。也就是说，放置好按钮，它的center就不会再改变
    
    //如果是顶部scrollView即将到末尾的几个按钮，设置偏移量，直接return
    if (buttonCurr.center.x + KSCREEN_WIDTH * 0.5 > self.firstScrollView.contentSize.width) {
        [UIView animateWithDuration:0.3 animations:^{
            self.firstScrollView.contentOffset = CGPointMake(self.firstScrollView.contentSize.width - KSCREEN_WIDTH, 0);
          }];
        return;
    }
    //如果是顶部scrollView开头的几个按钮，设置偏移量，直接return
    if (buttonCurr.center.x < KSCREEN_WIDTH * 0.5) {
        [UIView animateWithDuration:0.3 animations:^{
            self.firstScrollView.contentOffset = CGPointMake(0, 0);
        }];
        return;
    }
    
    //如果是中间几个按钮的情况
    if (buttonCurr.center.x > (KSCREEN_WIDTH * 0.5)) {
        [UIView animateWithDuration:0.3 animations:^{
            self.firstScrollView.contentOffset = CGPointMake(buttonCurr.center.x - self.view.center.x, 0);
        }];
    }

}


@end
