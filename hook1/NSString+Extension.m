//
//  NSString+Extension.m
//  hook1
//
//  Created by 冯立海 on 16/8/17.
//
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

//返回字符串所占用的尺寸.
-(CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

@end
