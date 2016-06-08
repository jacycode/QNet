//
//  UIImageView+QData.m
//  Test_QNet
//
//  Created by 刘清 on 16/6/5.
//  Copyright © 2016年 LQ. All rights reserved.
//

#import "UIImageView+QData.h"

@implementation UIImageView (QData)

- (void)setImageWithURL:(NSString *)imageURL placeholder:(NSString *)imageName
{
    self.image = [UIImage imageNamed:imageName];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
       
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL] options:NSDataReadingMappedAlways error:nil]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.image = image;
        });
        
    });
}

@end
