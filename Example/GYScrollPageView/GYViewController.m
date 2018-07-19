//
//  GYViewController.m
//  GYScrollPageView
//
//  Created by inoryshu on 07/16/2018.
//  Copyright (c) 2018 Apocalypse. All rights reserved.
//

#import "GYViewController.h"
#import "GYTest1ViewController.h"

@interface GYViewController ()<UITableViewDelegate,UITableViewDataSource>
@end

@implementation GYViewController

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    

    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableViewCell" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    switch (indexPath.row) {
        case 3:
            cell.textLabel.text = @"嵌套滚动2";
            break;
        case 2:
            cell.textLabel.text = @"嵌套滚动1";
            break;
        case 0:
            cell.textLabel.text = @"分页1";
            break;
        case 1:
            cell.textLabel.text = @"分页2";
            break;
        default:
            cell.textLabel.text = nil;
            break;
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 2:{
//            Test1VC *vc = [[Test1VC alloc] init];
//            vc.title = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
//            [self.navigationController pushViewController:vc animated:true];
        }break;
        case 3:{
//            Test3VC *vc = [[Test3VC alloc] init];
//            [self.navigationController pushViewController:vc animated:true];
        }break;
        case 0:
        case 1:{
GYTest1ViewController *vc = [[GYTest1ViewController alloc] init];
//            vc.type = (int)indexPath.row;
            vc.title = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
            [self.navigationController pushViewController:vc animated:true];
        }break;
            
        default:
            break;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
