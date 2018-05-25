//
//  FriendEngine.h
//  Cashnice
//
//  Created by apple on 2016/10/17.
//  Copyright © 2016年 l. All rights reserved.
//

#import "CNNetworkEngine.h"
#import "HeaderNamePersonViewModel.h"



@interface ShouxinEngine : CNNetworkEngine

@property (nonatomic,strong, readonly) NSMutableSet *sectionSet; //首字母拼音section集合



-(void)getSearchCNContacts:(NSDictionary *)parms
                   success:(void (^)(NSArray *users))success
                   failure:(void (^)(NSString *error))failure;

/**
 获取与我的相关授信人群

 @param page     页码
 @param pageSize 单页大小
 @param type     类型  0没向我授信的人 1已向我授信的人 其他：相互授信的人
 @param userID   我的id
 @param success
 @param failure  
 */
-(void)getShouxin:(NSInteger)page
         pageSize:(NSInteger)pageSize
      shouxinType:(NSInteger)type
           userID:(NSString *)userID
          success:(void (^)(NSArray *))success
          failure:(void (^)(NSString *error))failure;


/**
 可能认识的人

 
 @param page     页码
 @param pageSize 单页大小
 @param userID   我的id
 @param success <#success description#>
 @param failure <#failure description#>
 */
-(void)getMightKnown:(NSInteger)page
            pageSize:(NSInteger)pageSize
              userID:(NSString *)userID
             success:(void (^)(NSDictionary *mightKnownDict))success
             failure:(void (^)(NSString *error))failure;

-(NSArray *)readLocalShouxinList:(NSString *)userID type:(NSInteger)type;


/**
 获取授信给我的用户，并存储到本地
 */
+(void)requestStoreShouxinToMe;


@end
