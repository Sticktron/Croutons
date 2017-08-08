//
//  Croutons
//
//  Shortens the "breadcrumb trail" StatusBar item by showing
//  the App's icon instead of its name.
//
//  Sticktron/2017.
//

#import "headers.h"


static UIImage *appIconForBundleIdentifier(NSString *bundleId) {
    HBLogDebug(@"getting image for: %@", bundleId);

    UIImage *image = [UIImage _applicationIconImageForBundleIdentifier:bundleId format:0];
    HBLogWarn(@"image = %@", image);

    return image;
}


@interface _UIStatusBarSystemNavigationItemButton (Croutons)
@property (nonatomic, strong) UIImage *appIconImage;
@property (nonatomic, strong) UIImageView *appIconView;
@end


%hook _UIStatusBarSystemNavigationItemButton
%property (nonatomic, retain) UIImage *appIconImage;
%property (nonatomic, retain) UIImageView *appIconView;

- (id)initWithFrame:(CGRect)frame {
    %log;
    if ((self = %orig)) {
        self.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.25];

        self.appIconImage = appIconForBundleIdentifier(NSBundle.mainBundle.bundleIdentifier);
        HBLogDebug(@"self.appIconImage = %@", self.appIconImage);

        self.appIconView = [[UIImageView alloc] init];
        self.appIconView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:0.25];
        self.appIconView.image = self.appIconImage;
        HBLogDebug(@"self.appIconView = %@", self.appIconView);
        [self addSubview:self.appIconView];
    }
    return self;
}

- (void)layoutSubviews {
    // %log;
    %orig;

    // [self setTitle:@"--" forState:UIControlStateNormal];

    CGRect frame;

    // Adjust appIconView frame...

    // UIView *label = [self _titleView];
    // CGRect frame;
    // frame.origin.x = label.frame.origin.x;
    // frame.origin.x = label.frame.origin.x;
    // frame.size = CGSizeMake(self.bounds.size.height, self.bounds.size.height);
    // frame = self.appIconView.frame;
    // self.appIconView.frame = frame;

    UIView *label = [self _titleView];
    HBLogDebug(@"titleView = %@", label);
    UIView *chevron = [self _imageView];
    HBLogDebug(@"imageView = %@", chevron);

    frame = (CGRect){ {self.imageView.frame.origin.x + self.imageView.frame.size.width + 4, 0}, {self.bounds.size.height, self.bounds.size.height} }; //programaticcaly determines + padding, just cus
    self.appIconView.frame = frame;

    //this probably did something worthwhile so ill leave it incase
    //BLogDebug(@"setting frmae as self.frame %@", NSStringFromCGRect(self.frame));
    // Adjust main frame
    //frame = self.frame;
    //frame.size.width = self.appIconView.frame.origin.x + self.appIconView.frame.size.width;
    //frame.size.width += 4; //padding
    //self.frame = frame;

    // Adjust parent frame (actual StatusBar item view)
    // UIStatusBarBreadcrumbItemView *sv = (UIStatusBarBreadcrumbItemView *)[self superview];
    // HBLogDebug(@"superview = %@", sv);
    // sv.backgroundColor = UIColor.yellowColor;
    // frame = sv.frame;
    // frame.size.width = self.frame.size.width;
    // frame.size.width += 4; //padding
    // sv.frame = frame;
}

// + (BOOL)_buttonTypeIsModernUI:(int)arg1 { %log; BOOL r = %orig; HBLogDebug(@" = %d", r); return r; }
// - (CGRect)imageRectForContentRect:(CGRect)arg1 { %log; CGRect r = %orig; HBLogDebug(@" = {{%g, %g}, {%g, %g}}", r.origin.x, r.origin.y, r.size.width, r.size.height); return r; }
// - (BOOL)shouldLayoutImageOnRight { %log; BOOL r = %orig; HBLogDebug(@" = %d", r); return r; }
// - (CGRect)titleRectForContentRect:(CGRect)arg1 { %log; CGRect r = %orig; HBLogDebug(@" = {{%g, %g}, {%g, %g}}", r.origin.x, r.origin.y, r.size.width, r.size.height); return r; }
// - (id)imageView { %log; id r = %orig; HBLogDebug(@" = %@", r); return r; }
// - (id)_imageView { %log; id r = %orig; HBLogDebug(@" = %@", r); return r; }
// - (id)_titleView { %log; id r = %orig; HBLogDebug(@" = %@", r); return r; }
%end



