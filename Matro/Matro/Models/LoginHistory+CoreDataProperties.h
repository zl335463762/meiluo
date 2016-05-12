//
//  LoginHistory+CoreDataProperties.h
//  Matro
//
//  Created by NN on 16/4/5.
//  Copyright © 2016年 HeinQi. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "LoginHistory.h"

NS_ASSUME_NONNULL_BEGIN

@interface LoginHistory (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *loginkeyword;

@end

NS_ASSUME_NONNULL_END
