//
//  DoctorDetail.m
//
//  Created by   on 16/11/17
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "DoctorDetail.h"


NSString *const kDoctorDetailDoctorName = @"doctor_name";
NSString *const kDoctorDetailAdmittingService = @"admitting_service";
NSString *const kDoctorDetailStatus = @"status";
NSString *const kDoctorDetailId = @"Id";


@interface DoctorDetail ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DoctorDetail

@synthesize doctorName = _doctorName;
@synthesize admittingService = _admittingService;
@synthesize status = _status;
@synthesize doctorDetailIdentifier = _doctorDetailIdentifier;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.doctorName = [self objectOrNilForKey:kDoctorDetailDoctorName fromDictionary:dict];
            self.admittingService = [self objectOrNilForKey:kDoctorDetailAdmittingService fromDictionary:dict];
            self.status = [self objectOrNilForKey:kDoctorDetailStatus fromDictionary:dict];
            self.doctorDetailIdentifier = [self objectOrNilForKey:kDoctorDetailId fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.doctorName forKey:kDoctorDetailDoctorName];
    [mutableDict setValue:self.admittingService forKey:kDoctorDetailAdmittingService];
    [mutableDict setValue:self.status forKey:kDoctorDetailStatus];
    [mutableDict setValue:self.doctorDetailIdentifier forKey:kDoctorDetailId];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description  {
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict {
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];

    self.doctorName = [aDecoder decodeObjectForKey:kDoctorDetailDoctorName];
    self.admittingService = [aDecoder decodeObjectForKey:kDoctorDetailAdmittingService];
    self.status = [aDecoder decodeObjectForKey:kDoctorDetailStatus];
    self.doctorDetailIdentifier = [aDecoder decodeObjectForKey:kDoctorDetailId];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_doctorName forKey:kDoctorDetailDoctorName];
    [aCoder encodeObject:_admittingService forKey:kDoctorDetailAdmittingService];
    [aCoder encodeObject:_status forKey:kDoctorDetailStatus];
    [aCoder encodeObject:_doctorDetailIdentifier forKey:kDoctorDetailId];
}

- (id)copyWithZone:(NSZone *)zone {
    DoctorDetail *copy = [[DoctorDetail alloc] init];
    
    
    
    if (copy) {

        copy.doctorName = [self.doctorName copyWithZone:zone];
        copy.admittingService = [self.admittingService copyWithZone:zone];
        copy.status = [self.status copyWithZone:zone];
        copy.doctorDetailIdentifier = [self.doctorDetailIdentifier copyWithZone:zone];
    }
    
    return copy;
}


@end
