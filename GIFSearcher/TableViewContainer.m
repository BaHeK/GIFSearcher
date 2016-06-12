//
//  TableViewContainer.m
//  GIFSearcher
//
//  Created by Ivan on 12.06.16.
//  Copyright © 2016 i_sokolov. All rights reserved.
//

#import "TableViewContainer.h"
#import "Gifs.h"
#import <UIImageView-PlayGIF/UIImageView+PlayGIF.h>

@interface TableViewContainer() {
    NSMutableDictionary *dataDictionary;
    
    NSMutableArray *dataItems;
}

@end

@implementation TableViewContainer


-(id) init {
    self = [super init];
    if (self) {
        dataItems = [NSMutableArray array];
        dataDictionary =  [NSMutableDictionary dictionary];
    }
    
    return self;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_items count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GifCell" forIndexPath:indexPath];
    Gifs *gifItem = [_items objectAtIndex:indexPath.row];

    NSData *gifData = [dataDictionary objectForKey:gifItem.url];
    
    cell.cellPicture.image = nil;
    
    if (gifData) {
        cell.cellPicture.image = [UIImage imageWithData:gifData];
        cell.cellPicture.gifData = gifData;
        [cell.cellPicture startGIF];
      
        
    } else {

        cell.cellPicture.image = nil;
        NSURL *url = [NSURL URLWithString:gifItem.url];
        
        NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (data) {
                [dataDictionary setObject:data forKey:gifItem.url];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    ImageCell *updatedCell =  [tableView cellForRowAtIndexPath:indexPath];
                    updatedCell.cellPicture.image = [UIImage imageWithData:data];
                    updatedCell.cellPicture.gifData = data;
                    [updatedCell.cellPicture startGIF];
                });
 
            }
        }];
        [task resume];
      
    }
    
    return cell;
}

-(void)setItems:(NSArray *)newItems {
    if (newItems != _items) {
          _items = newItems;
        
          dataItems = [NSMutableArray arrayWithCapacity:[_items count]];
    }
    
  
    
    [dataDictionary removeAllObjects];
}


@end
