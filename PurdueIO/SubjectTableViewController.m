//
//  CourseTableViewController.m
//  PurdueIO
//
//  Created by Vedant Nevetia on 7/24/15.
//  Copyright (c) 2015 vnev. All rights reserved.
//

#import "SubjectTableViewController.h"
#import "AFNetworking.h"
#import "CoursesTableViewController.h"

@interface SubjectTableViewController ()

@property (strong, nonatomic) NSArray *subjects;

@end

@implementation SubjectTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getCourseData];
    self.filteredSubjectsArray = [NSMutableArray arrayWithCapacity:[self.subjects count]];
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
        self.subjects = [unsorted sortedArrayUsingDescriptors:descriptor];

        NSLog(@"Array: %@", self.subjects);
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
    return [self.subjects count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SubjectCell" forIndexPath:indexPath];
    NSDictionary *temp;
    // TODO: handle this search shit properly
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        temp = [self.filteredSubjectsArray objectAtIndex:indexPath.row];
    } else {
        temp = [self.subjects objectAtIndex:indexPath.row];
    }

    cell.textLabel.text = [temp objectForKey:@"Abbreviation"];
    cell.detailTextLabel.text = [temp objectForKey:@"Name"];
    
    return cell;
}

- (void)filterContentsForSearchText:(NSString *)searchText scope:(NSString *)scope
{
    [self.filteredSubjectsArray removeAllObjects];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name contains[c] %@", searchText];
    self.filteredSubjectsArray = [NSMutableArray arrayWithArray:[self.subjects filteredArrayUsingPredicate:predicate]];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    CoursesTableViewController *ctrlr = (CoursesTableViewController *)segue.destinationViewController;
    NSDictionary *temp = [self.subjects objectAtIndex:indexPath.row];
    NSString *selectedSubAbbr = [temp objectForKey:@"Abbreviation"];
    ctrlr.selectedCourse = selectedSubAbbr;
}

@end
