//
//  SelFriendViewController.h
//  Cashnice
//
//  Created by apple on 16/7/22.
//  Copyright © 2016年 l. All rights reserved.
//

#import "CustomViewController.h"
#import "PersonObject.h"

@protocol SelFriendDelegate <NSObject>
-(void)didSelFriend:(PersonObject *)object;
@end

@interface SelFriendViewController : CustomViewController
@property(nonatomic,weak) id<SelFriendDelegate>delegate;
@end
