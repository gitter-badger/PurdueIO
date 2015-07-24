//
//  CourseTableViewController.m
//  PurdueIO
//
//  Created by Vedant Nevetia on 7/24/15.
//  Copyright (c) 2015 vnev. All rights reserved.
//

#import "CourseTableViewController.h"
#import "AFNetworking.h"

@interface CourseTableViewController ()

@property (strong, nonatomic) NSArray *courses;

@end

@implementation CourseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getCourseData];
    self.filteredSubjectsArray = [NSMutableArray arrayWithCapacity:[self.courses count]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)getCourseData
{
    NSURL *subjectUrl = [NSURL URLWithString:@"https://api.purdue.io/odata/Subjects"];
    NSURLRequest *request = [NSURLRequest requestWithURL:subjectUrl];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *unsorted = [responseObject objectForKey:@"value"];
        NSArray *descriptor = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"Abbreviation" ascending:YES]];
        self.courses = [unsorted sortedArrayUsingDescriptors:descriptor];

        NSLog(@"Array: %@", self.courses);
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failed to get response: %@", error);
    }];
    
    [operation start];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // TODO: handle this search shit properly
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.filteredSubjectsArray count];
    }
    return [self.courses count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SubjectCell" forIndexPath:indexPath];
    NSDictionary *temp;
    // TODO: handle this search shit properly
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        temp = [self.filteredSubjectsArray objectAtIndex:indexPath.row];
    } else {
        temp = [self.courses objectAtIndex:indexPath.row];
    }

    cell.textLabel.text = [temp objectForKey:@"Abbreviation"];
    cell.detailTextLabel.text = [temp objectForKey:@"Name"];
    
    return cell;
}

- (void)filterContentsForSearchText:(NSString *)searchText scope:(NSString *)scope
{
    [self.filteredSubjectsArray removeAllObjects];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name contains[c] %@", searchText];
    self.filteredSubjectsArray = [NSMutableArray arrayWithArray:[self.courses filteredArrayUsingPredicate:predicate]];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentsForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentsForSearchText:self.searchDisplayController.searchBar.text scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    return YES;
}


@end
