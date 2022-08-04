//
//  FEKeyboardToolbar.m
//  NLiteAVDemo
//
//  Created by Think on 2021/1/20.
//  Copyright © 2021 Netease. All rights reserved.
//

#import "FEKeyboardToolbarView.h"
#import <Masonry/Masonry.h>
#import "FEColor.h"

@interface FEKeyboardToolbarView () <UITextFieldDelegate>

@property (nonatomic, strong, readwrite)   UITextField *textField;
@property (nonatomic, strong, readwrite)   UIButton    *sendBtn;

@end

@implementation FEKeyboardToolbarView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    [self addSubview:self.textField];
    [self addSubview:self.sendBtn];
    [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-8);
        make.size.mas_equalTo(CGSizeMake(60, 32));
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(8);
        make.centerY.equalTo(self);
        make.right.equalTo(self.sendBtn.mas_left).offset(-12);
        make.height.mas_equalTo(32);
    }];
}


- (void)sendBtnClick:(UIButton *)sender {
    if (self.cusDelegate && [self.cusDelegate respondsToSelector:@selector(didToolBarSendText:)]) {
        [self.cusDelegate didToolBarSendText:self.textField.text];
    }
     self.textField.text = @"";
    [self.textField resignFirstResponder];

}

- (void)becomeFirstResponse {
    [self.textField becomeFirstResponder];
}

- (void)setUpInputContent:(NSString *)content {
    self.textField.text = content;
}

#pragma mark - lazy load

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.font = [UIFont systemFontOfSize:14];
        _textField.backgroundColor = [FEColor colorFromHex:@"0xF0F0F2"];
        _textField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
        _textField.leftViewMode = UITextFieldViewModeAlways;
        _textField.layer.cornerRadius = 16;
    }
    return _textField;
}

- (UIButton *)sendBtn {
    if (!_sendBtn) {
        _sendBtn = [[UIButton alloc] init];
        [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        _sendBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _sendBtn.layer.cornerRadius = 16;
        _sendBtn.layer.masksToBounds = YES;
        _sendBtn.backgroundColor = [FEColor colorFromHex:@"0x337EFF"];
        [_sendBtn addTarget:self action:@selector(sendBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendBtn;
}

@end
