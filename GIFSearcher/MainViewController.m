//
//  ViewController.m
//  GIFSearcher
//
//  Created by Ivan on 12.06.16.
//  Copyright © 2016 i_sokolov. All rights reserved.
//

#import "MainViewController.h"
#import <RestKit.h>
#import <CoreData.h>
#import "TableViewContainer.h"
#import "Gifs.h"
typedef NS_ENUM(NSUInteger, DisplayState) {
    ShowTrendsDisplayState,
    ShowSearchResultDisplayState
};

@interface MainViewController () {
    NSArray *giphyItems;
    NSMutableDictionary *gifs;
    TableViewContainer *container;
    
    NSArray *trendingsData;
    NSArray *searchData;
    
    DisplayState state;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    container = [[TableViewContainer alloc] init];
    
    self.tableView.dataSource = container;
    self.tableView.delegate = container;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44.0;
    
    searchData = [NSArray array];
    trendingsData = [NSArray array];
    
    state = ShowTrendsDisplayState;
  
    [self loadTrendingGifs];
}

-(void) loadTrendingGifs {
    if ([trendingsData count] > 0) {
        [container setItems:trendingsData];
        [self.tableView reloadData];
    } else {
        NSString *url  = @"http://api.giphy.com/v1/gifs/trending?";
        [self loadGifsFromUrl:url withPath:@"/v1/gifs/trending"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) loadGifsFromUrl:(NSString *)url withPath:(NSString *)pathPattern {
    
    RKObjectMapping *itemMapping = [RKObjectMapping mappingForClass:[Gifs class]];
    [itemMapping addAttributeMappingsFromDictionary:@{
                                                      @"url": @"url"
                                                      }];
    
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:itemMapping method:RKRequestMethodAny pathPattern:pathPattern keyPath:@"data.images.fixed_height" statusCodes:statusCodes];
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@api_key=dc6zaTOxFJmzC", url]]];
    
    RKObjectRequestOperation *operation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[responseDescriptor]];

    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
    
        if (state == ShowTrendsDisplayState) {
            trendingsData = [result array];
            [container setItems:trendingsData];
        } else {
           searchData = [result array];
           [container setItems:searchData];
        }
        
        [self.tableView reloadData];
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Failed with error: %@", [error localizedDescription]);
    }];
    
    [operation start];

}


#pragma mark - TableView Delegate/DatSource

#pragma mark  - SearchBar Delegate

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *searchString = [searchBar.text stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSString *url  = [NSString stringWithFormat:@"http://api.giphy.com/v1/gifs/search?q=%@&", searchString];
    
    state = ShowSearchResultDisplayState;
    
    [searchBar resignFirstResponder];
    
    [self loadGifsFromUrl:url withPath:@"/v1/gifs/search"];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    if (searchBar.text.length < 1) {
        state = ShowTrendsDisplayState;
        
        [self loadTrendingGifs];
    }

    [searchBar endEditing:YES];
}

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = YES;
    [container setItems:nil];
    [self.tableView reloadData];
    return YES;
}

-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = NO;
    
    [searchBar resignFirstResponder];
    
    return YES;
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    if (searchBar.text.length < 1) {
        state = ShowTrendsDisplayState;
        
        [self loadTrendingGifs];
    }
    
}

@end
