#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "../Headers/DisableInjector.h"
#include <sys/syscall.h>

@interface RBSProcessIdentity : NSObject
@property(readonly, copy, nonatomic) NSString *embeddedApplicationIdentifier;
@end

@interface FBProcessExecutionContext : NSObject
@property (nonatomic,copy) NSDictionary* environment;
@property (nonatomic,copy) RBSProcessIdentity* identity;
@end

BOOL isSubstitute = ([[NSFileManager defaultManager] fileExistsAtPath:@"/usr/lib/libsubstitute.dylib"] && ![[NSFileManager defaultManager] fileExistsAtPath:@"/usr/lib/substrate"] && ![[NSFileManager defaultManager] fileExistsAtPath:@"/usr/lib/libhooker.dylib"]);
const char *DisableLocation = "/var/tmp/.substitute_disable_loader";

%group DisableInjector
%hook _SBApplicationLaunchAlertInfo
-(NSString *)bundleID {
	if (isSubstitute && syscall(SYS_access, DisableLocation, F_OK) != -1) {
		//NSLog(@"[test] _SBApplicationLaunchAlertInfo bundleID = %@", orig);
		//NSLog(@"[test] Found DisableLocation.");
		int rmResult = remove(DisableLocation);
		if(rmResult == -1) {
			//NSLog(@"[test] Failed to remove file.");
		}
	}
	return %orig;
}
%end


//iOS 13 Higher
%hook FBProcessManager
- (id)_createProcessWithExecutionContext: (FBProcessExecutionContext*)executionContext {
	NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/kr.xsf1re.flyjb.plist"];
	NSMutableDictionary *prefs_disabler = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/kr.xsf1re.flyjb_disabler.plist"];
	NSString *bundleID = executionContext.identity.embeddedApplicationIdentifier;
	if([bundleID isEqualToString:@"com.vivarepublica.cash"]) {
		return %orig;
	}

	if([prefs[@"enabled"] boolValue]) {
		//NSLog(@"[test] FBProcessManager _createProcessWithExecutionContext, bundleIDx = %@", bundleIDx);
		if ([prefs_disabler[bundleID] boolValue]) {
			//NSLog(@"[test] FBProcessManager disabler ENABLED");
			if(isSubstitute) {
				FILE* fp = fopen(DisableLocation, "w");
				if (fp == NULL) {
					//NSLog(@"[test] Failed to write DisableLocation.");
				}
			}
			else {
				NSMutableDictionary* environmentM = [executionContext.environment mutableCopy];
				[environmentM setObject:@(1) forKey:@"_MSSafeMode"];
				[environmentM setObject:@(1) forKey:@"_SafeMode"];
				executionContext.environment = [environmentM copy];
			}

		}
	}
	return %orig;
}

//iOS 12 Lower
-(id)createApplicationProcessForBundleID: (NSString *)bundleID withExecutionContext: (FBProcessExecutionContext*)executionContext {
	NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/kr.xsf1re.flyjb.plist"];
	NSMutableDictionary *prefs_disabler = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/kr.xsf1re.flyjb_disabler.plist"];
	if([bundleID isEqualToString:@"com.vivarepublica.cash"]) {
		return %orig;
	}

	if([prefs[@"enabled"] boolValue]) {
		//NSLog(@"[test] FBProcessManager createApplicationProcessForBundleID, bundleIDx = %@", bundleIDx);
		if ([prefs_disabler[bundleID] boolValue]) {
			//NSLog(@"[test] FBProcessManager disabler ENABLED");
			if(isSubstitute) {
				FILE* fp = fopen(DisableLocation, "w");
				if (fp == NULL) {
					//NSLog(@"[test] Failed to write DisableLocation.");
				}
			}
			else {
				NSMutableDictionary* environmentM = [executionContext.environment mutableCopy];
				[environmentM setObject:@(1) forKey:@"_MSSafeMode"];
				[environmentM setObject:@(1) forKey:@"_SafeMode"];
				executionContext.environment = [environmentM copy];
			}


		}
	}
	return %orig;
}
%end
%end

void loadDisableInjector() {
	%init(DisableInjector);
}
