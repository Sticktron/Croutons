//
//  Croutons
//
//  Shortens the "breadcrumb trail" StatusBar item by showing
//  the App's icon instead of its name.
//
//  Sticktron/2017.
//

#import "headers.h"

@interface _UIStatusBarSystemNavigationItemButton (Croutons)
@property (nonatomic, strong) UIImageView *croutonView;
@end

@interface UIStatusBarBreadcrumbItemView (Croutons)
- (id)croutonImageForBundleId:(NSString *)bundleId;
@end

static NSString *const kPrefsPlistPath = @"/var/mobile/Library/Preferences/com.sticktron.croutons.plist";

//------------------------------------------------------------------------------

%hook UIStatusBarBreadcrumbItemView

- (void)setSystemNavigationAction:(UISystemNavigationAction *)action {
    %log;
    %orig;
    
    NSString *targetBundleId = [action bundleIdForDestination:0];
    HBLogDebug(@"target bundle ID = %@", targetBundleId);
    self.button.croutonView.image = [self croutonImageForBundleId:targetBundleId];
}

- (float)updateContentsAndWidth {
    %log;

    float ret = %orig;

    // self.backgroundColor = UIColor.greenColor;
    
    CGRect frame = self.frame;
    frame.size.width = 32; //TODO: calculate dynamically
    self.frame = frame;
//     self.clipsToBounds = YES;

//     // get bundle id of target app
//     NSString *targetBundleId = [self.systemNavigationAction bundleIdForDestination:0];
//     HBLogDebug(@"target bundle ID = %@", targetBundleId);
//     // if ([targetBundle hasPrefix:@"com.apple.springboard"]) targetBundle = @"com.apple.springboard";
//     self.button.croutonView.image = [self croutonImageForBundleId:targetBundleId];

    return ret;
}

%new - (UIImage *)croutonImageForBundleId:(NSString *)bundleId {
    // float scale = UIScreen.mainScreen.scale;
    // HBLogWarn(@"scale = %.2f", scale);
    // UIImage *image = [UIImage _applicationIconImageForBundleIdentifier:bundleId format:0 scale:scale];

    UIImage *image = [UIImage _applicationIconImageForBundleIdentifier:bundleId format:0];
    image = [image _applicationIconImageForFormat:0 precomposed:YES]; //29x29
    HBLogWarn(@"image for '%@' = %@", bundleId, image);
    return image;
}

%end

//------------------------------------------------------------------------------

%hook _UIStatusBarSystemNavigationItemButton
%property (nonatomic, retain) UIImageView *croutonView;

- (id)initWithFrame:(CGRect)frame {
    %log;
    if ((self = %orig)) {
        // self.backgroundColor = UIColor.redColor;
        
        self.croutonView = [[UIImageView alloc] init];
        self.croutonView.backgroundColor = UIColor.grayColor;
        [self addSubview:self.croutonView];
    }
    return self;
}

- (void)layoutSubviews {
    %log;
    %orig;
    
    // hide button title
    UILabel *titleView = [self _titleView];
    titleView.hidden = YES;
    
    // update crouton view
    CGRect frame;
    float size = self.imageView.frame.size.width * 1.5; // 16px
    frame.origin.x = titleView.frame.origin.x;
    frame.origin.y = (self.bounds.size.height - size) * 0.5;
    frame.size = CGSizeMake(size, size);
    // HBLogDebug(@"setting croutonView.frame to: %@", NSStringFromCGRect(frame));
    self.croutonView.frame = frame;
    self.croutonView.layer.cornerRadius = floor(size / 4.0); // 3px
    
    // update button frame
    frame = self.frame;
    frame.size.width = self.croutonView.frame.origin.x + self.croutonView.frame.size.width;
    self.frame = frame;
    
    // update item frame
    // frame = self.superview.frame;
    // frame.size.width = self.frame.size.width;
    // self.superview.frame = frame;
}

%end

//------------------------------------------------------------------------------

//------------------------------------------------------------------------------

%ctor {
	@autoreleasepool {
		HBLogDebug(@"Croutons loaded");
        
        // load settings
        NSDictionary *settings = [NSMutableDictionary dictionaryWithContentsOfFile:kPrefsPlistPath];
        BOOL isEnabled = settings[@"Enabled"] ? [settings[@"Enabled"] boolValue] : YES;
        HBLogDebug(@"Croutons is: %@", isEnabled ? @"Enabled" : @"Disabled");
        
        if (!isEnabled) return;
        
        %init;
	}
}
