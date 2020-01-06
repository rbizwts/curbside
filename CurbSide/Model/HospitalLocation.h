//
//  HospitalLocation.h
//
//  Created by   on 16/11/17
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface HospitalLocation : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *hospitalLocationIdentifier;
@property (nonatomic, strong) NSString *locations;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
