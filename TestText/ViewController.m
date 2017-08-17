//
//  ViewController.m
//  TestText
//
//  Created by 赵铭 on 2017/8/15.
//  Copyright © 2017年 zm. All rights reserved.
//

#import "ViewController.h"
#import "TestHelper.h"
#import "SDImageCache.h"
#import "SDWebImageManager.h"

@interface ViewController ()


@property (weak, nonatomic) IBOutlet UILabel *label;


@end

@implementation ViewController

- (void)viewDidLoad {
    NSString * picURL = @"http://h5.sinaimg.cn/upload/2015/01/21/20/timeline_card_small_photo_default.png";

    NSString * s = @"我家这个好忠犬啊～[喵喵] http://t.cn/Ry4UXdF //@我是呆毛芳子蜀黍w:这是什么鬼？[喵喵] //@清新可口喵酱圆脸星人是扭蛋狂魔:窝家这个超委婉的拒绝了窝"	;
    NSMutableAttributedString * text = [[NSMutableAttributedString alloc] initWithString:s];
    
    ///用户名改成蓝色
    NSArray * atResults = [[TestHelper regexAt] matchesInString:s  options:kNilOptions range:NSMakeRange(0, text.length)];
    
    for (NSTextCheckingResult * at  in atResults) {
        if ((at.range.location == NSNotFound) || at.range.length <= 1){
            continue;
        }
        [text addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:at.range];
    }
    
    NSArray <NSTextCheckingResult *>* emResult = [[TestHelper regexEmoticon] matchesInString:s options:kNilOptions range:NSMakeRange(0, text.length)];
    NSUInteger emoClipLength = 0;
    for (NSTextCheckingResult * em in emResult) {
        NSRange range = em.range;
        
        range.location -= emoClipLength;
        NSString * emo = [text.string substringWithRange:range];
        NSDictionary * dic = [TestHelper emoticonDic];
        NSString * imagePath = dic[emo];
        UIImage * image = [UIImage imageWithContentsOfFile:imagePath];
        NSTextAttachment * attachment = [[NSTextAttachment alloc] init];
        attachment.image = image;
        attachment.bounds = CGRectMake(0, 0, 15, 15);
        
        NSAttributedString *attachmentS = [NSAttributedString attributedStringWithAttachment:attachment];
        [text replaceCharactersInRange:range withAttributedString:attachmentS];
        //替换完之后[喵喵]的长度从4变成了1，所以之后的range的location都要减去3
        emoClipLength = range.length - 1;
    }
    
    
    
    NSRange range = [text.string rangeOfString:@"http://t.cn/Ry4UXdF"];
    NSMutableAttributedString * replace = [[NSMutableAttributedString alloc] initWithString:@"查看标题"];
    
    UIImage * image = [[SDImageCache sharedImageCache] imageFromCacheForKey:@"http://h5.sinaimg.cn/upload/2015/01/21/20/timeline_card_small_photo_default.png"];
    if (image){
        NSTextAttachment * attachment = [[NSTextAttachment alloc] init];
        attachment.image = image;
        attachment.bounds = CGRectMake(0, 0, 15, 15);
        NSAttributedString *attachmentS = [NSAttributedString attributedStringWithAttachment:attachment];
        
        [replace insertAttributedString:attachmentS atIndex:0];
    }else{
        
        UIImage * placehold = [UIImage imageNamed:@"qq"];
        NSTextAttachment * attachment = [[NSTextAttachment alloc] init];
        attachment.image = placehold;
        attachment.bounds = CGRectMake(0, 0, 15, 15);
        NSAttributedString *attachmentS = [NSAttributedString attributedStringWithAttachment:attachment];
        [replace insertAttributedString:attachmentS atIndex:0];
        
        [[[SDWebImageManager sharedManager] imageDownloader] downloadImageWithURL:[NSURL URLWithString:picURL] options:SDWebImageDownloaderLowPriority progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
            NSLog(@"下载完成,开始延时");
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                attachment.image = image;
                [_label setNeedsDisplay];
            });
        }];
    }
    
    [text replaceCharactersInRange:range withAttributedString:replace];
    _label.attributedText = text;
    [_label sizeToFit];
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
