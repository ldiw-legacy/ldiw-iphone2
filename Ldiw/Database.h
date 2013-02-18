//
//  Database.h
//  Ldiw
//
//  Created by Lauri Eskor on 2/18/13.
//  Copyright (c) 2013 Mobi Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Database : NSObject

@property (nonatomic, strong) NSURL *storeUrl;
@property (nonatomic, strong) NSString *storeType;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (Database *)sharedInstance;

@end
