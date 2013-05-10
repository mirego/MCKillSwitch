//
//  MCKillSwitchAPI.m
//  MCKillSwitch
//
//  Created by Stéphanie Paquet on 2013-04-24.
//  Copyright (c) 2013 Mirego. All rights reserved.
//

#import "MCKillSwitchAPI.h"

NSString * const kMCKillSwitchAPIPath = @"killswitch";
NSString * const kMCKillSwitchAPILanguage = @"Accept-Language";
NSString * const kMCKillSwitchAPIUserAgent = @"User-Agent";
NSString * const kMCKillSwitchAPIAppVersion = @"version";
NSString * const kMCKillSwitchAPIPlatform = @"ios";

//------------------------------------------------------------------------------
#pragma mark - Private interface
//------------------------------------------------------------------------------

@interface MCKillSwitchAPI ()

@property (nonatomic, strong) NSURL *baseURL;
@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSMutableData *responseData;

@end

//------------------------------------------------------------------------------
#pragma mark - Implementation
//------------------------------------------------------------------------------

@implementation MCKillSwitchAPI

- (id)initWithBaseURL:(NSURL *)baseURL
{
    self = [super init];
    if (self) {
        _baseURL = baseURL;
    }
    return self;
}

//------------------------------------------------------------------------------
#pragma mark - Public methods
//------------------------------------------------------------------------------

- (void)start
{
    [self startWithParameters:nil];
}

- (void)startWithParameters:(NSDictionary *)parameters
{
    NSURL *url = [NSURL URLWithString:kMCKillSwitchAPIPath relativeToURL:_baseURL];
    
    // Parameters
    NSString *queryParams = [self queryStringForParameters:parameters];
    if (queryParams) {
        url = [NSURL URLWithString:[url.absoluteString stringByAppendingFormat:@"?%@", queryParams]];
    }
    
    // Request contruction
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:[self language] forHTTPHeaderField:kMCKillSwitchAPILanguage];
    [request setValue:[self userAgent] forHTTPHeaderField:kMCKillSwitchAPIUserAgent];
    
    // URL connection
    [self cancel];
    _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)cancel
{
    if (_connection) {
        [_connection cancel];
        _connection = nil;
    }
}

//------------------------------------------------------------------------------
#pragma mark - Private methods
//------------------------------------------------------------------------------

- (NSString *)language
{
    NSString *localeIdentifier = [NSLocale preferredLanguages][0];
    NSDictionary *components = [NSLocale componentsFromLocaleIdentifier:localeIdentifier];
    NSString *languageCode = components[NSLocaleLanguageCode];
    return languageCode;
}

- (NSString *)userAgent
{
    NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];
    return [NSString stringWithFormat:@"%@; %@", kMCKillSwitchAPIPlatform, bundleID];
}

- (NSString *)queryStringForParameters:(NSDictionary *)parameters
{
    NSMutableArray *list = [NSMutableArray array];
    
    for (NSString *key in [parameters allKeys]) {
        NSString *value = parameters[key];
        if ([value isKindOfClass:[NSString class]]) {
            [list addObject:[NSString stringWithFormat:@"%@=%@", key, value]];
        }
    }
    
    return [list componentsJoinedByString:@"&"];
}

- (void)successWithInfoDictionary:(NSDictionary *)infoDictionary
{
    if ([_delegate respondsToSelector:@selector(killSwitchAPI:didLoadInfoDictionary:)]) {
        [_delegate killSwitchAPI:self didLoadInfoDictionary:infoDictionary];
    }
}

- (void)failWithError:(NSError *)error
{
    if ([_delegate respondsToSelector:@selector(killSwitchAPI:didFailWithError:)]) {
        [_delegate killSwitchAPI:self didFailWithError:error];
    }
}

//------------------------------------------------------------------------------
#pragma mark - NSURLConnectionDelegate
//------------------------------------------------------------------------------

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _responseData = nil;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (!_responseData) {
        _responseData = [NSMutableData data];
    }
    [_responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *errorJSON = nil;
    NSDictionary *responseDictionary = _responseData ? [NSJSONSerialization JSONObjectWithData:_responseData options:0 error:&errorJSON] : @{};
    
    if (!errorJSON) {
        [self successWithInfoDictionary:responseDictionary];
    }
    else {
        [self failWithError:nil];
    }
    
    _connection = nil;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self failWithError:error];
    
    _responseData = nil;
    _connection = nil;
}


@end
