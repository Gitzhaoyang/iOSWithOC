//
//  ViewController.m
//  UITableViewAdvanced01
//
//  Created by mungo on 19/03/16.
//  Copyright © 2016 mungo. All rights reserved.
//

#import "ViewController.h"
#import "President.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchResultsUpdating, UISearchDisplayDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化数据
    self.presidents = [[NSArray alloc] initWithObjects:
                       [President presidentWithFirstName:@"George" lastName:@"Washington"],
                       [President presidentWithFirstName:@"John" lastName:@"Adams"],
                       [President presidentWithFirstName:@"Thomas" lastName:@"Bffeson"],
                       [President presidentWithFirstName:@"James" lastName:@"Cadison"],
                       [President presidentWithFirstName:@"James" lastName:@"Donroe"],
                       [President presidentWithFirstName:@"John Quincy" lastName:@"Edams"],
                       [President presidentWithFirstName:@"Andrew" lastName:@"Fackson"],
                       [President presidentWithFirstName:@"Martin" lastName:@"Gan Buren"],
                       [President presidentWithFirstName:@"William Henry" lastName:@"Harrison"],
                       [President presidentWithFirstName:@"John" lastName:@"Tyler"],
                       [President presidentWithFirstName:@"James K" lastName:@"Iolk"],
                       [President presidentWithFirstName:@"Aachary" lastName:@"Jaylor"],
                       [President presidentWithFirstName:@"Billard" lastName:@"Killmore"],
                       [President presidentWithFirstName:@"Vranklin" lastName:@"Pierce"],
                       [President presidentWithFirstName:@"Dames" lastName:@"Buchanan"],
                       [President presidentWithFirstName:@"Ebraham" lastName:@"Lincoln"],
                       [President presidentWithFirstName:@"Andrew" lastName:@"Johnson"],
                       [President presidentWithFirstName:@"Ilysses S" lastName:@"Grant"],
                       [President presidentWithFirstName:@"Kutherford B" lastName:@"Hayes"],
                       [President presidentWithFirstName:@"James A" lastName:@"Garfield"],
                       [President presidentWithFirstName:@"Nhester A" lastName:@"Arthur"],
                       [President presidentWithFirstName:@"Orover" lastName:@"Cleveland"],
                       [President presidentWithFirstName:@"Pejamin" lastName:@"Harrison"],
                       [President presidentWithFirstName:@"Qrover" lastName:@"Cleveland"],
                       [President presidentWithFirstName:@"Rilliam" lastName:@"McKinley"],
                       [President presidentWithFirstName:@"Sheodore" lastName:@"Roosevelt"],
                       [President presidentWithFirstName:@"Tilliam Howard" lastName:@"Taft"],
                       [President presidentWithFirstName:@"Woodrow" lastName:@"Wilson"],
                       [President presidentWithFirstName:@"Varren G" lastName:@"Harding"],
                       [President presidentWithFirstName:@"Xalvin" lastName:@"Coolidge"],
                       [President presidentWithFirstName:@"Yerbert" lastName:@"Hoover"],
                       [President presidentWithFirstName:@"Franklin D" lastName:@"Roosevelt"],
                       [President presidentWithFirstName:@"Harry S" lastName:@"Truman"],
                       [President presidentWithFirstName:@"Dwight D" lastName:@"Eisenhower"],
                       [President presidentWithFirstName:@"John F" lastName:@"Kennedy"],
                       [President presidentWithFirstName:@"Lyndon B" lastName:@"Johnson"],
                       [President presidentWithFirstName:@"Richard" lastName:@"Nixon"],
                       [President presidentWithFirstName:@"Gerald" lastName:@"Ford"],
                       [President presidentWithFirstName:@"Jimmy" lastName:@"Carter"],
                       [President presidentWithFirstName:@"Ronald" lastName:@"Reagan"],
                       [President presidentWithFirstName:@"George H W" lastName:@"Bush"],
                       [President presidentWithFirstName:@"Bill" lastName:@"Clinton"],
                       [President presidentWithFirstName:@"George W" lastName:@"Bush"],
                       [President presidentWithFirstName:@"Barack" lastName:@"Obama"],
                       nil];
    
    CGRect appFrame = [[UIScreen mainScreen] bounds];
    //创建tableview
    self.mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, appFrame.size.width, appFrame.size.height - 20) style:UITableViewStylePlain];
    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
    [self.view addSubview:self.mTableView];
    
    //创建searchController
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    //设置tableview的搜索栏
    self.mTableView.tableHeaderView = self.searchController.searchBar;
    self.mTableView.sectionIndexBackgroundColor = [UIColor clearColor];//设置索引条的背景颜色
    
    //设置字母表
    self.alphabetArray = [self getAlphetSortedArray];
    
}

