//
//  RKWebDataLoad.h
//  pictureFlow
//
//  Created by Robinkey on 12/28/12.
//  Copyright (c) 2012 Robinkey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RKWebDataLoad : NSObject
{

}

+ (RKWebDataLoad *)sharedRKWebDataLoad;

- (void)emptyCache;
- (void)removeAllCacheDownloads;
- (UIImage*)imageForURL:(NSString*)imageURL;
- (NSString*)pathForImageURL:(NSString*)imageURL;

// path related
+ (NSString*) filePathForResourceAtURL:(NSString*)url;
+ (BOOL)fileExistsForResourceAtURL:(NSString*)url;

+ (NSString*)tmpFilePathForResourceAtURL:(NSString*)url;
+ (BOOL)tmpFileExistsForResourceAtURL:(NSString*)url;
@end
