//
//  CourseTableViewController.h
//  PurdueIO
//
//  Created by Vedant Nevetia on 7/24/15.
//  Copyright (c) 2015 vnev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseTableViewController : UITableViewController <UISearchDisplayDelegate, UISearchBarDelegate>

// TODO: filter subjects/courses available via term
// @property (strong, nonatomic) NSString *term;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) NSMutableArray *filteredSubjectsArray;

@end