/**
 * 新添加方法：
 * 获取字母表
 * @return MSMutableArray* 已经排序的字母表数组
 */
- (NSMutableArray *) getAlphetSortedArray {
    self.alphabetArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < [self.presidents count]; i ++) {
        //获取名字的第一个字母
        President *president = [self.presidents objectAtIndex:i];
        char letter = [president.firstName characterAtIndex:0];
        NSString *uniqueChar = [NSString stringWithFormat:@"%c", letter];
        //将字母加入到字母表中
        if (![self.alphabetArray containsObject:uniqueChar]) {
            [self.alphabetArray addObject:uniqueChar];
        }
    }
    
    //对字母表进行排序
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"self" ascending:YES];
    NSArray *sortDescirptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *sortedArray;
    sortedArray = [self.alphabetArray sortedArrayUsingDescriptors:sortDescirptors];
    NSMutableArray *alphabetArray = [[NSMutableArray alloc] initWithArray:sortedArray copyItems:YES];
    
    return alphabetArray;
}

#pragma mark - tableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searchController.active) {
        return [self.filteredPresidents count];
    } else {
        //根据section筛选总统数组
        NSArray *tmpArray = [self getAlphabetArrayWithIndex:section];
        
        return [tmpArray count];
    }
}

#pragma mark - Indexing UITableView
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.alphabetArray;
}


- (NSInteger) tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return index;
}


#pragma mark - tableView



- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.alphabetArray objectAtIndex: section];
}


- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.searchController.active) {
        self.alphabetArray = nil;//搜索时不显示section
        return 1;
    } else {
        self.alphabetArray = [self getAlphetSortedArray];//停止搜索恢复section显示
        return [self.alphabetArray count];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    President *president;
    if (self.searchController.active) {
        president = [self.filteredPresidents objectAtIndex:indexPath.row];
    } else {
        
        NSArray *tmpArray = [self getAlphabetArrayWithIndex:indexPath.section];
        if ([tmpArray count]) {
            president = [tmpArray objectAtIndex:indexPath.row];
        }
        
    }
    
    if (president) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", president.firstName, president.lastName];
    }
    
    return cell;
    
}

/*
 * 新添加方法：
 * 根据首字母对所有总统进行筛选
 * @return NSArray* 于当前首字母相同的总统数组
 */

- (NSArray *) getAlphabetArrayWithIndex:(NSInteger)index{
    
    NSString *alphabet = [self.alphabetArray objectAtIndex:index];
    NSPredicate *president = [NSPredicate predicateWithFormat:@"firstName BEGINSWITH [cd] %@", alphabet];
    NSArray *tmpArray = [self.presidents filteredArrayUsingPredicate:president];
    
    return tmpArray;
}

