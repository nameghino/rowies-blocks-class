//
//  XKCDService.m
//  BlocksExample
//
//  Created by Nicolas Ameghino on 5/20/15.
//
//

#import "XKCDService.h"


@implementation XKCDService

+(void) fetchComic:(NSString *) comicId
      successBlock: (ServiceSuccessCallback) success
      failureBlock:(ServiceFailureCallback) failure {
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://xkcd.com/%@/info.0.json", comicId]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    void (^completionHandler)(NSData *, NSURLResponse *, NSError *) =
    ^(NSData *data, NSURLResponse *response, NSError *error) {
        // if there's error, call failure
        if (error != nil) {
            failure(error);
            return;
        }
        
        //TODO: do some proper HTTP error handling
        
        NSError *internalError = nil;
        
        __block NSMutableDictionary *r = [NSJSONSerialization JSONObjectWithData:data
                                                          options:NSJSONReadingMutableContainers
                                                            error:&internalError];
        if (internalError) {
            failure(internalError);
            return;
        }
        
        NSURL *imageURL = [NSURL URLWithString:r[@"img"]];
        [[[NSURLSession sharedSession] dataTaskWithURL:imageURL
                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                        if (error) {
                                            failure(error);
                                            return;
                                        }
                                        
                                        r[@"imageBytes"] = data;
                                        success(r);
                                    }] resume];
    };
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:completionHandler];
    [task resume];
    
}

@end
