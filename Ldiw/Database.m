//
//  Database.m
//  Ldiw
//
//  Created by Lauri Eskor on 2/18/13.
//  Copyright (c) 2013 Mobi Solutions. All rights reserved.
//

#import "Database.h"

@interface Database (Private)
// Base database methods
- (NSArray *)listCoreObjectsNamed:(NSString *)coreName withPredicate:(NSPredicate *)predicate;
- (NSArray *)listCoreObjectsNamed:(NSString *)coreName withPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sDescriptors;
- (NSFetchedResultsController *)fetchedResultsControllerUsingFetchRequest:(NSFetchRequest *)request;
- (NSFetchedResultsController *)fetchedResultsControllerUsingFetchRequest:(NSFetchRequest *)request sectionKeyPath:(NSString *)sectionKeyPath;
- (NSFetchedResultsController *)fetchedControllerForObject:(NSString *)entityName withPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sDescriptors;
- (NSFetchedResultsController *)fetchedControllerForObject:(NSString *)entityName withPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sDescriptors sectionKeyPath:(NSString *)sectionKeyPath;
- (NSFetchRequest *)fetchRequestFor:(NSString *)coreName withPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sDescriptors;
- (NSArray *)listCoreObjectsNamed:(NSString *)coreName withPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sDescriptors distinctValues:(BOOL)distinct;
- (id)findCoreDataObjectNamed:(NSString *)coreName withPredicate:(NSPredicate *)predicate limit:(int)limit;

- (NSManagedObjectContext *)managedObjectContext;
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator;
- (NSURL *)applicationDocumentsDirectory;
@end

@implementation Database
@synthesize storeUrl, storeType, managedObjectContext, managedObjectModel, persistentStoreCoordinator;

+ (Database *)sharedInstance {
  static dispatch_once_t pred;
  static Database *sharedInstance = nil;
  
  dispatch_once(&pred, ^{ sharedInstance = [[self alloc] init]; });
  return sharedInstance;
}


#pragma mark - Core Data stack
- (id)initWithStoreUrl:(NSURL *)url storeType:(NSString *)type {
  self = [super init];
  
  if (self != nil) {
    [self setStoreType:type];
    [self setStoreUrl:url];
  }
  return self;
}

- (id)initWithStoreName:(NSString *)storeName {
  NSURL *url = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:storeName];
  return [self initWithStoreUrl:url storeType:NSSQLiteStoreType];
}

- (id)init {
  return [self initWithStoreName:@"Ldiw.sql"];
}

