//
//  Common.m
//  AiEngineFree
//
//  Created by Midfar Sun on 3/3/14.
//  Copyright (c) 2014 Midfar Sun. All rights reserved.
//

#import "Common.h"
#import "AiUtil.h"
#import "aiengine.h"
#import "aiengine_helper.h"

static Common *instance = nil;

@implementation Common
@synthesize engine, engineStatus;

+(Common *)sharedInstance
{
    if (instance == nil) {
        instance = [[Common alloc] init];
        instance.engineStatus = ENGINE_STATUS_NULL;
        [instance initEngineInBackground:nil];
    }
    return instance;
}

-(void)initEngineInBackground:(NSString *)serialNumber
{
    @autoreleasepool {
        NSString *resourceFile = [[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:@"aiengine.resource.zip"];
        NSString *dir = [AiUtil unzipFile:resourceFile];
        if (dir == nil) {//解压失败了
            [self postInitEngineStatus:ENGINE_STATUS_ERROR];
            return;
        }
        
        char device_id[64];
        char user_id[64];
        char AppKey[64];
        char SecretKey[64];
        const char *t_serial_number;
        
        strcpy(user_id, "test-uid-0001");
        strcpy(AppKey, "1433726314000002");
        strcpy(SecretKey, "919fe1055222eb3d707bc3f17d6be046");
        aiengine_get_device_id(device_id);
        
        t_serial_number = aiengine_helper_register_device_once(AppKey, SecretKey, device_id, user_id);
        NSString *serial_number = [[NSString alloc] initWithCString:(const char*)t_serial_number encoding:NSASCIIStringEncoding];
        
        engineStatus = ENGINE_STATUS_LOADING;
        NSString *provisionPath = [[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:@"/aiengine.provision.free"];
        NSString *pathForEnWordScore = [dir stringByAppendingPathComponent:@"/bin/eng.wrd.plp.simp.mb.0.1"];
        NSString *pathForEnSentScore = [dir stringByAppendingPathComponent:@"/bin/eng.snt.plp.simp.mb.0.1"];
		NSString *pathForCnWordScore = [dir stringByAppendingPathComponent:@"/bin/chn.wrd.plp.simp.mb.0.1"];
        NSString *pathForCnSentScore = [dir stringByAppendingPathComponent:@"/bin/chn.snt.plp.simp.mb.0.1"];
        NSDictionary *cfgDict = @{@"appKey": kAppKey,
                                  @"secretKey": kSecretKey,
                                  @"provision": provisionPath,
                                  @"serialNumber":serial_number,
                                  @"native": @{
                                  @"en.word.score": @{@"res": pathForEnWordScore},
                                  @"en.sent.score": @{@"res": pathForEnSentScore},  
								  @"cn.word.score": @{@"res": pathForCnWordScore},
								  @"cn.sent.score": @{@"res": pathForCnSentScore}},
                                  };
        engine = [[AiSpeechEngine alloc] initWithCfg:cfgDict];
        if ([engine isInitialized]) {
            [self postInitEngineStatus:ENGINE_STATUS_INITIALIZED];
        }else{
            [self postInitEngineStatus:ENGINE_STATUS_ERROR];
        }
    }
}

-(void)postInitEngineStatus:(int)status
{
    engineStatus = status;
    if (status == ENGINE_STATUS_INITIALIZED) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kInitEngineSuccessNotification object:nil];
        
    }else if(status == ENGINE_STATUS_ERROR){
        [[NSNotificationCenter defaultCenter] postNotificationName:kInitEngineErrorNotification object:nil];
    }
}

@end
