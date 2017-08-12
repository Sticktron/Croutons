//
//  Croutons: Preferences
//

#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#import <spawn.h>

static NSString *const kPrefsPlistPath = @"/var/mobile/Library/Preferences/com.sticktron.croutons.plist";

@interface CRRootListController : PSListController
@end

@implementation CRRootListController

- (id)specifiers {
	if (_specifiers == nil) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}
	return _specifiers;
}

/* Manually keep the plist up to date because the tweak runs in sandboxed apps */
- (id)readPreferenceValue:(PSSpecifier*)specifier {
	NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:kPrefsPlistPath];
	if (!settings[specifier.properties[@"key"]]) {
		return specifier.properties[@"default"];
	}
	return settings[specifier.properties[@"key"]];
}
- (void)setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier {
	NSMutableDictionary *settings = [NSMutableDictionary dictionary];
	[settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:kPrefsPlistPath]];
	[settings setObject:value forKey:specifier.properties[@"key"]];
	[settings writeToFile:kPrefsPlistPath atomically:NO]; //sandbox issue if atomic!
	
	NSString *notificationValue = specifier.properties[@"PostNotification"];
	if (notificationValue) {
		CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), (CFStringRef)notificationValue, NULL, NULL, YES);
	}
}

/* Show Respring alert */
- (void)respring {
	UIAlertController *alert = [UIAlertController
		alertControllerWithTitle:@"Respring"
		message:@"Restart SpringBoard now?"
		preferredStyle:UIAlertControllerStyleAlert];
	
	UIAlertAction *defaultAction = [UIAlertAction
		actionWithTitle:@"OK"
		style:UIAlertActionStyleDefault
		handler:^(UIAlertAction *action) {
			// respring!
			[self respringNow];
		}];
	[alert addAction:defaultAction];
	UIAlertAction *cancelAction = [UIAlertAction
		actionWithTitle:@"Cancel"
		style:UIAlertActionStyleCancel
		handler:nil];
	[alert addAction:cancelAction];
	[self presentViewController:alert animated:YES completion:nil];
}
- (void)respringNow {
	NSLog(@"Croutons: User requested a respring.");
	pid_t pid;
	const char* args[] = { "killall", "-9", "backboardd", NULL };
	posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)args, NULL);
}

@end