- (NSURL *)applicationDocumentsDirectory {
  return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (void)saveContext {
  NSError *error = nil;
  NSManagedObjectContext *newManagedObjectContext = self.managedObjectContext;
  if (newManagedObjectContext != nil) {
    if ([newManagedObjectContext hasChanges] && ![newManagedObjectContext save:&error]) {
      /*
       Replace this implementation with code to handle the error appropriately.
       
       abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
       */
      MSLog(@"Unresolved error %@, %@", error, [error userInfo]);
      
      abort();
    }
  }
  MSLog(@"Save context");
}

- (id)findCoreDataObjectNamed:(NSString *)coreName withPredicate:(NSPredicate *)predicate {
  return [self findCoreDataObjectNamed:coreName withPredicate:predicate limit:0];
}

- (id)findCoreDataObjectNamed:(NSString *)coreName withPredicate:(NSPredicate *)predicate limit:(int)limit {
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  NSEntityDescription *entity = [NSEntityDescription entityForName:coreName inManagedObjectContext:self.managedObjectContext];
  if (!entity) {
    MSLog(@"No entity for coreName %@", coreName);
    abort();
  }
  
  [fetchRequest setEntity:entity];
  [fetchRequest setPredicate:predicate];
  
  if (limit > 0) {
    [fetchRequest setFetchLimit:limit];
  }
  
  NSError *error = nil;
  NSArray *objects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
  if (error != nil) {
    MSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    abort();
  }
  if ([objects count] != 1) {
    if ([objects count] > 1) {
      MSLog(@"WARNING: findCoreDataObjectNamed:%@ withPredicate:%@ - found %d items", coreName, predicate, [objects count]);
    } else {
      return nil;
    }
  }
  return [objects objectAtIndex:0];
}

- (NSArray *)listCoreObjectsNamed:(NSString *)coreName {
  return [self listCoreObjectsNamed:coreName withPredicate:nil];
}

- (NSArray *)listCoreObjectsNamed:(NSString *)coreName withPredicate:(NSPredicate *)predicate {
  return [self listCoreObjectsNamed:coreName withPredicate:predicate sortDescriptors:nil distinctValues:FALSE];
}

- (NSArray *)listCoreObjectsNamed:(NSString *)coreName withPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sDescriptors {
  return [self listCoreObjectsNamed:coreName withPredicate:predicate sortDescriptors:sDescriptors distinctValues:FALSE];
}

- (NSArray *)listCoreObjectsNamed:(NSString *)coreName withPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sDescriptors distinctValues:(BOOL)distinct {
  NSFetchRequest *fetchRequest = [self fetchRequestFor:coreName withPredicate:predicate sortDescriptors:sDescriptors];
  if (distinct) {
    [fetchRequest setReturnsDistinctResults:TRUE];
  }
  
  NSError *error = nil;
  NSArray *objects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
  
  if (error != nil) {
    MSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    abort();
  }
  
  return objects;
}

- (NSFetchedResultsController *)fetchedControllerForObject:(NSString *)entityName withPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sDescriptors {
  return [self fetchedControllerForObject:entityName withPredicate:predicate sortDescriptors:sDescriptors sectionKeyPath:nil];
}

- (NSFetchedResultsController *)fetchedControllerForObject:(NSString *)entityName withPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sDescriptors sectionKeyPath:(NSString *)sectionKeyPath {
  NSFetchRequest *request = [self fetchRequestFor:entityName withPredicate:predicate sortDescriptors:sDescriptors];
  return [self fetchedResultsControllerUsingFetchRequest:request sectionKeyPath:sectionKeyPath];
}

- (NSFetchedResultsController *)fetchedResultsControllerUsingFetchRequest:(NSFetchRequest *)request {
  return [self fetchedResultsControllerUsingFetchRequest:request sectionKeyPath:nil];
}

- (NSFetchedResultsController *)fetchedResultsControllerUsingFetchRequest:(NSFetchRequest *)request sectionKeyPath:(NSString *)sectionKeyPath {
  return [[NSFetchedResultsController alloc]
          initWithFetchRequest:request
          managedObjectContext:[self managedObjectContext]
          sectionNameKeyPath:sectionKeyPath cacheName:nil];
}

- (NSFetchRequest *)fetchRequestFor:(NSString *)coreName withPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sDescriptors {
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  NSEntityDescription *entity = [NSEntityDescription entityForName:coreName inManagedObjectContext:self.managedObjectContext];
  [fetchRequest setEntity:entity];
  
  if (predicate != nil) {
    [fetchRequest setPredicate:predicate];
  }
  
  if (sDescriptors != nil) {
    [fetchRequest setSortDescriptors:sDescriptors];
  }
  
  return fetchRequest;
}

- (NSManagedObjectModel *)managedObjectModel {
  
  if (managedObjectModel != nil) {
    return managedObjectModel;
  }
  
  // For data migration.
  NSString *path = [[NSBundle mainBundle] pathForResource:@"Ldiw" ofType:@"momd"];
  NSURL *momURL = [NSURL fileURLWithPath:path];  
  managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:momURL];
  
  return managedObjectModel;
}

- (void)addPersistentStore {
  // Handle light migration.
  NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
  
  NSError *error = nil;
  if (![persistentStoreCoordinator addPersistentStoreWithType:storeType configuration:nil URL:storeUrl options:options error:&error]) {
    MSLog(@"Possibly data model has changed. Uninstall and reinstall app in device/simulator. Error: %@, %@", error, [error userInfo]);
    abort();
  }
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
  if (persistentStoreCoordinator != nil) {
    return persistentStoreCoordinator;
  }
  persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
  [self addPersistentStore];
  return persistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext {
  if (managedObjectContext != nil) {
    return managedObjectContext;
  }
  
  NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
  if (coordinator != nil) {
    managedObjectContext = [[NSManagedObjectContext alloc] init];
    [managedObjectContext setPersistentStoreCoordinator:coordinator];
    [managedObjectContext setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
  }
  return managedObjectContext;
}

@end
