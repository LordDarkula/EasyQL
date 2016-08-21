//
//  SQL.m
//  Operation Emoji
//
//  Created by Aubhro Sengupta on 5/13/16.
//  Copyright © 2016 Aubhro Sengupta. All rights reserved.
//

#import "SQL.h"

@implementation SQL
sqlite3 *DB;

// Creates database and table
+ (void)createDB:(NSString *)tableName :(NSArray *)columnNames {

    // Build the path to the database file
    NSString *databasePath = [self getDatabasePath:tableName];

    // Creates file manager
    NSFileManager *fileManager = [NSFileManager defaultManager];

    // If table does not exists at the path
    if (![fileManager fileExistsAtPath:databasePath]) {

        // Converts path to char so sql can understand it
        const char *dbPath = [databasePath UTF8String];


        // Opens database using path and finds out if that was successful
        if (sqlite3_open(dbPath, &DB) == SQLITE_OK) {

            // Creates reference to store error message
            char *errMsg;

            NSString *sqlString = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (ID INTEGER PRIMARY KEY AUTOINCREMENT", tableName];

            // Initializes query to create table
            for (int i = 0; i < columnNames.count; i++) {
                sqlString = [sqlString stringByAppendingString:[NSString stringWithFormat:@", %@ TEXT",
                                                                                          columnNames[(NSUInteger) i]]];

            }
            sqlString = [sqlString stringByAppendingString:@")"];

            // Converts query to char so sql can understand it
            const char *sql_stmt = [sqlString UTF8String];
            NSLog(@"This is the thingy dats failing%@", sqlString);
            // Executes query and logs result
            if (sqlite3_exec(DB, sql_stmt, NULL, NULL, &errMsg) == SQLITE_OK) {

                NSLog(@"Table created");


            } else {

                NSLog(@"Failed to create table");

            }


            // Closes database
            sqlite3_close(DB);
            NSLog(@"Database successfully created");

        } else {
            NSLog(@"Failed to open/create database");
        }

        NSLog(@"Successfully connected to database");
    } else {
        NSLog(@"Table exists");
    }

}

// Saves data inside 2D mutable array data to the database named tableName given an array containing all the column names
+ (void)setData:(NSString *)tableName :(NSArray *)columnNames :(NSMutableArray *)data {

    // Build the path to the database file
    NSString *databasePath = [self getDatabasePath:tableName];

    // Initializes sqlite statement
    sqlite3_stmt *statement;

    // Converts path to char so sql can understand it
    const char *dbPath = [databasePath UTF8String];

    // Open database and if it is successful
    if (sqlite3_open(dbPath, &DB) == SQLITE_OK) {
        NSLog(@"setData opening database successful");
        // Creates query that selects entire database
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT COUNT(*) FROM %@", tableName];
        
        /*
         Code below returns the number of rows in a table
         */
        sqlite3_stmt *countStatement;
        
        // Converts query to char so sql can understand it
        const char *query_stmt = [querySQL UTF8String];
        
        
        int count = 0;
        
        // Compiles query to byte code and places result inside statement
        if (sqlite3_prepare_v2(DB,
                               query_stmt, -1, &countStatement, NULL) == SQLITE_OK) {

            if( sqlite3_step(countStatement) == SQLITE_ROW ) {
                count = sqlite3_column_int(countStatement, 0);
                NSLog(@"Number of rows %d", count);
            }
            sqlite3_finalize(countStatement);
        }
        NSLog(@"Number of rows %d", count);
        /*
        The code above allows count to return the number of rows
         */
        
        // Loops through rows in data
        for (int row = 0; row < data.count; row++) {
            
            // Creates stub for adding row at index number of columns + row
            NSString *insert = [NSString stringWithFormat:@"INSERT INTO %@ VALUES ( %d, " , tableName, (row + count)];

            // Loops through columns in data
            for (int column = 0; column < columnNames.count; column++) {
                
                // Adds each piece of data that needs to be added to query
                insert = [insert stringByAppendingString:[NSString stringWithFormat:@" \"%@\",", data[(NSUInteger)row][(NSUInteger) column]]];

            }
            // Removes the comma at the end of the query
            insert = [insert substringToIndex:insert.length -1];
            
            // Closes the parenthesis that holds the data
            insert = [insert stringByAppendingString:@" )"];
            
            NSLog(@"Save data query %@", insert);
            
            // Converts query to char so sql can understand it
            const char *insert_stmt = [insert UTF8String];
            
            // Compiles query to byte code and places it inside statement
            sqlite3_prepare_v2(DB, insert_stmt,
                               -1, &statement, NULL);
            
            // Executes byte code inside statement and if it is successful
            if (sqlite3_step(statement) == SQLITE_DONE) {
                
                // Prints out success
                NSLog(@"Question added");
            } else {
                // Prints out failure
                NSLog(@"Question adding failed");
            }
            sqlite3_finalize(statement);

        }
        NSLog(@"Database closing");
        sqlite3_close(DB);
    } else {
        NSLog(@"Could not connect to database");
    }
}

// Gets a 2D mutable with all the data inside the table named tableName
+ (NSMutableArray *)getData:(NSString *)tableName {


    // Finds database path using gatDatabasePath method and converts it to NSString.
    const char *dbPath = [[self getDatabasePath:tableName] UTF8String];

    // Creates sqlite3_stmt to be initialized later.
    sqlite3_stmt *statement;

    // Initializes mutable array to hold data from the table.
    NSMutableArray *data = [[NSMutableArray alloc] init];

    // Opens table using dbPath and DB
    if (sqlite3_open(dbPath, &DB) == SQLITE_OK) {
        NSLog(@"getData opening database successful");
        // Creates query that selects entire database
        NSString *querySQL = [NSString stringWithFormat:
                @"SELECT * FROM %@", tableName];

        // Converts query to char so sql can understand it
        const char *query_stmt = [querySQL UTF8String];

        // Compiles query to byte code and places result inside statement
        if (sqlite3_prepare_v2(DB,
                query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            NSLog(@"getData preparing query successful");

            // Creates blank mutable array to place the data of a single row inside
            NSMutableArray *rowData = [[NSMutableArray alloc] init];
            
            // While cursor is still on a row, keep executing statement
            while (sqlite3_step(statement) == SQLITE_ROW) {

                // Loops through columns of the table at that selected row
                for (int column = 1; column < sqlite3_column_count(statement); column++) {
                    NSLog(@"This is the number of columns %d",sqlite3_column_count(statement));
                    NSString *placeHolderString = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, column)];
                    
                    // Insert text at that selected column into rowData at next available index
                    [rowData insertObject:placeHolderString atIndex:(NSUInteger)rowData.count];
                    
                   // NSLog(@"This is the element returned from table %@", [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)]);
                
                    NSLog(@"Say sry i was never bein problematic  %@", rowData[(rowData.count-1)]);
                }
                NSLog(@"Dis is column count %d", sqlite3_column_count(statement));
                
                // Insert rowData into data at next possible index then wipe rowData to get ready for next row
                [data insertObject:rowData atIndex:(NSUInteger)data.count];
                rowData = [[NSMutableArray alloc] init];
                
            }
            sqlite3_finalize(statement);
        } else {
            NSLog(@"getData preparing query successful");
        }

    } else {
        NSLog(@"getData opening database unsuccessful");
    }
    sqlite3_close(DB);
    return data;
}

// Gets database path for table inside NSDocumentDirectory given tableName
+ (NSString *)getDatabasePath:(NSString *)tableName {
    NSString *docsDir;
    NSArray *dirPaths;

    // Gets the documents directory.
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];

    // Build the path to the database file
    return [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent:[NSString
            stringWithFormat:@"%@.db", tableName]]];
}


@end