#pragma mark - Breadcrumb Item View --------------------------------------------

%hook UIStatusBarBreadcrumbItemView

// - (id)initWithItem:(id)arg1 data:(id)arg2 actions:(int)arg3 style:(id)arg4 { %log; id r = %orig; HBLogDebug(@" = %@", r); return r; }

- (void)setTitle:(id)arg1 {
    %log;
    %orig(@"");
}

// - (BOOL)updateForNewData:(id)arg1 actions:(int)arg2 {
//     %log;
//     BOOL r = %orig;
//
//     _UIStatusBarSystemNavigationItemButton *btn = [self button];
//     HBLogDebug(@"btn = %@", btn);
//
//     return r;
// }

- (float)updateContentsAndWidth {
    %log;
	float r = %orig;

    // [self invalidateIntrinsicContentSize];

    _UIStatusBarSystemNavigationItemButton *btn = [self button];
    HBLogDebug(@"btn = %@", btn);

    // [btn setTitle:@"  " forState:UIControlStateNormal];
    // [[btn _titleView] setHidden:YES];

    // Get app icon from bundle, if necessary
    // if (!appIcon) {
    //     NSString* bundleId = [[NSBundle mainBundle] bundleIdentifier];
    //     HBLogDebug(@"bundleId = %@", bundleId);
    //     appIcon = [UIImage _applicationIconImageForBundleIdentifier:bundleId format:1];
    //     HBLogDebug(@"appIcon for bundle = %@", appIcon);
    // }

    // UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 0, 12, 12)];
    // iconView.image = appIcon;

    // Adjust iconView frame
    // CGRect frame = iconView.frame;
    // frame.origin.y = (btn.bounds.size.height - iconView.frame.size.height) / 2.0;
    // iconView.frame = frame;
    // HBLogDebug(@"iconView.frame = %@", NSStringFromCGRect(iconView.frame));

    // [btn addSubview:iconView];

    // Adjust nav button frame
    // frame = btn.frame;
    // frame.size.width = 32;
    // btn.clipsToBounds = YES;
    // btn.frame = frame;
    // HBLogDebug(@"btn.frame = %@", NSStringFromCGRect(btn.frame));
    HBLogDebug(@"self.frame %@", NSStringFromCGRect(self.frame));
    CGRect frame = self.frame;
    // frame.size.width = btn.frame.size.width;
    frame.size.width = frame.size.width * 2; //ok this actually seems to work with no problems tho  //self.frame.size.width + self.bounds.size.height - 4; //above we worked off the height and set it as the width so we can do the same here prob //32; // TODO: Replace hard-coded value
    self.frame = frame;

    HBLogDebug(@"self.frame after %@", NSStringFromCGRect(self.frame));

    self.clipsToBounds = YES;

    return r;
}

// - (void)layoutSubviews {
    // %log;
    // %orig;
    //
    // CGRect frame = self.frame;
    // frame.size.width = 32;
    // [self setFrame:frame];
    // HBLogDebug(@"frame=%@", NSStringFromCGRect(self.frame));
// }

// - (void)viewWillMoveToSuperview:(id)arg1 { %log; %orig; }
// - (void)willMoveToSuperview:(id)arg1 { %log; %orig; }
// - (void)willMoveToWindow:(id)arg1 { %log; %orig; }

// - (id)_createButton {
//     %log;
//     _UIStatusBarSystemNavigationItemButton *btn = %orig;
//     HBLogDebug(@" = %@", btn);
//     return btn;
// }

// - (void)setButton:(_UIStatusBarSystemNavigationItemButton *)btn {
//     %log;
//     %orig;
// }

// - (_UIStatusBarSystemNavigationItemButton *)button {
//     %log;
//     _UIStatusBarSystemNavigationItemButton *btn = %orig;
//     HBLogDebug(@" = %@", btn);
//     return btn;
// }


%end


%ctor {
	@autoreleasepool {
		NSLog(@"Croutons, by Sticktron.");

        // TODO: Load Prefs
        // Enabled: YES/NO

        // TODO: Should filter out some non-UI process from hooks?

        %init;
	}
}
