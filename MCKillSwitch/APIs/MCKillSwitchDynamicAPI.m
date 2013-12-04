//
//  MCKillSwitchDynamicAPI.m
//  MCKillSwitch
//
//  Created by Stéphanie Paquet on 2013-04-24.
//  Copyright (c) 2013 Mirego. All rights reserved.
//

#import "MCKillSwitchDynamicAPI.h"

NSString * const kMCKillSwitchAPIPath = @"killswitch";
NSString * const kMCKillSwitchAPILanguage = @"Accept-Language";
NSString * const kMCKillSwitchAPIUserAgent = @"User-Agent";
NSString * const kMCKillSwitchAPIAppVersion = @"version";
NSString * const kMCKillSwitchAPIPlatform = @"ios";
NSString * const kMCKillSwitchAPIDefaultAPIBaseURL = @"http://killswitch.mirego.com/killswitch";

//------------------------------------------------------------------------------
#pragma mark - Private interface
//------------------------------------------------------------------------------

@interface MCKillSwitchDynamicAPI ()

@property (nonatomic) NSURL *baseURL;
@property (nonatomic) NSURLConnection *connection;
@property (nonatomic) NSMutableData *responseData;
@property (nonatomic) BOOL isStaticJSONFileURL;
@end

//------------------------------------------------------------------------------
#pragma mark - Implementation
//------------------------------------------------------------------------------

@implementation MCKillSwitchDynamicAPI
@synthesize delegate;

+ (MCKillSwitchDynamicAPI *)defaultURLKillSwitchDynamicAPI
{
    MCKillSwitchDynamicAPI *killSwitchDynamicAPI = [[MCKillSwitchDynamicAPI alloc] initWithBaseURL:[NSURL URLWithString:kMCKillSwitchAPIDefaultAPIBaseURL]];
    return killSwitchDynamicAPI;
}

+ (MCKillSwitchDynamicAPI *)killSwitchDynamicAPIWithCustomURL:(NSURL *)url
{
    MCKillSwitchDynamicAPI *killSwitchDynamicAPI = [[MCKillSwitchDynamicAPI alloc] initWithBaseURL:url];
    return killSwitchDynamicAPI;
}

- (id)initWithBaseURL:(NSURL *)baseURL
{
    return [self initWithBaseURL:baseURL URLIsStatic:NO];
}

- (id)initWithBaseURL:(NSURL *)url URLIsStatic:(BOOL)staticURL
{
    self = [super init];
    if (self) {
        _baseURL = url;
        _isStaticJSONFileURL = staticURL;
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
    NSMutableURLRequest *request= [self killSwitchRequestWithParameters:parameters];

    // URL connection
    [self cancel];
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (NSMutableURLRequest *)killSwitchRequestWithParameters:(NSDictionary *)parameters
{
    if (self.isStaticJSONFileURL) {
        return [self requestForStaticURLWithParameters:parameters];
    }
    else {
        if ([self isDefaultURL]) {
            return [self requestForDefaultURLWithParameters:parameters];
        }
        return [self requestForDynamicURL:parameters];
    }
}

- (BOOL)isDefaultURL
{
    return [self.baseURL.absoluteString isEqualToString:kMCKillSwitchAPIDefaultAPIBaseURL];
}

- (NSMutableURLRequest *)requestForStaticURLWithParameters:(NSDictionary *)parameters
{
    NSString *appVersion = parameters[kMCKillSwitchAPIAppVersion];
    NSURL *url = [NSURL URLWithString:[appVersion stringByAppendingPathExtension:@"json"] relativeToURL:self.baseURL];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"GET"];
    return request;
}

- (NSMutableURLRequest *)requestForDefaultURLWithParameters:(NSDictionary *)parameters
{
    NSURL *url = [self.baseURL copy];
    NSString *queryParams = [self queryStringForParameters:parameters];
    if (queryParams) {
        url = [NSURL URLWithString:[url.absoluteString stringByAppendingFormat:@"?%@", queryParams]];
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"GET"];
    return request;
}

- (NSMutableURLRequest *)requestForDynamicURL:(NSDictionary *)parameters
{
    NSURL *url = [NSURL URLWithString:kMCKillSwitchAPIPath relativeToURL:self.baseURL];

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
    return request;
}

- (void)cancel
{
    if (self.connection) {
        [self.connection cancel];
        self.connection = nil;
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
    if ([self.delegate respondsToSelector:@selector(killSwitchAPI:didLoadInfoDictionary:)]) {
        [self.delegate killSwitchAPI:self didLoadInfoDictionary:infoDictionary];
    }
}

- (void)failWithError:(NSError *)error
{
    if ([self.delegate respondsToSelector:@selector(killSwitchAPI:didFailWithError:)]) {
        [self.delegate killSwitchAPI:self didFailWithError:error];
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
