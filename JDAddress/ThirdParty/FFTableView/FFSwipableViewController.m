//
//  FFSwipableViewController.m
//  FFSelectViewProject
//
//  Created by ZhanyaaLi on 16/8/18.
//  Copyright © 2016年 FaceFace_Lilubin. All rights reserved.
//

#import "FFSwipableViewController.h"
#import "FFTitleBarView.h"
#import "FFHorizonalTableViewController.h"
#import "FFCell.h"

//#import "ZSFQAddressRequest.h"


#define kAreaCellID @"FFCell"
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kTopTitleHeight 40
#define kStartYPosition 222
#define kTableViewBasedTag 600
#define kSelLineWidth 40

typedef NS_ENUM(int, FFAreaSelectedType)
{
    FFAreaSelectedTypeProvince = 0,    //省
    FFAreaSelectedTypeCity,            //市
    FFAreaSelectedTypeCounty,          //县
    FFAreaSelectedTypeTown,            //镇
    FFAreaSelectedTypeVillage,         //村
};

@interface FFSwipableViewController () <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *_areaModelArray;
    NSMutableArray *_tableViewArray;
    FFAreaSelectedType _zyaType;
    NSArray *_dictAllKeys;
    NSMutableDictionary *_areaDataDic; //以_dictAllKeys中的key作为dataDic的key，存储数组类型字典
    NSMutableArray *_curIndexPathArray;
    NSMutableDictionary *_selAreaDic; // 存储已经选择的地区数据
}

@property (nonatomic, strong) NSArray *controllers;

//@property (strong, nonatomic) ZSFQAddressRequest *request;

@end

