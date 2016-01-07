//
//  AiSpeechEngine.h
//  AiEngineLib
//
//  Created by Midfar Sun on 3/10/14.
//  Copyright (c) 2013 Midfar Sun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AiSpeechEngineDelegate.h"

@interface AiSpeechEngine : NSObject

/**
 * 事件委托
 */
@property(nonatomic, assign) id<AiSpeechEngineDelegate> delegate;

/**
 * 标签，用户自定义
 */
@property(nonatomic, assign) int tag;

/**
 * 初始化语音引擎
 */
- (id)initWithCfg:(NSDictionary *)cfg;

/**
 * 开始语音引擎
 * @param
 *      path 录音文件地址
 *      duration 录音时长，单位：秒。如果<=0，则不会自动停止
 *      requestParams 请求参数
 *        coreType 内核类型
 *        refText 参考文本
 *        rank 评分级别
 * @return 录音ID
 */
- (NSString *)startWithPath:(NSString *)path duration:(NSTimeInterval)duration requestParams:(NSDictionary *)requestParams;
- (NSString *)startWithPath:(NSString *)path isDirectory:(BOOL)isDirectory duration:(NSTimeInterval)duration requestParams:(NSDictionary *)requestParams;
- (NSString *)startWithPath:(NSString *)path isDirectory:(BOOL)isDirectory duration:(NSTimeInterval)duration requestParams:(NSDictionary *)requestParams vadEnable:(BOOL)vadEnable;
//以下接口params参数透传
- (NSString *)startWithPath:(NSString *)path duration:(NSTimeInterval)duration params:(NSDictionary *)recordDict;
- (NSString *)startWithPath:(NSString *)path isDirectory:(BOOL)isDirectory duration:(NSTimeInterval)duration params:(NSDictionary *)recordDict;

/**
 * 停止语音引擎
 */
- (void)stop;

/**
 * 重置语音引擎
 */
- (void)reset;

/**
 * 开始回放最后一次的录音
 */
- (OSStatus)startReplay;

/**
 * 停止回放
 */
- (OSStatus)stopReplay;

/**
 * 检查语音引擎是否正在录音
 */
- (BOOL)isRecording;

/**
 * 检查语音引擎是否正在回放
 */
- (BOOL)isReplaying;

/**
 * 检查语音引擎是否初始化成功
 */
- (BOOL)isInitialized;

/**
 * 获取设备ID
 */
+ (NSString *)getDeviceId;

/**
 *  获取序列号
 */
+ (NSString *)getSerialNum:(NSDictionary *)appDict;

@end
