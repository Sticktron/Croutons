//
//  Croutons
//
//  Shortens the "breadcrumb trail" StatusBar item by showing
//  the App's icon instead of its name.
//
//  Sticktron/2017.
//

#import "headers.h"

//stuff
static NSString * targetBundle;
static UIImage * appIconImage; //woudl be easier to use as static properties i figure
static UIImageView * appIconWatcher;
@interface UIControlTargetAction : NSObject
@end

@interface UISystemNavigationAction : NSObject
-(id)bundleIdForDestination:(int)arg1;
@end

//


//
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
   //HBLogDebug(@"uiapplication %@", [%c(SpringBoard) mainApplication]);
    %log;
    if ((self = %orig)) {
      //target unknown this early, wait till layoutSubviews
        self.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.25];
        //HBLogDebug(@"bundlestuff %@", NSBundle.mainBundle.bundleIdentifier);
        //self.appIconImage = appIconForBundleIdentifier(NSBundle.mainBundle.bundleIdentifier);
        HBLogDebug(@"self.appIconImage = %@", self.appIconImage);
        self.appIconView = [[UIImageView alloc] init];
        self.appIconView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:0.25];
        self.appIconView.image = self.appIconImage;
        //HBLogDebug(@"self.appIconView = %@", self.appIconView);
        [self addSubview:self.appIconView];
        appIconWatcher = self.appIconView;
    }
    return self;
}

- (void)layoutSubviews {
    // %log;
    %orig;

    CGRect frame;


    frame = (CGRect){ {self.imageView.frame.origin.x + self.imageView.frame.size.width + 4, 0}, {self.bounds.size.height, self.bounds.size.height} }; //programaticcaly determines + padding, just cus
    self.appIconView.frame = frame;


}

%end



#pragma mark - Breadcrumb Item View --------------------------------------------

%hook UIStatusBarBreadcrumbItemView

- (void)setTitle:(id)arg1 {
    %log;
    %orig(@"");
}

- (float)updateContentsAndWidth {
    %log;
	float r = %orig;


    _UIStatusBarSystemNavigationItemButton *btn = [self button];
    HBLogDebug(@"btn = %@", btn);


    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width*2, self.frame.size.height);


    self.clipsToBounds = YES;

    //tada
    targetBundle = [self.systemNavigationAction bundleIdForDestination:0];
    HBLogDebug(@"targetbundle is %@", targetBundle);
    if ([targetBundle hasPrefix:@"com.apple.springboard"]) targetBundle = @"com.apple.springboard";
    if (targetBundle){
      appIconImage = appIconForBundleIdentifier(targetBundle);
      HBLogDebug(@"value of appIconImage %@", appIconImage);
            //HBLogDebug(@"appiconimage %@", self.appIconImage);
            if (appIconWatcher) appIconWatcher.image = appIconImage;
   }

    return r;
}




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
