//
//  NSString+AttributeString.m
//  BaseProject
//
//  Created by 意一yiyi on 2017/10/24.
//  Copyright © 2017年 意一yiyi. All rights reserved.
//

#import "NSString+AttributeString.h"

@implementation NSString (AttributeString)

- (NSMutableAttributedString *)yy_changeToAttributedStringWithTextArray:(NSArray *)textArray textColor:(UIColor *)textColor {
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];
    
    for (NSString *text in textArray) {
        
        NSRange searchRange = NSMakeRange(0, self.length);
        NSRange range = NSMakeRange(0, 0);
        while (range.location + range.length < self.length) {
            
            range = [self rangeOfString:text options:NSLiteralSearch range:searchRange];
            
            [attributedString addAttribute:NSForegroundColorAttributeName value:textColor range:range];
            
            searchRange = NSMakeRange(range.location + range.length, self.length - (range.location + range.length));
        }
    }
    
    return attributedString;
}

- (NSMutableAttributedString *)yy_changeToAttributedStringWithTextArray:(NSArray *)textArray fontSize:(CGFloat)fontSize {
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];
    
    for (NSString *text in textArray) {
        
        NSRange searchRange = NSMakeRange(0, self.length);
        NSRange range = NSMakeRange(0, 0);
        while (range.location + range.length < self.length) {
            
            range = [self rangeOfString:text options:NSLiteralSearch range:searchRange];
            
            [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:fontSize] range:range];
            
            searchRange = NSMakeRange(range.location + range.length, self.length - (range.location + range.length));
        }
    }
    
    return attributedString;
}

- (NSMutableAttributedString *)yy_changeToAttributedStringWithTextArray:(NSArray *)textArray textColor:(UIColor *)textColor fontSize:(CGFloat)fontSize {
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];
    
    for (NSString *text in textArray) {
        
        NSRange searchRange = NSMakeRange(0, self.length);
        NSRange range = NSMakeRange(0, 0);
        while (range.location + range.length < self.length) {
            
            range = [self rangeOfString:text options:NSLiteralSearch range:searchRange];
            
            [attributedString addAttribute:NSForegroundColorAttributeName value:textColor range:range];
            [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:fontSize] range:range];
            
            searchRange = NSMakeRange(range.location + range.length, self.length - (range.location + range.length));
        }
    }
    
    return attributedString;
}

- (NSMutableAttributedString *)yy_changeToAttributedStringWithTextArray:(NSArray *)textArray deletelineColor:(UIColor *)deletelineColor {
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];
    
    for (NSString *text in textArray) {
        
        NSRange searchRange = NSMakeRange(0, self.length);
        NSRange range = NSMakeRange(0, 0);
        while (range.location + range.length < self.length) {
            
            range = [self rangeOfString:text options:NSLiteralSearch range:searchRange];
            
            [attributedString addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:range];// 删除线的类型
            [attributedString addAttribute:NSStrikethroughColorAttributeName value:deletelineColor range:range];
            
            searchRange = NSMakeRange(range.location + range.length, self.length - (range.location + range.length));
        }
    }
    
    return attributedString;
}

- (NSMutableAttributedString *)yy_changeToAttributedStringWithTextArray:(NSArray *)textArray textColor:(UIColor *)textColor deletelineColor:(UIColor *)deletelineColor {
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];
    
    for (NSString *text in textArray) {
        
        NSRange searchRange = NSMakeRange(0, self.length);
        NSRange range = NSMakeRange(0, 0);
        while (range.location + range.length < self.length) {
            
            range = [self rangeOfString:text options:NSLiteralSearch range:searchRange];
            
            [attributedString addAttribute:NSForegroundColorAttributeName value:textColor range:range];
            [attributedString addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:range];// 删除线的类型
            [attributedString addAttribute:NSStrikethroughColorAttributeName value:deletelineColor range:range];
            
            searchRange = NSMakeRange(range.location + range.length, self.length - (range.location + range.length));
        }
    }
    
    return attributedString;
}

- (NSMutableAttributedString *)yy_changeToAttributedStringWithTextArray:(NSArray *)textArray fontSize:(CGFloat)fontSize deletelineColor:(UIColor *)deletelineColor {
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];
    
    for (NSString *text in textArray) {
        
        NSRange searchRange = NSMakeRange(0, self.length);
        NSRange range = NSMakeRange(0, 0);
        while (range.location + range.length < self.length) {
            
            range = [self rangeOfString:text options:NSLiteralSearch range:searchRange];
            
            [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:fontSize] range:range];
            [attributedString addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:range];// 删除线的类型
            [attributedString addAttribute:NSStrikethroughColorAttributeName value:deletelineColor range:range];
            
            searchRange = NSMakeRange(range.location + range.length, self.length - (range.location + range.length));
        }
    }
    
    return attributedString;
}

- (NSMutableAttributedString *)yy_changeToAttributedStringWithTextArray:(NSArray *)textArray textColor:(UIColor *)textColor fontSize:(CGFloat)fontSize deletelineColor:(UIColor *)deletelineColor {
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];
    
    for (NSString *text in textArray) {
        
        NSRange searchRange = NSMakeRange(0, self.length);
        NSRange range = NSMakeRange(0, 0);
        while (range.location + range.length < self.length) {
            
            range = [self rangeOfString:text options:NSLiteralSearch range:searchRange];
            
            [attributedString addAttribute:NSForegroundColorAttributeName value:textColor range:range];
            [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:fontSize] range:range];
            [attributedString addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:range];// 删除线的类型
            [attributedString addAttribute:NSStrikethroughColorAttributeName value:deletelineColor range:range];
            
            searchRange = NSMakeRange(range.location + range.length, self.length - (range.location + range.length));
        }
    }
    
    return attributedString;
}

@end
