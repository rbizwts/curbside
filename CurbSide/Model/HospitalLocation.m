//
//  HospitalLocation.m
//
//  Created by   on 16/11/17
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "HospitalLocation.h"


NSString *const kHospitalLocationStatus = @"status";
NSString *const kHospitalLocationId = @"Id";
NSString *const kHospitalLocationLocations = @"locations";


@interface HospitalLocation ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation HospitalLocation

@synthesize status = _status;
@synthesize hospitalLocationIdentifier = _hospitalLocationIdentifier;
@synthesize locations = _locations;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.status = [self objectOrNilForKey:kHospitalLocationStatus fromDictionary:dict];
            self.hospitalLocationIdentifier = [self objectOrNilForKey:kHospitalLocationId fromDictionary:dict];
            self.locations = [self objectOrNilForKey:kHospitalLocationLocations fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.status forKey:kHospitalLocationStatus];
    [mutableDict setValue:self.hospitalLocationIdentifier forKey:kHospitalLocationId];
    [mutableDict setValue:self.locations forKey:kHospitalLocationLocations];

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

    self.status = [aDecoder decodeObjectForKey:kHospitalLocationStatus];
    self.hospitalLocationIdentifier = [aDecoder decodeObjectForKey:kHospitalLocationId];
    self.locations = [aDecoder decodeObjectForKey:kHospitalLocationLocations];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_status forKey:kHospitalLocationStatus];
    [aCoder encodeObject:_hospitalLocationIdentifier forKey:kHospitalLocationId];
    [aCoder encodeObject:_locations forKey:kHospitalLocationLocations];
}

- (id)copyWithZone:(NSZone *)zone {
    HospitalLocation *copy = [[HospitalLocation alloc] init];
    
    
    
    if (copy) {

        copy.status = [self.status copyWithZone:zone];
        copy.hospitalLocationIdentifier = [self.hospitalLocationIdentifier copyWithZone:zone];
        copy.locations = [self.locations copyWithZone:zone];
    }
    
    return copy;
}


@end
