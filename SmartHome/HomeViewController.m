//
//  HomeViewController.m
//  SmartHome
//
//  Created by Bharath G M on 2/18/15.
//  Copyright (c) 2015 Bharath G M. All rights reserved.
//

#import "HomeViewController.h"
#import "SprinklerViewController.h"

#define ROWHEIGHT 70;

@interface HomeViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView* deviceTableView;
}

@end

@implementation HomeViewController

@synthesize listOfDevices;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"List of Devices";
    [self initTableView];
}

-(void)initTableView
{
    deviceTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    deviceTableView.delegate = self;
    deviceTableView.dataSource = self;
    [self.view addSubview:deviceTableView];
}

#pragma mark --
#pragma mark Table View Data source methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [listOfDevices count];//no of objects
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.highlighted = NO;
    }
    
   cell.textLabel.text  = [(Device*)[listOfDevices objectAtIndex:indexPath.row] deviceName];
    if ([[(Device*)[listOfDevices objectAtIndex:indexPath.row] deviceName]  isEqual: @"sprinkler"])
    {
        cell.textLabel.text = @"Sprinkler"; //just using caps lock
        cell.imageView.image = [UIImage imageNamed:@"Sprinkler.jpg"];
        
    }
    return cell;
    
}

#pragma --
#pragma mark Table View Delegates
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SprinklerViewController *sprinklerController = [[SprinklerViewController alloc] init];
    sprinklerController.navigationItem.title = @"Sprinkler Device";
    [self.navigationController pushViewController:sprinklerController animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ROWHEIGHT
}


@end
