//
//  ViewController.m
//  Meituan
//
//  Created by Macmafia on 2019/4/3.
//  Copyright © 2019 Macmafia. All rights reserved.
//

#import "ViewController.h"

static int ITEMS_NUM = 3;

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    BOOL scrollDown;// = YES 时表示tableview在从上向下滑动； = NO 时表示从下往上滑动；
    CGFloat latestDeltY;
}
@property (weak, nonatomic) IBOutlet UITableView *mLeftTableView;
@property (weak, nonatomic) IBOutlet UITableView *mRightTableView;

@property (nonatomic, strong) NSMutableArray *mLeftDatasource;
@property (nonatomic, strong) NSMutableArray *mRightDatasource;

@end

@implementation ViewController

- (NSMutableArray *)mLeftDatasource{
    if (!_mLeftDatasource) {
        _mLeftDatasource = [NSMutableArray array];
        for (int i = 0; i < 30; i++) {
            [_mLeftDatasource addObject:@(i)];//模拟30条分类
        }
    }
    return _mLeftDatasource;
}


- (NSMutableArray *)mRightDatasource{
    if (!_mRightDatasource) {
        _mRightDatasource = [NSMutableArray array];
        NSInteger count = (self.mLeftDatasource.count * ITEMS_NUM);
        for (int i = 0; i < count; i++) {
            [_mRightDatasource addObject:@(i)];
        }
    }
    return _mRightDatasource;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self seleectIndex:0];//默认选中第一个分类
}


#pragma mark - Datasource & delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([tableView isEqual:_mLeftTableView]) {
        return self.mLeftDatasource.count ? 1 : 0;
    }else{
        return self.mLeftDatasource.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:_mLeftTableView]) {
        return self.mLeftDatasource.count;
    }else{
        return ITEMS_NUM;//每组3个
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if ([tableView isEqual:_mLeftTableView]) {
        cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    }else{
        cell.textLabel.text = @"Items";
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:_mLeftTableView]) {
        //左边列表滑动到指定分类
        [_mLeftTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]
                               atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        //右边列表滑动到指定分类
        [_mRightTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.row]
                                atScrollPosition:UITableViewScrollPositionTop
                                        animated:YES];
    }else{
        //进入商品详情
    }
}


- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section
{
    if ([tableView isEqual:_mRightTableView]) {
        return [NSString stringWithFormat:@"%ld",section];
    }
    return nil;
}

// 跟上面的title 二选一
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    return nil;
//}


#pragma mark - 联动逻辑
- (void)tableView:(UITableView *)tableView
willDisplayHeaderView:(UIView *)view
       forSection:(NSInteger)section
{
    //右边列表从上往下滑动
    if ([tableView isEqual:_mRightTableView] &&
        scrollDown &&
        (tableView.dragging || tableView.decelerating))
    {
        [self seleectIndex:section];
    }
}

- (void)tableView:(UITableView *)tableView
didEndDisplayingHeaderView:(UIView *)view
       forSection:(NSInteger)section
{
    //右边列表从下往上滑动
    if ([tableView isEqual:_mRightTableView] &&
        !scrollDown &&
        (tableView.dragging || tableView.decelerating))
    {
        [self seleectIndex:section + 1];
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:_mLeftTableView]) {
        return;
    }
    /*这种方法有问题，即tableview到底再往上滑松手，触发bounce效果时，vel.y = 0，无法确定滚动的方向。
    CGPoint vel = [scrollView.panGestureRecognizer velocityInView:scrollView];
    NSLog(@"+++%f",vel.y);
    scrollDown = vel.y > 0;
    if (scrollDown) {
        //NSLog(@"++向下");
    }
    */
    scrollDown = (latestDeltY > scrollView.contentOffset.y);
    latestDeltY = scrollView.contentOffset.y;
}

#pragma mark - BUSINESS

- (void)seleectIndex:(NSInteger)index{
    index = MIN(MAX(index, 0), _mLeftDatasource.count);
    
    //左边列表自动选中与右侧匹配的分类
    [_mLeftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]
                                 animated:YES
                           scrollPosition:UITableViewScrollPositionMiddle];
    NSLog(@"+++items at:%ld",(long)index);
}

@end
