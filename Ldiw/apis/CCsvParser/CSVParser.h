//
//  CSVParser.h
//  CSVParser
//
//  Created by Ha Minh Vuong on 8/31/12.
// Modified to accept input from NSString by Lauri Eskor 20.02.2013
//  Copyright (c) 2012 Ha Minh Vuong. All rights reserved.
//

@interface CSVParser : NSObject

+ (NSArray *)parseCSVIntoArrayOfDictionariesFromFile:(NSString *)path
                        withSeparatedCharacterString:(NSString *)character
                                quoteCharacterString:(NSString *)quote;

+ (NSArray *)parseCSVIntoArrayOfArraysFromFile:(NSString *)path
                  withSeparatedCharacterString:(NSString *)character
                          quoteCharacterString:(NSString *)quote;

+ (void)parseCSVIntoArrayOfDictionariesFromFile:(NSString *)path
                   withSeparatedCharacterString:(NSString *)character
                           quoteCharacterString:(NSString *)quote
                                      withBlock:(void (^)(NSArray *array))block;

+ (void)parseCSVIntoArrayOfArraysFromFile:(NSString *)path
             withSeparatedCharacterString:(NSString *)character
                     quoteCharacterString:(NSString *)quote
                                withBlock:(void (^)(NSArray *array))block;

+ (NSArray *)parseCSVIntoArrayOfDictionariesFromString:(NSString *)csvString
                        withSeparatedCharacterString:(NSString *)character
                                quoteCharacterString:(NSString *)quote;

@end