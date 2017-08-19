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
@property (nonatomic, retain) NSString *croutonBundleId;
@end

@interface UIStatusBarOpenInSafariItemView (Croutons)
@property (nonatomic, retain) NSString *croutonBundleId;
@end

#define DIRTY_HACK_MARGIN 4.0f

// static CPDistributedMessagingCenter *messageCenter;

static UIImage *croutonImageForBundleId(NSString *bundleId) {
    if (!bundleId) {
        DebugLogC(@"croutonImageForBundleId > Error: no bundleId");
        return nil;
    }
    
    // Get icon from private UIImage class method (NOTE failing in sandboxed apps sometimes !?)
    UIImage *image = [UIImage _applicationIconImageForBundleIdentifier:bundleId format:0 scale:[UIScreen mainScreen].scale];
    
    // Get app icon via XPC (rocketbootstrap)
    // NSDictionary *sendData = @{ @"bundleId": bundleId };
    // DebugLogC(@"croutonImageForBundleId > Calling out to SpringBoard via rocketbootstrap...");
    // NSDictionary *replyData = [messageCenter sendMessageAndReceiveReplyName:kDMCGetCroutonMessage userInfo:sendData];
    // if (!replyData[@"croutonImageData"]) {
    //     DebugLogC(@"croutonImageForBundleId > Error: no image data for crouton");
    //     return nil;
    // }
    // UIImage *image = [UIImage imageWithData:replyData[@"croutonImageData"] scale:[UIScreen mainScreen].scale];
    // if (!image) {
    //     DebugLogC(@"croutonImageForBundleId > Error: can't get an image from data");
    //     return nil;
    // }
    
    DebugLogC(@"croutonImageForBundleId > got image for '%@' = %@", bundleId, image);
    return image;
}

//------------------------------------------------------------------------------

%hook UIStatusBarBreadcrumbItemView
%property (nonatomic, retain) NSString *croutonBundleId;
- (void)setSystemNavigationAction:(UISystemNavigationAction *)action {
    %orig;
    
    if (!self.croutonBundleId) {
        NSString *targetBundleId = [action bundleIdForDestination:0];
        if (targetBundleId) {
            DebugLog(@"target bundle ID = %@", targetBundleId);
            self.croutonBundleId = targetBundleId;
            
            // for Spotlight icon:
            if ([self.croutonBundleId isEqualToString:@"com.apple.springboard.spotlight-placeholder"]) {
                UIImage *image = [UIImage imageNamed:@"UITabBarSearch" inBundle:[NSBundle bundleWithPath:@"/Applications/Bridge.app"]];
                if (image) {
                    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                    DebugLog(@"setting crouton image to: %@", image);
                    self.button.croutonView.image = image;
                }
                
            } else {
                // for App icons:
                UIImage *image = croutonImageForBundleId(self.croutonBundleId);
                if (image) {
                    DebugLog(@"setting crouton image to: %@", image);
                    self.button.croutonView.image = image;
                }
            }
        }
    }
}
- (float)updateContentsAndWidth {
    float ret = %orig;
    
    // self.backgroundColor = UIColor.redColor; //DEBUG
    
    // Update item width
    CGRect frame = self.frame;
    frame.size.width = frame.size.height * 1.6; // 32px
    DebugLog(@"setting item frame to: %@", NSStringFromCGRect(frame));
    self.frame = frame;
    
    return ret;
}
%end

//------------------------------------------------------------------------------

%hook UIStatusBarOpenInSafariItemView
%property (nonatomic, retain) NSString *croutonBundleId;
- (float)updateContentsAndWidth {
    float ret = %orig;
    
    // self.backgroundColor = UIColor.redColor; //DEBUG
    
    // Set icon (one time)
    if (!self.croutonBundleId) {
        self.croutonBundleId = @"com.apple.mobilesafari";
        self.button.croutonView.image = croutonImageForBundleId(self.croutonBundleId);
    }
    
    // Update item width
    CGRect frame = self.frame;
    frame.size.width = frame.size.height * 1.6; // 32px
    DebugLog(@"setting item frame to: %@", NSStringFromCGRect(frame));
    self.frame = frame;
    
    return ret;
}
%end

//------------------------------------------------------------------------------

%hook _UIStatusBarSystemNavigationItemButton
%property (nonatomic, retain) UIImageView *croutonView;
%property (nonatomic, assign) BOOL hasFinishedLayout;
- (id)initWithFrame:(CGRect)frame {
    if ((self = %orig)) {
        // self.backgroundColor = UIColor.greenColor; //DEBUG
        
        self.croutonView = [[UIImageView alloc] init];
        // self.croutonView.backgroundColor = [UIColor colorWithRed:1 green:0.5 blue:0.5 alpha:1]; //DEBUG
        [self addSubview:self.croutonView];
    }
    return self;
}
- (void)layoutSubviews {
    %orig;
    
    UILabel *titleView = [self _titleView];
    DebugLog(@"[self _titleView] = %@", titleView);
    if (!titleView) { return; } // wait until titleView has been created
    
    // Hide the title view
    titleView.hidden = YES;
    
    // Adjust frames...
    
    // crouton size
    CGRect frame = self.croutonView.frame;
    frame.size = CGSizeMake(self.bounds.size.height, self.bounds.size.height); //15x15px
    self.croutonView.frame = frame;
        
    if (![self shouldLayoutImageOnRight]) {
        // crouton position
        CGRect frame;
        frame = self.croutonView.frame;
        frame.origin.x = titleView.frame.origin.x;
        DebugLog(@"setting croutonView origin to: (%.2f, %.2f)", frame.origin.x, frame.origin.y);
        self.croutonView.frame = frame;
        
        // button width
        frame = self.frame;
        frame.size.width = self.croutonView.frame.origin.x + self.croutonView.frame.size.width;
        DebugLog(@"setting button frame to: %@", NSStringFromCGRect(frame));
        self.frame = frame;
        
    } else {
        // crouton position
        CGRect frame = self.croutonView.frame;
        frame.origin.x = 0; // necessary??
        DebugLog(@"setting croutonView origin to: (%.2f, %.2f)", frame.origin.x, frame.origin.y);
        self.croutonView.frame = frame;
        
        // button width
        frame = self.frame;
        frame.size.width = self.croutonView.frame.size.width + self.imageView.frame.size.width + DIRTY_HACK_MARGIN;
        DebugLog(@"setting button frame to: %@", NSStringFromCGRect(frame));
        self.frame = frame;
        
        // chevron position
        frame = self.imageView.frame;
        DebugLog(@"self.imageView.frame = %@", NSStringFromCGRect(frame));
        frame.origin.x = self.bounds.size.width - self.imageView.frame.size.width;
        DebugLog(@"setting chevron origin to: %.2f x %.2f", frame.origin.x, frame.origin.y);
        self.imageView.frame = frame;
    }
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
        
        // messageCenter = [CPDistributedMessagingCenter centerNamed:kDMCName];
        // rocketbootstrap_distributedmessagingcenter_apply(messageCenter);
        
        %init;
	}
}
