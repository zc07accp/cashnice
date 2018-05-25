//
//  ShouxinFilter.m
//  Cashnice
//
//  Created by apple on 2016/10/18.
//  Copyright © 2016年 l. All rights reserved.
//

#import "ShouxinFilter.h"
#import "HeaderNamePersonViewModel.h"

@implementation ShouxinFilter

+(NSArray *)filterShouxinList:(NSArray *)list searchText:(NSString *)text searchTextHighlighted:(BOOL)highlighted{
    
    NSMutableArray *result = [NSMutableArray array];
    
    [list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        HeaderNamePersonViewModel *model = obj;
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", text];
        if ([predicate evaluateWithObject:model.name]) {
            
            HeaderNamePersonViewModel *new_model = [[HeaderNamePersonViewModel alloc]init];
            new_model.name = model.name;
            new_model.headerUrl = model.headerUrl;
            new_model.moreInfoDic = model.moreInfoDic;

            if (highlighted) {
                
                NSMutableAttributedString *attString=[[NSMutableAttributedString alloc] initWithString:new_model.name];
                NSInteger len      =[new_model.name length];
                
                [attString addAttribute:NSFontAttributeName value:[UtilFont systemLarge] range:NSMakeRange(0, len)];
                [attString addAttribute:NSForegroundColorAttributeName value:CN_TEXT_BLACK range:NSMakeRange(0, len)];
                [attString addAttribute:NSForegroundColorAttributeName value:CN_TEXT_BLUE range:[new_model.name rangeOfString:text]];
                
                new_model.attrName = attString;
                
            }
            

            [result addObject:new_model];
            
        }
        
    }];
    
    //检查拼音
    NSArray *pinyinFilterArr = [self filter:list pinyin:text];
    if (pinyinFilterArr) {
        [result addObjectsFromArray:pinyinFilterArr];
    }
    
    //检查手机号
    NSArray *numberFilterArr = [self filter:list number:text];
    if (numberFilterArr) {
        [result addObjectsFromArray:numberFilterArr];
    }
    
    
    return [result count]?result:nil;
    
}


+(NSArray *)filter:(NSArray *)list pinyin:(NSString *)text{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^[A-Za-z]+$"];
    BOOL pinyin = [predicate evaluateWithObject:text];
    if(!pinyin)return nil;
    

    
    NSMutableArray *result = [NSMutableArray array];
    
    
    [list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        HeaderNamePersonViewModel *model = obj;
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", [text lowercaseStringWithLocale:[NSLocale currentLocale]]];
        
        NSString *trimStr = [[model.fullPinyin removeSpaceAndNewline] lowercaseStringWithLocale:[NSLocale currentLocale]];
        
        if ([predicate evaluateWithObject:trimStr]) {
            
            HeaderNamePersonViewModel *new_model = [[HeaderNamePersonViewModel alloc]init];
            new_model.name = model.name;
            new_model.headerUrl = model.headerUrl;
            new_model.moreInfoDic = model.moreInfoDic;
            
            
            NSMutableAttributedString *attString=[[NSMutableAttributedString alloc] initWithString:new_model.name];
            NSInteger len      =[new_model.name length];
            
            [attString addAttribute:NSFontAttributeName value:[UtilFont systemLarge] range:NSMakeRange(0, len)];
            [attString addAttribute:NSForegroundColorAttributeName value:CN_TEXT_BLACK range:NSMakeRange(0, len)];
            
            new_model.attrName = attString;
            
            [result addObject:new_model];
            
        }
        
    }];
    
    return [result count]?result:nil;
    
}

+(NSArray *)filter:(NSArray *)list number:(NSString *)text{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^[0-9]+$"];
    BOOL pinyin = [predicate evaluateWithObject:text];
    if(!pinyin)return nil;
    
    
    
    NSMutableArray *result = [NSMutableArray array];
    
    
    [list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        HeaderNamePersonViewModel *model = obj;
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", text ];
        
//        NSString *trimStr = [[model.fullPinyin removeSpaceAndNewline] lowercaseStringWithLocale:[NSLocale currentLocale]];
        
        if ([predicate evaluateWithObject:model.moreInfoDic[@"userphone"]]) {
            
            HeaderNamePersonViewModel *new_model = [[HeaderNamePersonViewModel alloc]init];
            new_model.name = model.name;
            new_model.headerUrl = model.headerUrl;
            new_model.moreInfoDic = model.moreInfoDic;
            
            
            NSMutableAttributedString *attString=[[NSMutableAttributedString alloc] initWithString:new_model.name];
            NSInteger len      =[new_model.name length];
            
            [attString addAttribute:NSFontAttributeName value:[UtilFont systemLarge] range:NSMakeRange(0, len)];
            [attString addAttribute:NSForegroundColorAttributeName value:CN_TEXT_BLACK range:NSMakeRange(0, len)];
            
            new_model.attrName = attString;
            
            [result addObject:new_model];
            
        }
        
    }];
    
    return [result count]?result:nil;
    
}

@end