#pragma mark - SearchController delegate
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchString = [self.searchController.searchBar text];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"firstName CONTAINS[cd] %@ OR lastName CONTAINS[cd] %@", searchString, searchString];
    
    self.filteredPresidents = [self.presidents filteredArrayUsingPredicate:predicate];
    
    //刷新表格
    [self.mTableView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





/*****************************************************************************************
 *                 通过UISearchBar和UISearchDisplayController实现搜索栏
 ******************************************************************************************/
/*
 -(void)viewDidLoad {
 self.presidents = [[NSArray alloc] initWithObjects:
 [President presidentWithFirstName:@"George" lastName:@"Washington"],
 [President presidentWithFirstName:@"John" lastName:@"Adams"],
 [President presidentWithFirstName:@"Thomas" lastName:@"Jeffeson"],
 [President presidentWithFirstName:@"James" lastName:@"Madison"],
 [President presidentWithFirstName:@"James" lastName:@"Monroe"],
 [President presidentWithFirstName:@"John Quincy" lastName:@"Adams"],
 [President presidentWithFirstName:@"Andrew" lastName:@"Jackson"],
 [President presidentWithFirstName:@"Martin" lastName:@"van Buren"],
 [President presidentWithFirstName:@"William Henry" lastName:@"Harrison"],
 [President presidentWithFirstName:@"John" lastName:@"Tyler"],
 [President presidentWithFirstName:@"James K" lastName:@"Polk"],
 [President presidentWithFirstName:@"Zachary" lastName:@"Taylor"],
 [President presidentWithFirstName:@"Millard" lastName:@"Fillmore"],
 [President presidentWithFirstName:@"Franklin" lastName:@"Pierce"],
 [President presidentWithFirstName:@"James" lastName:@"Buchanan"],
 [President presidentWithFirstName:@"Abraham" lastName:@"Lincoln"],
 [President presidentWithFirstName:@"Andrew" lastName:@"Johnson"],
 [President presidentWithFirstName:@"Ulysses S" lastName:@"Grant"],
 [President presidentWithFirstName:@"Rutherford B" lastName:@"Hayes"],
 [President presidentWithFirstName:@"James A" lastName:@"Garfield"],
 [President presidentWithFirstName:@"Chester A" lastName:@"Arthur"],
 [President presidentWithFirstName:@"Grover" lastName:@"Cleveland"],
 [President presidentWithFirstName:@"Bejamin" lastName:@"Harrison"],
 [President presidentWithFirstName:@"Grover" lastName:@"Cleveland"],
 [President presidentWithFirstName:@"William" lastName:@"McKinley"],
 [President presidentWithFirstName:@"Theodore" lastName:@"Roosevelt"],
 [President presidentWithFirstName:@"William Howard" lastName:@"Taft"],
 [President presidentWithFirstName:@"Woodrow" lastName:@"Wilson"],
 [President presidentWithFirstName:@"Warren G" lastName:@"Harding"],
 [President presidentWithFirstName:@"Calvin" lastName:@"Coolidge"],
 [President presidentWithFirstName:@"Herbert" lastName:@"Hoover"],
 [President presidentWithFirstName:@"Franklin D" lastName:@"Roosevelt"],
 [President presidentWithFirstName:@"Harry S" lastName:@"Truman"],
 [President presidentWithFirstName:@"Dwight D" lastName:@"Eisenhower"],
 [President presidentWithFirstName:@"John F" lastName:@"Kennedy"],
 [President presidentWithFirstName:@"Lyndon B" lastName:@"Johnson"],
 [President presidentWithFirstName:@"Richard" lastName:@"Nixon"],
 [President presidentWithFirstName:@"Gerald" lastName:@"Ford"],
 [President presidentWithFirstName:@"Jimmy" lastName:@"Carter"],
 [President presidentWithFirstName:@"Ronald" lastName:@"Reagan"],
 [President presidentWithFirstName:@"George H W" lastName:@"Bush"],
 [President presidentWithFirstName:@"Bill" lastName:@"Clinton"],
 [President presidentWithFirstName:@"George W" lastName:@"Bush"],
 [President presidentWithFirstName:@"Barack" lastName:@"Obama"],
 nil];
 
 CGRect appFrame = [[UIScreen mainScreen] bounds];
 //创建tableview
 self.mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, appFrame.size.width, appFrame.size.height - 20) style:UITableViewStylePlain];
 self.mTableView.delegate = self;
 self.mTableView.dataSource = self;
 [self.view addSubview:self.mTableView];
 
 
 //创建searchbar
 UISearchBar *mySearchBar = [[UISearchBar alloc] init];
 mySearchBar.delegate = self;
 [mySearchBar setAutocapitalizationType:UITextAutocapitalizationTypeNone];
 [mySearchBar sizeToFit];
 self.mTableView.tableHeaderView = mySearchBar;
 
 
 self.searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:mySearchBar contentsController:self];
 [self setSearchDisplayController:self.searchDisplayController];
 
 [self.searchDisplayController setDelegate:self];
 [self.searchDisplayController setSearchResultsDataSource:self];
 
 }
 
 #pragma mark - UITableView datasource
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 static NSString *cellId = @"cellId";
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
 if (!cell) {
 cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
 }
 
 President *president;
 if (tableView == self.searchDisplayController.searchResultsTableView) {
 president = [self.filteredPresidents objectAtIndex:indexPath.row];
 } else {
 president = [self.presidents objectAtIndex:indexPath.row];
 }
 
 cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", president.firstName, president.lastName];
 
 return cell;
 }
 
 
 #pragma mark - UITableView delegate
 - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
 if (tableView == self.searchDisplayController.searchResultsTableView) {
 return [self.filteredPresidents count];
 } else {
 return [self.presidents count];
 }
 }
 
 - (BOOL) searchBarShouldBeginEditing:(UISearchBar *)searchBar {
 NSLog(@"开始搜索");
 return YES;
 }
 
 
 - (BOOL) searchBarShouldEndEditing:(UISearchBar *)searchBar {
 NSLog(@"结束搜索");
 return YES;
 }
 
 - (BOOL) searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(nullable NSString *)searchString {
 
 
 NSPredicate *predicate = [NSPredicate predicateWithFormat:@"firstName CONTAINS[cd] %@ OR lastName CONTAINS[cd] %@", searchString, searchString];
 
 self.filteredPresidents = [self.presidents filteredArrayUsingPredicate:predicate];
 
 return YES;
 }
 
 */


@end
