//
//  TestHelper.m
//  TestText
//
//  Created by 赵铭 on 2017/8/15.
//  Copyright © 2017年 zm. All rights reserved.
//

#import "TestHelper.h"

@implementation TestHelper
+ (NSRegularExpression *)regexAt{
    static NSRegularExpression * regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regex = [NSRegularExpression regularExpressionWithPattern:@"@[-_a-zA-Z0-9\u4E00-\u9FA5]+" options:kNilOptions error:nil];
    });
    return regex;
}


+ (NSRegularExpression *)regexEmoticon{
    static NSRegularExpression * regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regex = [NSRegularExpression regularExpressionWithPattern:@"\\[[^ \\[\\]]+?\\]" options:kNilOptions error:nil];
    });
    return regex;
}

+ (NSDictionary *)emoticonDic{
    static NSMutableDictionary * dic;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString * emoticonBundlePath = [[NSBundle mainBundle] pathForResource:@"EmoticonWeibo" ofType:@"bundle"];
        dic = [self _emoticonDicFromPath:emoticonBundlePath];
        
    });
    return dic;
}

+ (NSMutableDictionary *)_emoticonDicFromPath:(NSString *)path {
    NSMutableDictionary * dic = [NSMutableDictionary new];
    NSString *jsonPath = [path stringByAppendingPathComponent:@"info.json"];
    NSData * jsonData = [NSData dataWithContentsOfFile:jsonPath];
    NSDictionary * json;
    if (jsonData) {
        json = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    
    }
    
    if (json == nil) {
        NSString * plistPath = [path stringByAppendingPathComponent:@"info.plist"];
        NSDictionary * plist = [NSDictionary dictionaryWithContentsOfFile:plistPath];
        if (plist.count) {
            json = plist;
        }
    }
    
    for (NSDictionary * emoticon in json[@"emoticons"]) {
        NSString * pngPath = [path stringByAppendingPathComponent:emoticon[@"png"]];
        if (emoticon[@"chs"]) {
            dic[emoticon[@"chs"]] = pngPath;
        }
        
        if (emoticon[@"cht"]) {
            dic[emoticon[@"cht"]] = pngPath;
        }
        
        
    }
    
   
    NSArray * folders = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    for (NSString * folder in folders) {
        if (folder.length == 0) {
            continue;
        }
        
        NSDictionary * subDic = [self _emoticonDicFromPath:[path stringByAppendingPathComponent:folder]];
        if (subDic) {
            [dic addEntriesFromDictionary:subDic];
        }
    }
    return  dic;
    
}

@end
