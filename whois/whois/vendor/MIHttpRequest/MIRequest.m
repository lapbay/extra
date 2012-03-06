//
//  MIRequest.m
//  requester
//
//  Created by Wu Chang on 12-2-27.
//  Copyright (c) 2012年 Milan. All rights reserved.
//

#import "MIRequest.h"

@implementation MIRequest
@synthesize delegate = _delegate, _requester, timeout, index, receivedData, method, url, getURL, getParams, postStrings, postDatas, postBody, headers;

- (id)init
{
    self = [super init];
    if (self) {
        self.postBody = [[NSMutableData alloc] init];
        self.method = @"POST";
        self.timeout = 30.0;
        self.headers = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void) asyncRequest{
    self.url = @"http://pasent.com/foo";
    self.method = @"GET";
    
    self.headers = [NSDictionary dictionaryWithObjectsAndKeys:@"1.0", @"APIVersion", @"gzip,deflate", @"Accept-Encoding", nil];
    self.getParams = [NSDictionary dictionaryWithObjectsAndKeys:@"true", @"test", nil];
    self.timeout = 30.0;

    NSMutableURLRequest *request = [self buildRequest];
    [NSURLConnection sendAsynchronousRequest:request queue:self.delegate completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         NSLog(@"%@",@"in");
         NSMutableDictionary *res = [NSMutableDictionary dictionaryWithObjectsAndKeys:data, @"data", index, @"NSIndex", nil];
         if ([data length] > 0 && error == nil){
             [self.delegate connectionDidFinishLoading:res];
         }else if ([data length] == 0 && error == nil){
             //[delegate emptyReply];
         }else if (error != nil && error.code == 0){
             //[delegate timedOut];
         }else if (error != nil){
             //[delegate downloadError:error];
         }
     }];
}

- (NSMutableURLRequest *) buildRequest {
    if (self.method == @"POST") {
        if (self.postDatas != nil) {
            [self buildMultipartFormDataPostBody];
        }else {
            [self buildPostBody];
        }
    }
    //[self buildURL];
    NSURL *theURL = [[NSURL alloc]initWithString:self.url];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:theURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:self.timeout];
    [theRequest setHTTPMethod:self.method];
    [theRequest setHTTPBody:self.postBody];
    [theRequest setTimeoutInterval:self.timeout]; //does not work according to web search
    [theRequest setValue:@"1.0" forHTTPHeaderField:@"AppVersion"];
    [theRequest setAllHTTPHeaderFields:self.headers];
    return theRequest;
}

-(void)handleTimer:(NSTimer*)timer {
    MIRequest *operation = timer.userInfo;
    operation._requester = nil;
    if ([self.delegate respondsToSelector:@selector(connection:didFailWithError:)]) {
        [self.delegate performSelector:@selector(connection:didFailWithError:) withObject:operation._requester withObject:[NSError errorWithDomain:@"domain" code:NSURLErrorTimedOut userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"The request timed out.", NSURLErrorFailingURLStringErrorKey, nil]]];
    };
    [timer invalidate];
    [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(cancel) userInfo:self repeats:NO];
}

- (NSString *) buildPostBody{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (NSString *key in self.postStrings) {
        id object = [self.postStrings objectForKey:key];
        NSString *value = [self objectToString:object];
        [array addObject:[NSString stringWithFormat:@"%@=%@", key, value]];
    }
    NSString *body = [array componentsJoinedByString:@"&"];
    self.postBody = [NSMutableData dataWithData: [body dataUsingEncoding:NSUTF8StringEncoding]];
    return body;
}

- (void) setGetParams:(NSMutableDictionary *)params {
    getParams = params;
    [self buildURL];
}

- (NSString *) buildURL{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (NSString *key in self.getParams) {
        id object = [self.getParams objectForKey:key];
        NSString *value = [self objectToString:object];
        [array addObject:[NSString stringWithFormat:@"%@=%@", key, [self urlEncode:value]]];
    }
    self.url = [NSString stringWithFormat:@"%@?%@",self.url,[array componentsJoinedByString:@"&"]];
    return self.url;
}

