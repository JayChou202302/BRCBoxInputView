//
//  BRCTextInput.m
//  BRCCommonComponents
//
//  Created by sunzhixiong on 2024/7/3.
//

#import "BRCTextInput.h"

@implementation BRCTextPosition

- (instancetype)init
{
    self = [super init];
    if (self) {
        _offset = 0;
        _affinity = BRCTextAffinityForward;
    }
    return self;
}

- (instancetype)initWithOffset:(NSInteger)offset affinity:(BRCTextAffinity)affinity {
    self = [super init];
    if (self) {
        if (offset < 0) {
            offset = 0;
        }
        _offset = offset;
        _affinity = affinity;
    }
    return self;
}

+ (instancetype)positionWithOffset:(NSInteger)offset {
    return [[BRCTextPosition alloc] initWithOffset:offset affinity:BRCTextAffinityForward];
}

+ (instancetype)positionWithOffset:(NSInteger)offset affinity:(BRCTextAffinity)affinity  {
    return [[BRCTextPosition alloc] initWithOffset:offset affinity:affinity];
}

- (NSComparisonResult)compare:(id)other
{
    if ([other isKindOfClass:[BRCTextPosition class]]) {
        BRCTextPosition *otherPosition = (BRCTextPosition *)other;
        if (self.offset == otherPosition.offset && otherPosition.affinity == self.affinity) {
            return NSOrderedSame;
        }
        if (self.affinity == BRCTextAffinityForward &&
            otherPosition.affinity == BRCTextAffinityForward) {
            if (self.offset < otherPosition.offset) {
                return NSOrderedDescending;
            }
        }
        if (self.affinity == BRCTextAffinityBackward) {
            if (otherPosition.affinity == BRCTextAffinityForward) {
                return NSOrderedDescending;
            } else if (self.offset > otherPosition.offset){
                return NSOrderedDescending;
            }
        }
    }
    return NSOrderedAscending;
}

- (id)copyWithZone:(NSZone *)zone {
    BRCTextPosition *position = [self.class positionWithOffset:self.offset affinity:self.affinity];
    return position;
}

@end

@interface BRCTextRange() {
    BRCTextPosition *_start;
    BRCTextPosition *_end;
}
@end

@implementation BRCTextRange

+ (instancetype)defaultRange {
    return [[BRCTextRange alloc] init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _start = [[BRCTextPosition alloc] init];
        _end = [[BRCTextPosition alloc] init];
    }
    return self;
}

- (instancetype)initWithRange:(NSRange)range {
    self = [super init];
    if (self) {
        _start = [[BRCTextPosition alloc] initWithOffset:range.location affinity:BRCTextAffinityForward];
        _end = [[BRCTextPosition alloc] initWithOffset:range.location + range.length affinity:BRCTextAffinityForward];
    }
    return self;
}

- (instancetype)initWithStartPosition:(BRCTextPosition *)start endPosition:(BRCTextPosition *)end {
    self = [super init];
    if (self) {
        _start = start;
        _end = end;
    }
    return self;
}

- (instancetype)initWithStartPosition:(BRCTextPosition *)start offset:(NSInteger)offset {
    BRCTextPosition *end;
    if (start.affinity == BRCTextAffinityForward) {
        end = [[BRCTextPosition alloc] initWithOffset:start.offset + offset affinity:BRCTextAffinityForward];
    } else {
        end = [[BRCTextPosition alloc] initWithOffset:start.offset - offset affinity:BRCTextAffinityBackward];
    }
    return [self initWithStartPosition:start endPosition:end];
}

- (BRCTextPosition *)start {
    return _start;
}

- (BRCTextPosition *)end {
    return _end;
}

- (NSRange)vaildRange {
    return NSMakeRange(_start.offset, _end.offset - _start.offset);
}

- (BOOL)isVaild {
    if ([self.start isKindOfClass:[BRCTextPosition class]] &&
        [self.end isKindOfClass:[BRCTextPosition class]]) {
        if (self.start.affinity == BRCTextAffinityForward &&
            self.end.affinity == BRCTextAffinityForward) {
            return self.end.offset > self.start.offset;
        }
        if (self.start.affinity == BRCTextAffinityBackward &&
            self.end.affinity == BRCTextAffinityBackward) {
            return self.start.offset > self.end.offset;
        }
        if (self.start.affinity == BRCTextAffinityBackward &&
            self.end.affinity == BRCTextAffinityForward) {
            return YES;
        }
    }
    return NO;
}

- (id)copyWithZone:(NSZone *)zone {
    BRCTextRange *range = [[BRCTextRange alloc] initWithStartPosition:self.start endPosition:self.end];
    return range;
}

@end
