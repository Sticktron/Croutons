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

%new - (UIImage *)croutonImageForBundleId:(NSString *)bundleId {
    %log;
    
    /*
     * Get icon via UIImage private method.
     * Note: not working for me in all apps (sandbox issues?).
     */
    // UIImage *image = [UIImage _applicationIconImageForBundleIdentifier:bundleId format:0];
    // UIImage *image = [UIImage _applicationIconImageForBundleIdentifier:bundleId format:0 scale:[[UIScreen mainScreen] scale]];
    // image = [image _applicationIconImageForFormat:0 precomposed:YES];
    
    HBLogDebug(@"image for '%@' = %@", bundleId, image);
    return image;
}

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
    
    CGRect frame = self.frame;
    frame.size.width = 32; //TODO: calculate dynamically
    self.frame = frame;
    
    return ret;
}

%end

//------------------------------------------------------------------------------

%hook _UIStatusBarSystemNavigationItemButton
%property (nonatomic, retain) UIImageView *croutonView;

- (id)initWithFrame:(CGRect)frame {
    %log;
    if ((self = %orig)) {
        self.croutonView = [[UIImageView alloc] init];
        // self.croutonView.backgroundColor = UIColor.grayColor;
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
    
    // update crouton frame
    CGRect frame;
    float size = self.imageView.frame.size.width * 1.5; // 16px
    frame.origin.x = titleView.frame.origin.x;
    frame.origin.y = (self.bounds.size.height - size) * 0.5;
    frame.size = CGSizeMake(size, size);
    // HBLogDebug(@"setting croutonView.frame to: %@", NSStringFromCGRect(frame));
    self.croutonView.frame = frame;
    
    // round crouton corners
    // self.croutonView.layer.cornerRadius = floor(size / 4.0); // 3px
    
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
