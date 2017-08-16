//
//  Croutons
//
//  Shortens the "breadcrumb trail" StatusBar item by showing
//  the App's icon instead of its name.
//
//  Sticktron/2017.
//

#define DEBUG_PREFIX @"[Croutons-UI]"
#include "DebugLog.h"

#import "headers.h"
#import "common.h"
#import <rocketbootstrap/rocketbootstrap.h>
#import <AppSupport/CPDistributedMessagingCenter.h>


@interface _UIStatusBarSystemNavigationItemButton (Croutons)
@property (nonatomic, strong) UIImageView *croutonView;
@end

@interface UIStatusBarBreadcrumbItemView (Croutons)
- (id)croutonImageForBundleId:(NSString *)bundleId;
@end

static CPDistributedMessagingCenter *messageCenter;

//------------------------------------------------------------------------------

%hook UIStatusBarBreadcrumbItemView

// %new - (UIImage *)croutonImageForBundleId:(NSString *)bundleId {
//     %log;
//
//     /*
//      * Get icon via UIImage private method.
//      * Note: not working for me in all apps (sandbox issues?).
//      */
//     // UIImage *image = [UIImage _applicationIconImageForBundleIdentifier:bundleId format:0];
//     UIImage *image = [UIImage _applicationIconImageForBundleIdentifier:bundleId format:0 scale:[[UIScreen mainScreen] scale]];
//     image = [image _applicationIconImageForFormat:0 precomposed:YES];
//
//     DebugLog(@"image for '%@' = %@", bundleId, image);
//     return image;
// }

%new - (UIImage *)croutonImageForBundleId:(NSString *)bundleId {
    // %log;
    if (!bundleId) {
        return nil;
    }
    
    /*
     * Get icon via XPC (rocketbootstrap).
     */
    NSDictionary *userInfo = @{ @"bundleId": bundleId };
    DebugLog(@"---------- Calling out to RocketBootstrap ----------");
    
    NSDictionary *replyData = [messageCenter sendMessageAndReceiveReplyName:kDMCGetCroutonMessage userInfo:userInfo];
    // DebugLogC(@"Got reply from DMC > %@", ONE_LINER(replyData));
    DebugLog(@"----------------------------------------------------");
    
    UIImage *image = [UIImage imageWithData:replyData[@"croutonImageData"]];
    DebugLog(@"image for '%@' = %@", bundleId, image);
    return image;
}

- (void)setSystemNavigationAction:(UISystemNavigationAction *)action {
    // %log;
    %orig;
    
    NSString *targetBundleId = [action bundleIdForDestination:0];
    DebugLog(@"target bundle ID = %@", targetBundleId);
    
    if (targetBundleId) {
        self.button.croutonView.image = [self croutonImageForBundleId:targetBundleId];
    }
}

- (float)updateContentsAndWidth {
    // %log;

    float ret = %orig;
    
    CGRect frame = self.frame;
    frame.size.width = self.button.frame.size.height * 2;
    self.frame = frame;
    
    return ret;
}

// - (void)setTitle:(id)title {
//     %log;
//     %orig(@"");
// }

%end

//------------------------------------------------------------------------------

%hook _UIStatusBarSystemNavigationItemButton
%property (nonatomic, retain) UIImageView *croutonView;

- (id)initWithFrame:(CGRect)frame {
    // %log;
    if ((self = %orig)) {
        self.croutonView = [[UIImageView alloc] init];
        [self addSubview:self.croutonView];
    }
    return self;
}

- (void)layoutSubviews {
    // %log;
    %orig;
    
    // hide button title
    UILabel *titleView = [self _titleView];
    titleView.hidden = YES;
    
    // update crouton frame
    CGRect frame;
    // float size = self.imageView.frame.size.width; // 12px
    frame.origin.x = titleView.frame.origin.x;
    // frame.origin.y = (self.bounds.size.height - size) * 0.5;
    // frame.origin.y = (self.bounds.size.height - self.croutonView.frame.size.height) * 0.5;
    frame.size = CGSizeMake(self.bounds.size.height, self.bounds.size.height);
    // DebugLog(@"setting croutonView.frame to: %@", NSStringFromCGRect(frame));
    self.croutonView.frame = frame;
    
    // update button frame
    frame = self.frame;
    frame.size.width = self.croutonView.frame.origin.x + self.croutonView.frame.size.width;
    self.frame = frame;
}

%end

//------------------------------------------------------------------------------

%ctor {
	@autoreleasepool {
        DebugLogC(@"init client");
        
        // load settings
        NSDictionary *settings = [NSMutableDictionary dictionaryWithContentsOfFile:kPrefsPlistPath];
        BOOL isEnabled = settings[@"Enabled"] ? [settings[@"Enabled"] boolValue] : YES;
        DebugLogC(@"Croutons is: %@", isEnabled ? @"Enabled" : @"Disabled");
        
        if (!isEnabled) return;
        
        messageCenter = [CPDistributedMessagingCenter centerNamed:kDMCName];
        rocketbootstrap_distributedmessagingcenter_apply(messageCenter);
        
        %init;
	}
}
