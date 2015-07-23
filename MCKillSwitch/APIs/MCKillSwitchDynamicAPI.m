//
// Copyright (c) 2015, Mirego
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// - Redistributions of source code must retain the above copyright notice,
//   this list of conditions and the following disclaimer.
// - Redistributions in binary form must reproduce the above copyright notice,
//   this list of conditions and the following disclaimer in the documentation
//   and/or other materials provided with the distribution.
// - Neither the name of the Mirego nor the names of its contributors may
//   be used to endorse or promote products derived from this software without
//   specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.

#import "MCKillSwitchDynamicAPI.h"
#import "MCKillSwitchDictionaryInfo.h"

NSString * const kMCKillSwitchAPIPath = @"killswitch";
NSString * const kMCKillSwitchAPILanguage = @"Accept-Language";
NSString * const kMCKillSwitchAPIUserAgent = @"User-Agent";
NSString * const kMCKillSwitchAPIAppVersion = @"version";
NSString * const kMCKillSwitchAPIPlatform = @"ios";
NSString * const kMCKillSwitchAPIDefaultAPIBaseURL = @"https://killswitch.mirego.com/killswitch";

//------------------------------------------------------------------------------
#pragma mark - Private interface
//------------------------------------------------------------------------------

@interface MCKillSwitchDynamicAPI ()

@property (nonatomic, readonly) NSURL *baseURL;
@property (nonatomic, readonly) NSURLConnection *connection;
@property (nonatomic, readonly) NSMutableData *responseData;
@property (nonatomic, readonly) BOOL isStaticJSONFileURL;
@end

//------------------------------------------------------------------------------
#pragma mark - Implementation
//------------------------------------------------------------------------------

@implementation MCKillSwitchDynamicAPI {
    __weak id<MCKillSwitchAPIDelegate> _delegate; // Needs to be manually defined because it's weak
}

@synthesize delegate = _delegate;

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

- (instancetype)init
{
    return [self initWithBaseURL:nil URLIsStatic:NO];
}

- (instancetype)initWithBaseURL:(NSURL *)baseURL
{
    return [self initWithBaseURL:baseURL URLIsStatic:NO];
}

- (instancetype)initWithBaseURL:(NSURL *)url URLIsStatic:(BOOL)URLIsStatic
{
    self = [super init];
    if (self) {
        _baseURL = url;
        _isStaticJSONFileURL = URLIsStatic;
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
    NSMutableURLRequest *request = [self killSwitchRequestWithParameters:parameters];

    // URL connection
    [self cancel];
    _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (NSMutableURLRequest *)killSwitchRequestWithParameters:(NSDictionary *)parameters
{
    if (self.isStaticJSONFileURL) {
        return [self requestForStaticURLWithParameters:parameters];
        
    } else {
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
    id<MCKillSwitchInfo> info = [[MCKillSwitchDictionaryInfo alloc] initWithDictionary:infoDictionary];
    [self.delegate killSwitchAPI:self didLoadInfo:info];
}

- (void)failWithError:(NSError *)error
{
    [self.delegate killSwitchAPI:self didFailWithError:error];
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
    } else {
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
