//
//  EasyQLTests.m
//  EasyQLTests
//
//  Created by Aubhro on 07/28/2016.
//  Copyright (c) 2016 Aubhro. All rights reserved.
//

@import XCTest;
@import EasyQL;

@interface Tests : XCTestCase

@end

@implementation Tests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    // Table name stored in myTableName
    NSString *name = @"myTableName";
    
    // Columns named "first" and "second"
    NSArray *columns = @[@"first", @"second"];
    
    [EasyQL createDB:name :columns];
    
    NSMutableArray *data = [[NSMutableArray alloc] init];
    [data insertObject:@[@"one", @"two"] atIndex:0];
    [data insertObject:@[@"three", @"four"] atIndex:1];
    
    [EasyQL setData:name :columns :data];
    
    NSMutableArray *dOut = [EasyQL getData:name];
    XCTAssertEqualObjects(dOut[0][0], @"one");
    XCTAssertEqualObjects(dOut[0][1], @"two");
    XCTAssertEqualObjects(dOut[1][0], @"three");
    XCTAssertEqualObjects(dOut[1][1], @"four");
}

@end

