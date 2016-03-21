//
//  ViewController.h
//  UITableViewAdvanced01
//
//  Created by mungo on 19/03/16.
//  Copyright © 2016 mungo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (nonatomic, strong) UITableView *mTableView;
@property (nonatomic, strong) NSArray *presidents;
@property (nonatomic, strong) NSArray *filteredPresidents;

@property (nonatomic, retain) UISearchController *searchController;


@property (nonatomic, strong) NSMutableArray *alphabetArray;
@property (nonatomic, strong) NSArray *filteredAlphabetArray;

/*
 //使用UISearchBar和UISearchDisplayController实现搜索栏效果
 @property (nonatomic, strong) UISearchDisplayController *searchDisplayController;
 */

@end

