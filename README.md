# EasyQL

[![CI Status](http://img.shields.io/travis/Aubhro/EasyQL.svg?style=flat)](https://travis-ci.org/Aubhro/EasyQL)
[![Version](https://img.shields.io/cocoapods/v/EasyQL.svg?style=flat)](http://cocoapods.org/pods/EasyQL)
[![License](https://img.shields.io/cocoapods/l/EasyQL.svg?style=flat)](http://cocoapods.org/pods/EasyQL)
[![Platform](https://img.shields.io/cocoapods/p/EasyQL.svg?style=flat)](http://cocoapods.org/pods/EasyQL)

## Introduction

A quick and convenient way to create and manage local sqlite3 databases. Databases can be created with a single line of code. Data can be get and set without creating queries. Queries can also be passed in as a string.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

- iOS 8.0+ 
- Xcode 7.3+

## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

> CocoaPods 0.39.0+ is required to build EasyQL 

To install it, simply add the following line to your Podfile:

```ruby
pod "EasyQL"
```

## Author

Aubhro, aubhrosengupta@gmail.com

## License

EasyQL is available under the MIT license. See the LICENSE file for more info.

## Usage

First, import EasyQL
```objc
#import <EasyQL.h>
```

Create a table
```objc
// Table name stored in myTableName
NSString *name = @"myTableName";

// Columns named "first" and "second"
NSArray *columns = @[@"first", @"second"];

[EasyQL createDB:name :columns];
```

Add data to the table
```objc
NSMutableArray *data = [[NSMutableArray alloc] init];
[data insertObject:@[@"one", @"two"] atIndex:0];
[data insertObject:@[@"three", @"four"] atIndex:1];

[EasyQL setData:name :columns :data];
```

To get the data 
```objc
NSMutableArray *data = [EasyQL getData:name];
```
data would have the following structure
```objc
@[ @[ @"one", @"two"],
   @[ @"three", @"four"]]
```

To use queries with EasyQL
```objc

// This particular query deletes everything in the query, but any query should work
NSString *query = [NSString stringWithFormat:@"DELETE FROM %@", name];
[SQL applyQuery:name :query];
```

Thats it for now. I will keep adding functionality as time goes on.
