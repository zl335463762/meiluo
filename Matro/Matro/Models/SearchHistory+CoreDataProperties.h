//
//  SearchHistory+CoreDataProperties.h
//  Matro
//
//  Created by NN on 16/3/30.
//  Copyright © 2016年 HeinQi. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "SearchHistory.h"

NS_ASSUME_NONNULL_BEGIN

@interface SearchHistory (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *keywork;

@end

NS_ASSUME_NONNULL_END
