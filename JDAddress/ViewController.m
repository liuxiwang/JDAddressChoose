//
//  ViewController.m
//  JDAddress
//
//  Created by liu xiwang on 2019/1/29.
//  Copyright © 2019 liu xiwang. All rights reserved.
//

#import "ViewController.h"
#import "FFSwipableViewController.h"
#define Weak(obj) autoreleasepool{} __weak typeof(obj) w##obj = obj;
#define Strong(obj) autoreleasepool{} __strong typeof(obj) obj = w##obj;
@interface ViewController ()
@property (nonatomic, strong) FFSwipableViewController *swaController;
@property (weak, nonatomic) IBOutlet UIButton *btnAddress;

- (IBAction)clickBtn:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)clickBtn:(id)sender {
    [self.swaController show];
}
- (FFSwipableViewController *)swaController {
    
    if (!_swaController) {
        _swaController = [[FFSwipableViewController alloc] init];
        
        _swaController = [[FFSwipableViewController alloc] initWithTitle:@"选择地址" andSubTitles:@[@"请选择", @"请选择", @"请选择", @"请选择"]];
        _swaController.view.alpha = 0;
        
        @Weak(self)
        _swaController.selectDoneAddress = ^(NSDictionary *address) {
            @Strong(self)
//            _provinceId = [address[@"0"][@"id"]integerValue];
//            _cityId = [address[@"1"][@"id"]integerValue];
//            _countyId = [address[@"2"][@"id"]integerValue];
//            _townId = [address[@"3"][@"id"]integerValue]==0?0:[address[@"3"][@"address"]integerValue];
//
//            _strProvince = address[@"0"][@"address"];
//            _strCity = address[@"1"][@"address"];
//            _strCounty = address[@"2"][@"address"];
//            _strTown = address[@"3"][@"address"]==nil?@"":address[@"3"][@"address"];
            NSString *strAddress = [NSString stringWithFormat:@"%@%@%@%@", address[@"0"][@"address"], address[@"1"][@"address"], address[@"2"][@"address"], address[@"3"][@"address"]==nil?@"":address[@"3"][@"address"]];
            [self.btnAddress setTitle:strAddress forState:normal];
        };
    }
    return _swaController;
}
@end
