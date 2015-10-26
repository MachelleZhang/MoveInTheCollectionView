//
//  ViewController.m
//  MovableCollection
//
//  Created by MachelleZhang on 15/10/23.
//  Copyright © 2015年 Machelle. All rights reserved.
//

#import "ViewController.h"
#import "CollectionViewCell.h"

@interface ViewController ()

//两个数组分别作为两个section的数据源
@property (nonatomic, strong) NSMutableArray *dataInSection0;
@property (nonatomic, strong) NSMutableArray *dataInSection1;

@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];

    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    //注册cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CollectionViewCell"];
    //注册header
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionReusableView"];
    
    _dataInSection0 = [[NSMutableArray alloc] initWithObjects:@"时尚", @"汽车", @"体育", nil];
    _dataInSection1 = [[NSMutableArray alloc] initWithObjects:@"教育", @"新闻", @"游戏", nil];
}

//返回2个section
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

//每个section的数量由数据源的count值确定
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return _dataInSection0.count;
    } else {
        return _dataInSection1.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //cell重用
    CollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell" forIndexPath:indexPath];
    
    //cell上的label填充
    if (indexPath.section == 0) {
        cell.label.text = _dataInSection0[indexPath.row];
    } else {
        cell.label.text = _dataInSection1[indexPath.row];
    }
    
    return cell;
}

//header的显示设置
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    //header的重用
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"UICollectionReusableView" forIndexPath:indexPath];
    
    //在header上显示一个label
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 45)];
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        label.text = [NSString stringWithFormat:@"%d", indexPath.section];
        [view addSubview:label];
        view.backgroundColor = [UIColor grayColor];
    }
    
    return view;
}

//返回header的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size= {320,45};
    return size;
}

//cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(100, 100);
}

//section的边距(上，左，下，右)
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 5, 5, 5);
}

//section内，cell的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

//点击cell的响应
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //先判断下在哪个section
    if (indexPath.section == 0) {
        //先修改数据源
        NSString *movedItem = self.dataInSection0[indexPath.row];
        [self.dataInSection0 removeObjectAtIndex:indexPath.row];
        [self.dataInSection1 addObject:movedItem];
        //再修改cell的indexPath(如果先于数据源修改，就会报错)
        //关于cell的操作，有move，delete，insert三种方式，自带的动画效果也是不同的
        [collectionView moveItemAtIndexPath:indexPath toIndexPath:[NSIndexPath indexPathForRow:self.dataInSection1.count-1 inSection:1]];
        //重新加载数据
        [self.collectionView reloadData];
    } else if (indexPath.section == 1) {
        NSString *movedItem = self.dataInSection1[indexPath.row];
        [self.dataInSection1 removeObjectAtIndex:indexPath.row];
        [self.dataInSection0 addObject:movedItem];
        [collectionView moveItemAtIndexPath:indexPath toIndexPath:[NSIndexPath indexPathForRow:self.dataInSection0.count-1 inSection:0]];
        [self.collectionView reloadData];
    }
}

@end
