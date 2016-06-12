//
//  TableViewContainer.h
//  GIFSearcher
//
//  Created by Ivan on 12.06.16.
//  Copyright © 2016 i_sokolov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ImageCell.h"

@interface TableViewContainer : NSObject<UITableViewDelegate, UITableViewDataSource>

@property(strong, nonatomic) NSArray *items;


@end
