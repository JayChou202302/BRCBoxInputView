//
//  BRCGiftBoxView.m
//  BRCBoxInputView_OC
//
//  Created by sunzhixiong on 2024/8/10.
//

#import "BRCGiftBoxView.h"
#import <BRCFastTest/Masonry.h>

@implementation BRCGiftBoxView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.animationView];
        [self.animationView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return self;
}

- (LOTAnimationView *)animationView {
    if (!_animationView) {
        _animationView = [LOTAnimationView animationNamed:@""];
        _animationView.contentMode = UIViewContentModeScaleAspectFit;
        _animationView.hidden = YES;
    }
    return _animationView;
}

@end
