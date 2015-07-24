//
//  CoursesTableViewController.m
//  PurdueIO
//
//  Created by Vedant Nevetia on 7/24/15.
//  Copyright (c) 2015 vnev. All rights reserved.
//

#import "CoursesTableViewController.h"
#import "AFNetworking.h"

@interface CoursesTableViewController ()

@property (strong, nonatomic) NSArray *courses;

@end

@implementation CoursesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getCourses:self.selectedCourse];
    
}

- (void)getCourses:(NSString *)selectedCourseAbbr
{
    NSString *urlString = [NSString stringWithFormat:@"http://api.purdue.io/odata/Courses?$filter=Subject/Abbreviation eq '%@'&$orderby=Number asc", selectedCourseAbbr];
    urlString = [urlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"$" withString:@"%24"];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"'" withString:@"%27"];
    NSLog(@"%@", urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.courses = [responseObject objectForKey:@"value"];
        NSLog(@"Courses Response: %@", self.courses);
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error fetching course data: %@", error);
    }];
    
    [operation start];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.courses count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CourseCell" forIndexPath:indexPath];
    NSDictionary *temp = [self.courses objectAtIndex:indexPath.row];
    cell.textLabel.text = [temp objectForKey:@"Title"];
    NSString *subtitle = [temp objectForKey:@"Number"];
    // TODO: add description maybe?
//    if (![[temp objectForKey:@"Description"]  isEqual: @""]) {
//        subtitle = [subtitle stringByAppendingFormat:@"%@ - %@", [temp objectForKey:@"Number"], [temp objectForKey:@"Description"]];
//    } else { }
    
    cell.detailTextLabel.text = subtitle;
    return cell;
}



@end
