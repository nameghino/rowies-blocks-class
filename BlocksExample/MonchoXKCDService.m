//
//  MonchoXKCDService.m
//  BlocksExample
//
//  Created by Nicolas Ameghino on 5/20/15.
//
//

#import "MonchoXKCDService.h"

static NSString *kXKCDServiceErrorDomain = @"XKCD Service Error";
NS_ENUM(NSInteger, XKCDServiceErrorCode) {
    NoDataReceived = -1000
};


@implementation MonchoXKCDService


// This method will try to fetch a comic in a very inefficient way. Don't do this.
// On success, it will return a dictionary with information.
// On failure, it will return an error object.

+(id)fetchComic:(NSString *)comicId {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://xkcd.com/%@/info.0.json", comicId]];
    NSData *data = [NSData dataWithContentsOfURL:url];
    if (!data) {
        return [NSError errorWithDomain:kXKCDServiceErrorDomain
                                   code:NoDataReceived
                               userInfo:@{NSLocalizedDescriptionKey: @"No data received", @"url": url}];
    }
    
    NSError *error = nil;
    NSMutableDictionary *r = [NSJSONSerialization JSONObjectWithData:data
                                                      options:NSJSONReadingMutableContainers
                                                        error:&error];
    if (error) {
        return error;
    }
    
    NSURL *imageURL = [NSURL URLWithString:r[@"img"]];
    NSData *imageBytes = [NSData dataWithContentsOfURL:imageURL];
    
    if (imageBytes) {
        r[@"imageBytes"] = imageBytes;
    } else {
        return [NSError errorWithDomain:kXKCDServiceErrorDomain
                                   code:NoDataReceived
                               userInfo:@{NSLocalizedDescriptionKey: @"No data received", @"url": url}];
    }
    
    return r;
}

@end
