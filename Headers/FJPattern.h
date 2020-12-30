#import <substrate.h>
#import <Foundation/Foundation.h>
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface FJPattern: NSObject
- (BOOL)isCrashAppWithSubstitutor: (NSString *)bundleID;
- (BOOL)isAhnLabPathRestricted: (NSString *)path;
- (BOOL)isPathRestricted: (NSString *)path;
- (BOOL)isPathRestrictedForSymlink: (NSString *)path;
- (BOOL)isURLRestricted: (NSURL *)url;
- (BOOL)isSandBoxPathRestricted: (NSString*)path;
@end

static FJPattern *FJPatternX = [FJPattern new];
