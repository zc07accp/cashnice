//
//  NetworkEngine.h
//  YQS
//
//  Created by l on 3/13/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageEngine : MKNetworkEngine {
    NSDictionary *respondDict;
}

-(void) imagesForTag:(NSString*) tag completionHandler:(FlickrImagesResponseBlock) imageURLBlock errorHandler:(MKNKErrorBlock) errorBlock;
@end