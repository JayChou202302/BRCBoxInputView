//
//  BRCLineBoxView.m
//  BRCBoxInputView_OC
//
//  Created by sunzhixiong on 2024/8/10.
//

#import "BRCLineBoxView.h"
#import <BRCFastTest/Masonry.h>
#import <BRCFastTest/UIColor+BRCFastTest.h>

@interface BRCLineBoxView ()

@property (nonatomic, strong) UIView *lineView;

@end

@implementation BRCLineBoxView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView);
            make.leading.trailing.equalTo(self.contentView);
            make.height.equalTo(@(3));
        }];
    }
    return self;
}

- (void)didSelectInputBox {
    self.lineView.backgroundColor = [UIColor brtest_red];
}

- (void)didUnSelectInputBox {
    self.lineView.backgroundColor = [UIColor brtest_gray];
}


- (UIView *)lineView {
    if (!_lineView) {
        _lineView = UIView.new;
        _lineView.backgroundColor = [UIColor redColor];
    }
    return _lineView;
}
@end
