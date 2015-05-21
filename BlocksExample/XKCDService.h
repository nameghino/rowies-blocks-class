//
//  XKCDService.h
//  BlocksExample
//
//  Created by Nicolas Ameghino on 5/20/15.
//
//

#import <Foundation/Foundation.h>

typedef void(^ServiceSuccessCallback)(NSDictionary*);
typedef void(^ServiceFailureCallback)(NSError*);


@interface XKCDService : NSObject

+(void) fetchComic:(NSString *) comicId
      successBlock:(ServiceSuccessCallback) success
      failureBlock:(ServiceFailureCallback) failure;


@end
