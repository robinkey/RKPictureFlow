//
//  RKWebDataLoad.m
//  pictureFlow
//
//  Created by Robinkey on 12/28/12.
//  Copyright (c) 2012 Robinkey. All rights reserved.
//

#import "RKWebDataLoad.h"
#import "SynthesizeSingleton.h"
#import "ASINetworkQueue.h"
#import "ASIHTTPRequest.h"
//定义缓存的最大值
#define MAXIMUM_CACHED_ITEMS 5

@interface RKWebDataLoad()
//通过这个可变字典来存放缓存中存放情况
@property (atomic, retain) NSMutableDictionary *imageCache;

@end

@implementation RKWebDataLoad

SYNTHESIZE_SINGLETON_FOR_CLASS(RKWebDataLoad);

@synthesize imageCache = _imageCache;

- (void)dealloc {
	self.imageCache = nil;
	[super dealloc];
}

- (id)init {
    self = [super init];
	if (self) {
		self.imageCache = [NSMutableDictionary dictionary];
	}
	return self;
}
//清空缓存
- (void)emptyCache {
	NSLog(@"Emptying Cache");
	[self.imageCache removeAllObjects];
}

- (void) removeAllCacheDownloads {
    NSLog(@"deleting all cache downloads");
    NSString * cacheFolderPath = [[self pathForImageURL:@"http://a.cn/b.jpg"] stringByDeletingLastPathComponent];
    [[NSFileManager defaultManager] removeItemAtPath:cacheFolderPath error:nil];
}

- (UIImage*) imageForURL:(NSString*)imageURL {
    //如果路径为空，返回图片为nil
    if (imageURL.length == 0)
        return nil;
    
    UIImage *image = nil;
    if ((image = [self.imageCache objectForKey:imageURL])) {
        //如果缓存中已经存在此图片，返回nil
        return image;
    } else if ((image = [UIImage imageWithContentsOfFile:[self pathForImageURL:imageURL]])) {
        if ([self.imageCache count] > MAXIMUM_CACHED_ITEMS)//如果缓存数量超过允许的最大值就清空缓存
            [self emptyCache];
        //将此次加入的图片放入缓存
        [self.imageCache setObject:image forKey:imageURL];
        return image;
    }
    return nil;
}
//根据传入的图片路径返回他的本地下载地址
- (NSString*) pathForImageURL:(NSString*)imageURL {
    //如果是网络上的图片，则返回文件缓存地址
    if ([imageURL hasPrefix:@"http://"] || [imageURL hasPrefix:@"https://"] || [imageURL hasPrefix:@"ftp://"])
        return [[self class] tmpFilePathForResourceAtURL:imageURL];
    return imageURL;
}

/////////////////////////////////////////////////
// storage related

+ (BOOL) fileExistsForResourceAtURL:(NSString*)url {
    NSString * localFile = [self filePathForResourceAtURL:url];
    return [[NSFileManager defaultManager] fileExistsAtPath:localFile];
}

+ (BOOL) tmpFileExistsForResourceAtURL:(NSString*)url
{
    NSString * localFile = [self tmpFilePathForResourceAtURL:url];
    return [[NSFileManager defaultManager] fileExistsAtPath:localFile];
}

+ (NSString*) filePathForStorage {
    NSString * path = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/data"];
    [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    return  path;
}
//返回缓存库的路径 -- tmp/data目录
+ (NSString*) filePathForTemporaryStorage {
    NSString * path = [NSHomeDirectory() stringByAppendingPathComponent:@"tmp/data"];
    [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    return  path;
}
//根据文件路径返回文件名。
+ (NSString*) fileNameForResourceAtURL:(NSString*)url {
    NSString * fileName = url;
    if ([url hasPrefix:@"http://"])
        fileName = [url substringFromIndex:[@"http://" length]];
    else if([url hasPrefix:@"https://"])
        fileName = [url substringFromIndex:[@"https://" length]];
    
    fileName = [fileName stringByReplacingOccurrencesOfString:@"/" withString:@"__"];
    return fileName;
}

+ (NSString*) filePathForResourceAtURL:(NSString*)url {
    NSString * fileName = [self fileNameForResourceAtURL:url];
    NSString * path = [self filePathForStorage];
    return [path stringByAppendingPathComponent:fileName];
}
//从网络文件的地址返回缓存文件的存放路径
+ (NSString*) tmpFilePathForResourceAtURL:(NSString*)url {
    NSString * fileName = [self fileNameForResourceAtURL:url];
    NSString * path = [self filePathForTemporaryStorage];
    return [path stringByAppendingPathComponent:fileName];
}

@end
