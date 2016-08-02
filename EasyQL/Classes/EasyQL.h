//
//  EasyQL.h
//  Pods
//
//  Created by Aubhro Sengupta on 7/28/16.
//
//

#import <Foundation/Foundation.h>

@interface EasyQL : NSObject

+ (void)createDB:(NSString *)tableName :(NSArray *)columnNames;
+ (void)setData:(NSString *)tableName :(NSArray *)columnNames :(NSMutableArray<NSMutableArray<NSString *> *> *)data;
+ (NSMutableArray *)getData:(NSString *)tableName;
+ (NSString *)getDatabasePath:(NSString *)tableName;
+ (int)getNumberOfRows :(NSString *)tableName;
+ (int)applyQuery :(NSString *)tableName :(NSString *)query;

@end
