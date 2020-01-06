//
//  DoctorDetail.h
//
//  Created by   on 16/11/17
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface DoctorDetail : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *doctorName;
@property (nonatomic, strong) NSString *admittingService;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *doctorDetailIdentifier;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
