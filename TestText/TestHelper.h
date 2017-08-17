//
//  TestHelper.h
//  TestText
//
//  Created by 赵铭 on 2017/8/15.
//  Copyright © 2017年 zm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestHelper : NSObject
+ (NSRegularExpression *)regexAt;
+ (NSRegularExpression *)regexEmoticon;
+ (NSDictionary *)emoticonDic;
@end

