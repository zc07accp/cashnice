//
//  NetworkEngine.m
//  YQS
//
//  Created by l on 3/13/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "ImageEngine.h"
#import "NoticeManager.h"

@implementation ImageEngine

-(void) imagesForTag:(NSString*) tag completionHandler:(FlickrImagesResponseBlock) imageURLBlock errorHandler:(MKNKErrorBlock) errorBlock {
    
    MKNetworkOperation *op = [self operationWithPath:[tag mk_urlEncodedString]];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        [completedOperation responseJSONWithCompletionHandler:^(id jsonObject) {
            imageURLBlock(jsonObject[@"photos"][@"photo"]);
        }];
        
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
        
        errorBlock(error);
    }];
    
    [self enqueueOperation:op];
}

-(NSString*) cacheDirectoryName {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];
    NSString *cacheDirectoryName = [documentsDirectory stringByAppendingPathComponent:@"FlickrImages"];
    return cacheDirectoryName;
}

@end
