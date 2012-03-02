//
//  MIRequest.m
//  requester
//
//  Created by Wu Chang on 12-2-27.
//  Copyright (c) 2012年 Milan. All rights reserved.
//

#import "MIRequest.h"

@implementation MIRequest
@synthesize delegate = _delegate, _requester, timeout, json, receivedData, _hasDone, _isExecuting, method, url, getURL, getParams, postStrings, postDatas, postBody, headers;

- (id)init
{
    self = [super init];
    if (self) {
        self.postBody = [[NSMutableData alloc] init];
        self.method = @"POST";
        self.timeout = 20.0;
        self.headers = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(void)start
{
    self._isExecuting = YES;
    self._hasDone = NO;

    self._requester = [self buildRequest];
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:self._requester delegate:self startImmediately:NO];
    // Here is the trick
    NSRunLoop* runLoop = [NSRunLoop currentRunLoop];
    [runLoop addPort:[NSPort port] forMode:NSDefaultRunLoopMode];
    [theConnection scheduleInRunLoop:runLoop forMode:NSDefaultRunLoopMode];
    [theConnection start];
    if (theConnection) {
        self.receivedData = [NSMutableData data];
    }
    //[runLoop run];
    NSDate *dateLimit = [[NSDate date] addTimeInterval:0.5];
    //NSDate *future = [NSDate distantFuture];

    while (![self isCancelled]){
        //NSLog(@"in start %@",[NSThread currentThread]);
        [NSTimer scheduledTimerWithTimeInterval:self.timeout target:self selector:@selector(handleTimer:) userInfo:self repeats:NO];
        [runLoop runUntilDate:dateLimit];
    }
}

- (NSData *) syncRequest{
    NSMutableURLRequest *theRequest = [self buildRequest];
    NSError *err; 
    NSData *data = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:nil error:&err];
    if(data == nil) {
		NSLog(@"Code:%d,domain:%@,localizedDesc:%@",[err code],
			  [err domain],[err localizedDescription]);
	}
    return data;
}

- (void) asyncRequest{
    NSMutableURLRequest *theRequest = [self buildRequest];
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self startImmediately:YES];
    if (theConnection) {
        self.receivedData = [NSMutableData data];
    } else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Network Error"
                                                       message:@"Failed to connect to network, please check the network configuration"
                                                      delegate:self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil,nil];
        [alert show];
    }
}

- (NSMutableURLRequest *) buildRequest {
    if (self.delegate == nil) {
        self.delegate = self;
    }
    if (self.method == @"POST") {
        if (self.postDatas != nil) {
            [self buildMultipartFormDataPostBody];
        }else {
            [self buildPostBody];
        }
    }
    [self buildURL];
    NSURL *theURL = [[NSURL alloc]initWithString:self.url];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:theURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:self.timeout];
    [theRequest setHTTPMethod:self.method];
    [theRequest setHTTPBody:self.postBody];
    [theRequest setTimeoutInterval:self.timeout]; //does not work according to web search
    [self.headers setObject:@"1.0" forKey:@"APIVersion"];
    [self.headers setObject:@"gzip,deflate" forKey:@"Accept-Encoding"];
    [theRequest setAllHTTPHeaderFields:self.headers];
    //[theRequest setValue:@"1.0" forHTTPHeaderField:@"APIVersion"];
    return theRequest;
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
    NSCachedURLResponse *newCachedResponse = cachedResponse;
    //NSCachedURLResponse *newCachedResponse = [[NSCachedURLResponse alloc] initWithResponse:cachedResponse.response data:cachedResponse.data userInfo:cachedResponse.userInfo storagePolicy:NSURLCacheStorageAllowed];
    if ([[[[cachedResponse response] URL] scheme] isEqual:@"https"]) {
        newCachedResponse = nil;
    } else {
        NSDictionary *newUserInfo;
        newUserInfo = [NSDictionary dictionaryWithObject:[[NSDate date] addTimeInterval:86400] forKey:@"Cached Date"];
        newCachedResponse = [[NSCachedURLResponse alloc]
                             initWithResponse:[cachedResponse response]
                             data:[cachedResponse data]
                             userInfo:newUserInfo
                             storagePolicy:[cachedResponse storagePolicy]];
    }
    return newCachedResponse;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSHTTPURLResponse *)response
{
    //NSLog(@"%@",[response allHeaderFields]);
    [self.receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // inform the user
    if ([self.delegate respondsToSelector:@selector(connection:didFailWithError:)]) {
        [self.delegate performSelector:@selector(connection:didFailWithError:) withObject:connection withObject:error];
    }else {
        NSLog(@"Connection failed! Error - %@ %@",
              [error localizedDescription],
              [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Network Error in Request Manager"
                                                       message:[error localizedDescription]
                                                      delegate:self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil,nil];
        [alert show];
    }
    [self cancel];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //NSLog(@"%@",[[connection currentRequest] ]);
    if ([self.delegate respondsToSelector:@selector(connectionDidFinishLoading:)]) {
        NSDictionary *response;
        if (self.json) {
            response = [self.receivedData JSONValue];
        }else {
            response = [NSDictionary dictionaryWithObjectsAndKeys:self.receivedData, @"data", nil];
        }
        [self cancel];
        //[self.delegate performSelectorOnMainThread:@selector(connectionDidFinishLoading:) withObject:response waitUntilDone:NO];
        [self.delegate performSelector:@selector(connectionDidFinishLoading:) withObject:response];
    }
}

-(void)handleTimer:(NSTimer*)timer {
    MIRequest *operation = timer.userInfo;
    operation._requester = nil;
    if ([self.delegate respondsToSelector:@selector(connection:didFailWithError:)]) {
        [self.delegate performSelector:@selector(connection:didFailWithError:) withObject:operation._requester withObject:[NSError errorWithDomain:@"domain" code:NSURLErrorTimedOut userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"The request timed out.", NSURLErrorFailingURLStringErrorKey, nil]]];
    };
    [timer invalidate];
    [self cancel];
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