- (void)buildMultipartFormDataPostBody
{	
	NSString *charset = (__bridge NSString *)CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
	
	// We don't bother to check if post data contains the boundary, since it's pretty unlikely that it does.
	CFUUIDRef uuid = CFUUIDCreate(nil);
	NSString *uuidString = (__bridge NSString*)CFUUIDCreateString(nil, uuid);
	CFRelease(uuid);
	NSString *stringBoundary = [NSString stringWithFormat:@"0xKhTmLbOuNdArY-%@",uuidString];
	
	[self addRequestHeader:@"Content-Type" value:[NSString stringWithFormat:@"multipart/form-data; charset=%@; boundary=%@", charset, stringBoundary]];

	[self appendpostStrings:[NSString stringWithFormat:@"--%@\r\n",stringBoundary]];
	
	// Adds post data

	NSString *endItemBoundary = [NSString stringWithFormat:@"\r\n--%@\r\n",stringBoundary];
	NSUInteger i=0;
	for (NSDictionary *key in self.postStrings) {
		[self appendpostStrings:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key]];
		[self appendpostStrings:[self.postStrings objectForKey:key]];
		i++;
		if ( self.postStrings.count > 0 || i != self.postStrings.count) { //Only add the boundary if this is not the last item in the post body
			[self appendpostStrings:endItemBoundary];
		}
	}

	// Adds files to upload
	i=0;
	for (NSDictionary *key in self.postDatas) {
        NSDictionary *val = [self.postDatas objectForKey:key];
		[self appendpostStrings:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", [val objectForKey:@"key"], [val objectForKey:@"fileName"]]];
		[self appendpostStrings:[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", [val objectForKey:@"contentType"]]];
		
		id data = [val objectForKey:@"data"];
		if ([data isKindOfClass:[NSString class]]) {
			[self appendPostDataFromFile:data];
		} else {
			[self appendPostData:data];
		}
		i++;
		// Only add the boundary if this is not the last item in the post body
		if (i != self.postDatas.count) { 
			[self appendpostStrings:endItemBoundary];
		}
	}
	
	[self appendpostStrings:[NSString stringWithFormat:@"\r\n--%@--\r\n",stringBoundary]];
}


- (void)addRequestHeader:(NSString *)header value:(NSString *)value
{
	if (!self.headers) {
        self.headers = [[NSMutableDictionary alloc] init];
	}
	[self.headers setObject:value forKey:header];
}

- (void)appendpostStrings:(NSString *)string
{
	[self appendPostData:[string dataUsingEncoding:NSUTF8StringEncoding]];
}

- (void)appendPostData:(NSData *)data
{
	if ([data length] == 0) {
		return;
	}
    [self.postBody appendData:data];
}

- (void)appendPostDataFromFile:(NSString *)file
{
	NSInputStream *stream = [[NSInputStream alloc] initWithFileAtPath:file];
	[stream open];
	NSUInteger bytesRead;
	while ([stream hasBytesAvailable]) {
		
		unsigned char buffer[1024*256];
		bytesRead = [stream read:buffer maxLength:sizeof(buffer)];
		if (bytesRead == 0) {
			break;
		}
        [self.postBody appendData:[NSData dataWithBytes:buffer length:bytesRead]];
	}
	[stream close];
}

- (NSString *) objectToString:(id) object{
    NSString *result;
    if ([object isKindOfClass:[NSString class]] == YES) {
        result = (NSString *)object;
    }else if ([object isKindOfClass:[NSDictionary class]] == YES) {
        result = [(NSDictionary *)object JSONRepresentation];
    }else if ([object isKindOfClass:[NSArray class]] == YES) {
        result = [(NSArray *)object JSONRepresentation];
    }else if ([object isKindOfClass:[NSNumber class]] == YES) {
        result = [(NSNumber *)object stringValue];
    }else if ([object isKindOfClass:[NSData class]] == YES) {
        result = [[NSString alloc] initWithData:(NSData *)object encoding:NSUTF8StringEncoding];
    }else {
        result = @"unknown object";
    }
    return result;
}

- (NSString *) urlEncode: (NSString *) string{
    NSString *escapedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                                  NULL,
                                                                                  (__bridge CFStringRef)string,
                                                                                  NULL,
                                                                                  (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                  kCFStringEncodingUTF8);
    return escapedString;
}

@end
