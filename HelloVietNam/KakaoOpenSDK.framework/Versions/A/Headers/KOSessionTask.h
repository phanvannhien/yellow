/**
 * Copyright 2015-2016 Kakao Corp.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import <UIKit/UIKit.h>
#import "KOHTTPMethod.h"

/*
 @abstract 각종 API 요청 완료시 호출되는 콜백 핸들러
 @param result 해당 API 요청의 결과
 @param error 호출 실패시의 오류 정보
 */
typedef void(^KOSessionTaskCompletionHandler)(id result, NSError *error);

@interface KOSessionTask : NSObject

- (id)initWithPath:(NSString *)path
        parameters:(NSDictionary *)parameters
        httpMethod:(KORequestHTTPMethod)httpMethod
 multipartFormData:(BOOL)multipartFormData
 completionHandler:(KOSessionTaskCompletionHandler)completionHandler;

- (id)initWithPath:(NSString *)path
           headers:(NSDictionary *)headers
        parameters:(NSDictionary *)parameters
        httpMethod:(KORequestHTTPMethod)httpMethod
 multipartFormData:(BOOL)multipartFormData
 completionHandler:(KOSessionTaskCompletionHandler)completionHandler;

- (id)initWithURL:(NSURL *)URL
       parameters:(NSDictionary *)parameters
       httpMethod:(KORequestHTTPMethod)httpMethod
multipartFormData:(BOOL)multipartFormData
completionHandler:(KOSessionTaskCompletionHandler)completionHandler;

- (id)initWithURL:(NSURL *)URL
          headers:(NSDictionary *)headers
       parameters:(NSDictionary *)parameters
       httpMethod:(KORequestHTTPMethod)httpMethod
multipartFormData:(BOOL)multipartFormData
completionHandler:(KOSessionTaskCompletionHandler)completionHandler;

+ (instancetype)taskWithPath:(NSString *)path
                  parameters:(NSDictionary *)parameters
                  httpMethod:(KORequestHTTPMethod)httpMethod
           multipartFormData:(BOOL)multipartFormData
           completionHandler:(KOSessionTaskCompletionHandler)completionHandler;

+ (instancetype)taskWithPath:(NSString *)path
                     headers:(NSDictionary *)headers
                  parameters:(NSDictionary *)parameters
                  httpMethod:(KORequestHTTPMethod)httpMethod
           multipartFormData:(BOOL)multipartFormData
           completionHandler:(KOSessionTaskCompletionHandler)completionHandler;

+ (instancetype)taskWithURL:(NSURL *)URL
                 parameters:(NSDictionary *)parameters
                 httpMethod:(KORequestHTTPMethod)httpMethod
          multipartFormData:(BOOL)multipartFormData
          completionHandler:(KOSessionTaskCompletionHandler)completionHandler;

+ (instancetype)taskWithURL:(NSURL *)URL
                    headers:(NSDictionary *)headers
                 parameters:(NSDictionary *)parameters
                 httpMethod:(KORequestHTTPMethod)httpMethod
          multipartFormData:(BOOL)multipartFormData
          completionHandler:(KOSessionTaskCompletionHandler)completionHandler;

/*
 @abstract 해당 API 요청을 취소
 */
- (void)cancel;

/*
 @abstract 해당 API 요청을 취소
 @param error 취소할 때 발생시키고자 하는(원인) NSError.
 */
- (void)cancelWithError:(NSError *)error;

/*
 @abstract API 요청시의 타임아웃을 설정
 @param timeoutInterval second단위의 타임아웃 값(NSTimeInterval). 기본 180초(3분).
 */
+ (void)setRequestTimeoutInterval:(NSTimeInterval)timeoutInterval;
+ (NSTimeInterval)requestTimeoutInterval;

@end
