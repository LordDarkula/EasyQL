//
//  SQL.h
//  Operation Emoji
//
//  Created by Aubhro Sengupta on 5/13/16.
//  Copyright © 2016 Aubhro Sengupta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface SQL : NSObject

+ (void)createDB:(NSString *)tableName :(NSArray *)columnNames;
+ (void)setData:(NSString *)tableName :(NSArray *)columnNames :(NSMutableArray<NSMutableArray<NSString *> *> *)data;
+ (NSMutableArray *)getData:(NSString *)tableName;
+ (NSString *)getDatabasePath:(NSString *)tableName;

@end
