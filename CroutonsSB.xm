//
//  Croutons
//
//  Shortens the "breadcrumb trail" StatusBar item by showing
//  the App's icon instead of its name.
//
//  Sticktron/2017.
//

#define DEBUG_PREFIX @"[Croutons-SB]"
#include "DebugLog.h"

#import "headers.h"
#import "common.h"
#import <SpringBoard/SpringBoard.h>
#import <rocketbootstrap/rocketbootstrap.h>
#import <AppSupport/CPDistributedMessagingCenter.h>

/*
//IPC
@interface CPDistributedMessagingCenter
+ (id)centerNamed:(id)arg1;
- (BOOL)sendMessageName:(id)arg1 userInfo:(id)arg2;
- (void)runServerOnCurrentThread;
- (void)registerForMessageName:(id)arg1 target:(id)arg2 selector:(SEL)arg3;
- (id)sendMessageAndReceiveReplyName:(id)arg1 userInfo:(id)arg2;
@end
*/
static CPDistributedMessagingCenter *messageCenter;

//------------------------------------------------------------------------------

%hook SpringBoard

// RocketBootstrap init
- (void)applicationDidFinishLaunching:(id)application {
	%log;
	%orig;
    
    messageCenter = [CPDistributedMessagingCenter centerNamed:kDMCName];
    rocketbootstrap_distributedmessagingcenter_apply(messageCenter);
    [messageCenter runServerOnCurrentThread];
    [messageCenter registerForMessageName:kDMCGetCroutonMessage target:self selector:@selector(_handleGetCroutonImage:userInfo:)];
    DebugLogC(@"rocketbootstrap engage! messageCenter OK: %@", PRETTY_BOOL(messageCenter));
}

%new
- (NSDictionary *)_handleGetCroutonImage:(NSString *)name userInfo:(NSDictionary *)userInfo {
	DebugLog0;
	// DebugLog(@"name = %@", name);
	
	NSString *bundleId = userInfo[@"bundleId"];
	DebugLog(@"userInfo.bundleId = %@", bundleId);
	
	if (bundleId) {
		DebugLog(@"getting icon image for app: %@", bundleId);
		UIImage *image = [UIImage _applicationIconImageForBundleIdentifier:bundleId format:0 scale:[UIScreen mainScreen].scale];
		DebugLog(@"image = %@", image);
		
		if (image) {
			NSData *imageData = UIImagePNGRepresentation(image);
			
			NSMutableDictionary* result = [[NSMutableDictionary alloc] init];
			[result setObject:imageData forKey:@"croutonImageData"];
			return result;
		}
	}
	
	return nil;
}

%end

//------------------------------------------------------------------------------

%ctor {
	@autoreleasepool {
		DebugLogC(@"init server");
        
        // load settings
        NSDictionary *settings = [NSMutableDictionary dictionaryWithContentsOfFile:kPrefsPlistPath];
        BOOL isEnabled = settings[@"Enabled"] ? [settings[@"Enabled"] boolValue] : YES;
        DebugLogC(@"Croutons is: %@", isEnabled ? @"Enabled" : @"Disabled");
        
        if (!isEnabled) return;
        %init;
	}
}
