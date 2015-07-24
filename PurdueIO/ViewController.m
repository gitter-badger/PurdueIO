//
//  ViewController.m
//  PurdueIO
//
//  Created by Vedant Nevetia on 7/24/15.
//  Copyright (c) 2015 vnev. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"

@interface ViewController ()

@property (strong, nonatomic) NSArray *termArrayFromAF;
@property (strong, nonatomic) NSArray *finishedTermArray;

@end

@implementation ViewController

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.termArrayFromAF count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:  (NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary *tempDict = [self.termArrayFromAF objectAtIndex:indexPath.row];
    cell.textLabel.text = [tempDict objectForKey:@"Name"];
    
    return cell;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self makeTermRequest];
}

- (void)makeTermRequest
{
    NSURL *termRequestURL = [NSURL URLWithString:@"https://api.purdue.io/odata/Terms"];
    NSURLRequest *request = [NSURLRequest requestWithURL:termRequestURL];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.termArrayFromAF = [responseObject objectForKey:@"value"];
        
        NSLog(@"Output: %@", self.termArrayFromAF);
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Request failed: %@, %@", error, error.userInfo);
    }];
    
    [operation start];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *index = [self.tableView indexPathForSelectedRow];
    ViewController *courseViewController = (ViewController *)segue.destinationViewController;
    // TODO: filter result in CourseTVController depending on selected term
}

@end