@implementation FFSwipableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.65]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (instancetype)initWithTitle:(NSString *)title andSubTitles:(NSArray *)subTitles {

    self = [super init];
    if (self) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        [self initAllGlobleParams];
        
        NSMutableArray *vcs = [NSMutableArray array];
        for (int i = 0; i < 4; i++) {
            UIViewController *vc = [UIViewController new];
            [vcs addObject:vc];
        }
        
        _controllers = [NSArray arrayWithArray:vcs];
        
        UIView *topTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, kStartYPosition, kScreenWidth, kTopTitleHeight)];
        [topTitleView setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:topTitleView];
        
        //添加titlebar
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 10, kScreenWidth - 80, 20)];
        [titleLabel setText:title];
        [titleLabel setTextColor:[UIColor colorWithRed:(182.0 / 255.0) green:(182.0 / 255.0) blue:(182.0 / 255.0) alpha:1.0]];
        [titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [topTitleView addSubview:titleLabel];
        
        UIView *closeView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth - 100, 0, 100, kTopTitleHeight)];
        [closeView setBackgroundColor:[UIColor whiteColor]];
        closeView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapAction)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [closeView addGestureRecognizer:tap];
        [topTitleView addSubview:closeView];
        
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeBtn setFrame:CGRectMake(kScreenWidth - 27, 13, 14, 14)];
        [closeBtn setImage:[UIImage imageNamed:@"FFPopViewClose"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(backgroundTapAction) forControlEvents:UIControlEventTouchUpInside];
        [topTitleView addSubview:closeBtn];
        
        
        //添加subTitleBar
        _titleBar = [[FFTitleBarView alloc] initWithFrame:CGRectMake(0, kStartYPosition + 40, kScreenWidth, kTopTitleHeight) andTitles:subTitles];
        _titleBar.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_titleBar];
        
        //设置viewpager
        _viewPager = [[FFHorizonalTableViewController alloc] initWithViewControllers:_controllers];
        _viewPager.view.frame = CGRectMake(0, kStartYPosition + 80 , kScreenWidth, kScreenHeight - kStartYPosition - 80);
        
        [self addChildViewController:self.viewPager];
        [self.view addSubview:_viewPager.view];
        
        __weak FFTitleBarView *weakTitleBar = _titleBar;
        __weak FFHorizonalTableViewController *weakViewPager = _viewPager;
        
        _viewPager.changeIndex = ^(NSUInteger index){
        };
        
        _viewPager.scrollView = ^(CGFloat offsetRadio, NSUInteger currentIndex, NSUInteger aimIndex){
            if (aimIndex >= weakTitleBar.titleButtons.count) {
                aimIndex = weakTitleBar.titleButtons.count - 1;
            }
            UIButton *titleFromBtn = weakTitleBar.titleButtons[currentIndex];
            UIButton *titleToBtn = weakTitleBar.titleButtons[aimIndex];
            if (aimIndex > currentIndex) {
                titleToBtn.enabled = YES;
                titleToBtn.hidden = NO;
                [titleFromBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
                [titleToBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
                
                NSUInteger tempFocus = aimIndex + 1;
                while (tempFocus < _titleBar.titleButtons.count) {
                    UIButton *tempBtn = weakTitleBar.titleButtons[tempFocus];
                    [tempBtn setTitle:@"请选择" forState:UIControlStateNormal];
                    [tempBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
                    tempBtn.enabled = NO;
                    tempBtn.hidden = YES;
                    tempFocus++;
                }
                
            } else if(aimIndex < currentIndex) {
            }
            [titleFromBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [titleToBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            weakTitleBar.currentIndex = aimIndex;
            UIView *_line = [weakTitleBar viewWithTag:1050];
            CGFloat itemWidth_line = weakTitleBar.frame.size.width * 1.0 / weakTitleBar.titleButtons.count;
            [UIView animateWithDuration:0.2 animations:^{
                [_line setFrame:CGRectMake(itemWidth_line * aimIndex + itemWidth_line * 1.0 / 2.0 - kSelLineWidth * 1.0 / 2.0, weakTitleBar.frame.size.height - 0.5f, kSelLineWidth, 0.5f)];
            }];
            
        };
        
        _viewPager.scrollViewNew = ^(BOOL btnHidden, NSUInteger currentIndex, NSUInteger aimIndex){
            if (aimIndex >= weakTitleBar.titleButtons.count) {
                aimIndex = weakTitleBar.titleButtons.count - 1;
            }
            UIButton *titleFromBtn = weakTitleBar.titleButtons[currentIndex];
            UIButton *titleToBtn = weakTitleBar.titleButtons[aimIndex];
            if (aimIndex > currentIndex) {
                titleToBtn.enabled = YES;
                titleToBtn.hidden = NO;
                [titleFromBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
                [titleToBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
                
                NSUInteger tempFocus = aimIndex + 1;
                if (btnHidden) {
                    while (tempFocus < _titleBar.titleButtons.count) {
                        UIButton *tempBtn = weakTitleBar.titleButtons[tempFocus];
                        [tempBtn setTitle:@"请选择" forState:UIControlStateNormal];
                        [tempBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
                        tempBtn.enabled = NO;
                        tempBtn.hidden = YES;
                        tempFocus++;
                    }
                }
            } else if(aimIndex < currentIndex) {
                
            }
            [titleFromBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [titleToBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            weakTitleBar.currentIndex = aimIndex;
            UIView *_line = [weakTitleBar viewWithTag:1050];
            CGFloat itemWidth_line = weakTitleBar.frame.size.width * 1.0 / weakTitleBar.titleButtons.count;
            [UIView animateWithDuration:0.2 animations:^{
                [_line setFrame:CGRectMake(itemWidth_line * aimIndex + itemWidth_line * 1.0 / 2.0 - kSelLineWidth * 1.0 / 2.0, weakTitleBar.frame.size.height - 0.5f, kSelLineWidth, 0.5f)];
            }];
            
        };
        
#pragma mark - titlebar 的按钮点击时执行的方法，在此处进行数据处理
        _titleBar.titleButtonClicked = ^(NSInteger index){
            _zyaType = (int)index;
            [weakViewPager scrollToViewAtIndex:index hidBtn:NO];
        };
        
        [self initAllTableView];
    }
    return self;
}

- (void)show {
    
//    [self.request getProvinceWithDict:nil onSuccess:^(NSDictionary *dictResult) {
    _areaDataDic[_dictAllKeys[0]] = [self readLocalFileWithName:@"Province"][@"addressList"];//dictResult[@"addressList"];
        
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        //window.windowLevel = UIWindowLevelAlert;
        [window addSubview:self.view];
        [window bringSubviewToFront:self.view];
        [UIView animateWithDuration:0.5 animations:^{
            self.view.alpha = 1.0;
        }];
//    } andFailed:^(NSInteger code, NSString *errorMsg) {
//
//    }];
    
}

- (void)initAllGlobleParams {
    _curIndexPathArray = [NSMutableArray arrayWithCapacity:4];
    for (int i = 0; i < 4;  i++) {
        NSIndexPath *tempIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [_curIndexPathArray addObject:tempIndexPath];
    }
    _tableViewArray = [NSMutableArray array];
    _areaModelArray = [NSMutableArray array];
    _dictAllKeys = [NSArray arrayWithObjects:@"ZYLProvince", @"ZYLCity", @"ZYLCounty", @"ZYLTown", nil];
    _areaDataDic = [NSMutableDictionary dictionaryWithCapacity:4];
    _selAreaDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@{},@"0", @{}, @"1", @{}, @"2", @{},@"3", nil];
}

- (void)scrollToViewAtIndex:(NSInteger)index
{
    _viewPager.changeIndex(index);
}

- (void)backgroundTapAction {
    [UIView animateWithDuration:0.5 animations:^{
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
    }];
}

#pragma mark - tableview相关方法

- (void)initAllTableView {
    UINib *nib = [UINib nibWithNibName:kAreaCellID bundle:nil];
    
    for (int i = 0; i < 4; i++) {
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kStartYPosition - 80) style:UITableViewStylePlain];
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.tag = kTableViewBasedTag + i;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.rowHeight = 45;
        [tableView setBackgroundColor:[UIColor colorWithRed:(247.0 / 255.0) green:(247.0 / 255.0) blue:(249.0 / 255.0) alpha:1.0]];
        
        [tableView registerNib:nib forCellReuseIdentifier:kAreaCellID];
        [_tableViewArray addObject:tableView];
        
        UIViewController *curVC = _controllers[i];
        [curVC.view addSubview:tableView];
    }
}

#pragma mark - UITableViewDelegate & UITableViewDataSource 注意要实时更新_zyaType
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    NSString *curKey = _dictAllKeys[_zyaType];
//    NSArray *currentArray = [_areaDataDic objectForKey:curKey];
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *curKey = _dictAllKeys[_zyaType];
    NSArray *currentArray = [_areaDataDic objectForKey:curKey];
//    NSArray *sectionArray = currentArray[section];
    return  currentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *curKey = _dictAllKeys[_zyaType];
    NSArray *currentArray = [_areaDataDic objectForKey:curKey];

    if (currentArray.count == 0) {
        return [UITableViewCell new];
    }
    
    FFCell *cell = [tableView dequeueReusableCellWithIdentifier:kAreaCellID forIndexPath:indexPath];
    if (nil == cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:kAreaCellID owner:self options:nil].lastObject;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row >= currentArray.count) {
        return nil;
    }
    
    NSDictionary *model = currentArray[indexPath.row];
    cell.titleLabel.text = model[@"address"];
    NSIndexPath *curIndexPath = _curIndexPathArray[_zyaType];
    [cell setSelectedStatus:(curIndexPath.section == indexPath.section && curIndexPath.row == indexPath.row)];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_zyaType > 4) {
        return;
    }
    
    CGFloat horizonalOffset = _viewPager.tableView.contentOffset.y;
    NSUInteger focusIndex = (horizonalOffset + kScreenWidth / 6) / kScreenWidth;
    if (focusIndex != _zyaType) {
        return;
    }
    
    UITableView *currentTableView = (UITableView *)_tableViewArray[_zyaType];
    NSIndexPath *lastIndexPath = _curIndexPathArray[_zyaType];
    FFCell *lastCell = (FFCell *)[currentTableView cellForRowAtIndexPath:lastIndexPath];
    [lastCell setSelectedStatus:NO];
    
    NSArray *currentArray =  _areaDataDic[_dictAllKeys[_zyaType]];
    if (indexPath.row >= currentArray.count) {
        return;
    }
    
    NSDictionary *model = currentArray[indexPath.row];
    _curIndexPathArray[_zyaType] = indexPath;
    
    NSString *selCurKey = [NSString stringWithFormat:@"%i", _zyaType];
    
    [_selAreaDic setObject:model forKey:selCurKey];
    
    [_titleBar updateCurrentBtnTitle:model[@"address"] level:_zyaType];
    FFCell *cell = (FFCell *)[currentTableView cellForRowAtIndexPath:indexPath];
    [cell setSelectedStatus:YES];
    [self resetCurrentIndexPathFromType:_zyaType];
    if (_zyaType == FFAreaSelectedTypeTown) {
        
        if (_selectDoneAddress) {
            _selectDoneAddress(_selAreaDic);
        }
        [self backgroundTapAction];
    }
    else {
        [self loadnextAreaType:(_zyaType+1) preId:model[@"id"]];
    }
}

- (void)loadnextAreaType:(FFAreaSelectedType)type preId:(NSString *)preId {
    
    switch (type) {
        case FFAreaSelectedTypeCity: {
//            [self.request getCityWithDict:@{@"provinceId":preId} onSuccess:^(NSDictionary *dictResult) {
            _areaDataDic[_dictAllKeys[1]] = [self readLocalFileWithName:@"Province1"][@"addressList"];//dictResult[@"addressList"];
                [self udpateInterfaceWithType:type];
//            } andFailed:^(NSInteger code, NSString *errorMsg) {
//
//            }];
        } break;
            
        case FFAreaSelectedTypeCounty: {
//            [self.request getCountyWithDict:@{@"cityId":preId} onSuccess:^(NSDictionary *dictResult) {
                _areaDataDic[_dictAllKeys[2]] = [self readLocalFileWithName:@"Province2"][@"addressList"];//dictResult[@"addressList"];
                [self udpateInterfaceWithType:type];
//            } andFailed:^(NSInteger code, NSString *errorMsg) {
//
//            }];
        }  break;
            
        case FFAreaSelectedTypeTown: {
//            [self.request getTownWithDict:@{@"countyId":preId} onSuccess:^(NSDictionary *dictResult) {
            
//                if (0 == [dictResult[@"addressList"] count]) {
//                    if (_selectDoneAddress) {
//                        //            _selectDoneAction();
//                        //            NSMutableString *resultStr = [NSMutableString string];
//                        _selectDoneAddress(_selAreaDic);
//                    }
//                    [self backgroundTapAction];
//                } else {
                    _areaDataDic[_dictAllKeys[3]] = [self readLocalFileWithName:@"Province3"][@"addressList"];// dictResult[@"addressList"];
                    [self udpateInterfaceWithType:type];
//                }
//           } andFailed:^(NSInteger code, NSString *errorMsg) {
//
//            }];
        }  break;
            
        default:
            break;
    }

}

- (void)udpateInterfaceWithType:(FFAreaSelectedType)type {
    
    UITableView *tableView = (UITableView *)_tableViewArray[type];
    _zyaType = type;
    [tableView reloadData];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_viewPager scrollToViewAtIndex:type hidBtn:YES];
    });
}


- (void)resetCurrentIndexPathFromType:(FFAreaSelectedType)type {
    if (_curIndexPathArray.count <= 0) {
        return;
    }
    for (int i = (type + 1); i < 4; i++) {
        _curIndexPathArray[i] = [NSIndexPath indexPathForRow:0 inSection:0];
        UIButton *currentBtn = _titleBar.titleButtons[i];
        [currentBtn setTitle:@"请选择" forState:UIControlStateNormal];
    }
}

// 读取本地JSON文件
- (NSDictionary *)readLocalFileWithName:(NSString *)name {
    // 获取文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"json"];
    // 将文件数据化
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    // 对数据进行JSON格式化并返回字典形式
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}

//- (ZSFQAddressRequest *)request {
//
//    if (!_request) {
//        _request = [[ZSFQAddressRequest alloc] init];
//    }
//    return _request;
//}

@end
