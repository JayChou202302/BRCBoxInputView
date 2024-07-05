//
//  BRCTextInput.h
//  BRCCommonComponents
//
//  Created by sunzhixiong on 2024/7/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,BRCTextAffinity) {
    BRCTextAffinityForward = 1,
    BRCTextAffinityBackward
};

@interface BRCTextPosition : UITextPosition<NSCopying>
@property (nonatomic, assign, readonly) NSInteger offset;
@property (nonatomic, assign) BRCTextAffinity affinity;
- (instancetype)initWithOffset:(NSInteger)offset affinity:(BRCTextAffinity)affinity;
+ (instancetype)positionWithOffset:(NSInteger)offset affinity:(BRCTextAffinity)affinity;
+ (instancetype)positionWithOffset:(NSInteger)offset;
- (NSComparisonResult)compare:( id)other;
@end

@interface BRCTextRange : UITextRange<NSCopying>

@property (nonatomic, readonly) BRCTextPosition *start;
@property (nonatomic, readonly) BRCTextPosition *end;
+ (instancetype)defaultRange;
- (instancetype)initWithRange:(NSRange)range;
- (instancetype)initWithStartPosition:(BRCTextPosition *)start
                          endPosition:(BRCTextPosition *)end;
- (instancetype)initWithStartPosition:(BRCTextPosition *)start offset:(NSInteger)offset;
- (NSRange)vaildRange;
- (BOOL)isVaild;
@end

NS_ASSUME_NONNULL_END
