#import <substrate.h>
#import <Foundation/Foundation.h>

@interface OpenEarthXProtocol : NSURLProtocol
@end

@implementation OpenEarthXProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    if ([NSURLProtocol propertyForKey:@"OpenEarthXHandled" inRequest:request]) return NO;
    if ([request.URL.host isEqualToString:@"kh.google.com"]) return YES;
    return NO;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    return request;
}

- (void)startLoading {
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperationWithBlock:^{
        NSURL *url = self.request.URL;
        NSMutableURLRequest *newReq = [self.request mutableCopy];
        if ([url.host isEqualToString:@"kh.google.com"]) {
            [newReq setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6.1 Safari/605.1.15" forHTTPHeaderField:@"User-Agent"];
            if ([url.path isEqualToString:@"/dbRoot.v5"]) {
                NSString *query = url.query;
                if (query && [query rangeOfString:@"&type=embedded"].location != NSNotFound) {
                    NSString *newQuery = [query stringByReplacingOccurrencesOfString:@"&type=embedded" withString:@""];
                    NSString *newURLStr = [[url absoluteString] stringByReplacingOccurrencesOfString:query withString:newQuery];
                    newReq.URL = [NSURL URLWithString:newURLStr];
                }
            }
        }
		NSURLResponse *response = nil;
		NSError *error = nil;
		[NSURLProtocol setProperty:[NSNumber numberWithBool:YES] forKey:@"OpenEarthXHandled" inRequest:newReq];
		NSData *data = [NSURLConnection sendSynchronousRequest:newReq returningResponse:&response error:&error];
		if (error) {
			[self.client URLProtocol:self didFailWithError:error];
			return;
		}
		[self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
		[self.client URLProtocol:self didLoadData:data];
		[self.client URLProtocolDidFinishLoading:self];
	}];
}

- (void)stopLoading {
}

@end

%ctor {
	[NSURLProtocol registerClass:[OpenEarthXProtocol class]];
}