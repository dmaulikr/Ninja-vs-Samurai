//
//  Scores.m
//  Ninja vs Samurai
//
//  Created by Michael Enger on 3/24/12.
//  Copyright (c) 2012 The Lonely Coder. All rights reserved.
//

#import "Scores.h"
#import "Storage.h"

@implementation Scores
@synthesize level = _level,
            completed = _completed,
            moves = _moves,
            scrolls = scrolls;

#pragma mark Class Methods

+ (Scores *)scoresForLevel:(NSString *)level {
    return [[[self alloc] initWithLevel:level] autorelease];
}

#pragma mark Initialize

- (id)initWithLevel:(NSString *)level {
    if ((self = [self init])) {
        self.level = level;

        // Defaults
        self.completed = NO;
        self.moves = NO;
        self.scrolls = NO;

        // Get saved scores
        NSDictionary *scores = [Storage get:@"scores"];
        if (!scores) {
            // We've never had any scores
            [Storage set:[NSDictionary dictionary] forKey:@"scores"];
            scores = [Storage get:@"scores"];
        }

        scores = [scores objectForKey:level];
        if (scores) {
            self.completed = [((NSNumber *)[scores objectForKey:@"completed"]) boolValue];
            self.moves = [((NSNumber *)[scores objectForKey:@"moves"]) boolValue];
            self.scrolls = [((NSNumber *)[scores objectForKey:@"scrolls"]) boolValue];
        }
    }
    return self;
}

- (void)save {
    // Get saved scores
    NSMutableDictionary *scores = [NSMutableDictionary dictionaryWithDictionary:[Storage get:@"scores"]];

    NSDictionary *score = [NSDictionary dictionaryWithObjectsAndKeys:
                           [NSNumber numberWithBool:self.completed],@"completed",
                           [NSNumber numberWithBool:self.moves],@"moves",
                           [NSNumber numberWithBool:self.scrolls],@"scrolls",
                           nil];

    [scores setObject:score forKey:self.level];
    [Storage set:scores forKey:@"scores"];
}

#pragma mark NSObject

- (void)dealloc {
    self.level = nil;
    [super dealloc];
}

@end