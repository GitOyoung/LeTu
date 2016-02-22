//
//  Common.h
//  AiEngineFree
//
//  Created by Midfar Sun on 3/3/14.
//  Copyright (c) 2014 Midfar Sun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AiSpeechEngine.h"

#define kInitEngineSuccessNotification @"kInitEngineSuccessNotification"
#define kInitEngineErrorNotification @"kInitEngineErrorNotification"

#define kAppKey @"1433726314000002"
#define kSecretKey @"919fe1055222eb3d707bc3f17d6be046"

typedef enum{
    ENGINE_STATUS_NULL = -2,
    ENGINE_STATUS_LOADING = -1,
    ENGINE_STATUS_INITIALIZED = 0,
    ENGINE_STATUS_ERROR = 1
}ENGINE_STATUS;

@interface Common : NSObject

@property(nonatomic, retain)AiSpeechEngine *engine;
@property(nonatomic, assign)ENGINE_STATUS engineStatus;

+(Common *)sharedInstance;

@end
