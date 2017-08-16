//

static NSString *const kPrefsPlistPath = @"/var/mobile/Library/Preferences/com.sticktron.croutons.plist";
// static NSString *const kPrefsChangedNotification = CFSTR("com.sticktron.croutons.settingschanged");

static NSString *const kDMCName = @"com.sticktron.croutons";
static NSString *const kDMCGetCroutonMessage = @"com.sticktron.croutons.get-crouton";

#define ONE_LINER(x)		[[x description] stringByReplacingOccurrencesOfString:@"\n" withString:@" "]
#define PRETTY_BOOL(x)		(x) ? @"Yes" : @"No"
#define LOG_LINE()			HBLogDebug(@"----------------------------------------")
#define LOG_SPACE()			HBLogDebug(@" ")
