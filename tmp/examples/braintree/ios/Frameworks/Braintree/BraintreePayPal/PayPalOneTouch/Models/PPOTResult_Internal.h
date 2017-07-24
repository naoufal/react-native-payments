//
//  PPOTCore_Internal.h
//  PayPalOneTouch
//
//  Copyright © 2015 PayPal, Inc. All rights reserved.
//

#import "PPOTCore.h"

@interface PPOTResult ()

@property (nonatomic, readwrite, assign) PPOTResultType type;
@property (nonatomic, readwrite, copy) NSDictionary *response;
@property (nonatomic, readwrite, copy) NSError *error;
@property (nonatomic, readwrite, assign) PPOTRequestTarget target;

+ (void)parseURL:(NSURL *)url completionBlock:(PPOTCompletionBlock)completionBlock;

@end
