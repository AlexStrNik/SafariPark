//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//

#import <Foundation/Foundation.h>

@interface SFAutoFillOneTimeCode : NSObject
@property (nonatomic, readonly, copy) NSString *GUID;
@property (nonatomic, readonly, copy) NSURL *_domainBoundEmbeddedURL;
@property (nonatomic, readonly, copy) NSURL *_domainBoundTopLevelURL;
@property (nonatomic, readonly, copy) NSString *code;
@property (nonatomic, readonly, copy) NSString *detectedCode;
@property (nonatomic, readonly, copy) NSString *displayCode;
@property (nonatomic, readonly, copy) NSString *domain;
@property (nonatomic, readonly) BOOL domainStrictMatch;
@property (nonatomic, readonly, copy) NSString *embeddedDomain;
@property (nonatomic, readonly, copy) NSArray *embeddedDomains;
@property (nonatomic, readonly, copy) NSString *handle;
@property (nonatomic, readonly) NSDate *lastUseDateOfAssociatedSavedAccount;
@property (nonatomic, readonly, copy) NSString *machineReadableCode;
@property (nonatomic, readonly) long long messageID;
@property (nonatomic, readonly) long long source;
@property (nonatomic, readonly) NSDate *timestamp;
@property (nonatomic, readonly, copy) NSString *user;
@end

@interface SFAppAutoFillOneTimeCodeProvider : NSObject
- (id)init;
- (void)setDelegate:(id)arg1;
- (void)didFocusOneTimeCodeField;
- (void)addObserver:(id)arg1;
- (id)_mostRecentlyReceivedOneTimeCode;
- (void)consumeCurrentOneTimeCode;
@end
