//
//  Croutons
//
//  Shortens the "breadcrumb trail" StatusBar item by showing
//  the App's icon instead of its name.
//
//  Sticktron/2017.
//

#import "headers.h"

static NSDictionary * prefs; //cant use cfprefs because they 100% do not update instantly in sandboxed apps
static UIImageView * appIconWatcher;

static UIImage *appIconForBundleIdentifier(NSString *bundleId) {
    HBLogDebug(@"getting image for: %@", bundleId);
    UIImage *image = [%c(UIImage) _applicationIconImageForBundleIdentifier:bundleId format:0];
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
      self = %orig;
      prefs = [NSDictionary dictionaryWithContentsOfFile:@"/User/Library/Preferences/com.sticktron.croutons.plist"]; //this doesnt get called too often, so its possible that checking here wont hurt
      HBLogDebug(@"prefs %@", prefs);
      if (self && [prefs[@"enable"] boolValue]) {

           self.appIconView = [[%c(UIImageView) alloc] init];
           self.appIconView.layer.masksToBounds = YES;
           self.appIconView.layer.cornerRadius = 3;

           self.appIconView.image = self.appIconImage;

           [self addSubview:self.appIconView];
           appIconWatcher = self.appIconView;
      }
   return self;
}

- (void)layoutSubviews {
    %orig;
    if ([prefs[@"enable"] boolValue]) {
    CGRect frame = (CGRect){ {self.imageView.frame.origin.x + self.imageView.frame.size.width + 4, 0}, {self.bounds.size.height, self.bounds.size.height} }; //programaticcaly determines + padding, just cus
    self.appIconView.frame = frame;}
}
%end



#pragma mark - Breadcrumb Item View --------------------------------------------

%hook UIStatusBarBreadcrumbItemView

- (void)setTitle:(id)arg1 {
    [prefs[@"enable"] boolValue] ? %orig(@"") : %orig;
}

- (float)updateContentsAndWidth {
	float r = %orig;
      if ([prefs[@"enable"] boolValue]){
         self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width*2, self.frame.size.height);
         self.clipsToBounds = YES;
      }
    //tada, so this worked for the last double sided breadcrumb i encountered, but they were both for the same app so im not really sure
    //to me, it might make sense that since there's two breadcrumbs it doesnt even matter because they're both seperate objects with seperate .systemNavActions so it grabs the right bundle
    //anyways, its weird that there's a method for multiple ones when there doesnt seem to be any use of it , maybe worth looking into!
    NSString * targetBundle = [self.systemNavigationAction bundleIdForDestination:0];
    HBLogWarn(@"targetBundle %@", targetBundle);
    if ([prefs[@"enable"] boolValue]){
      if ([targetBundle isEqualToString:@"com.apple.springboard.spotlight-placeholder"]) {
         if (appIconWatcher && !appIconWatcher.image) appIconWatcher.image = [%c(UIImage) imageNamed:@"UITabBarSearch" inBundle:[NSBundle bundleWithPath:@"/Applications/Bridge.app/"]];
      }
      else if (targetBundle){
         if (appIconWatcher && !appIconWatcher.image) appIconWatcher.image = appIconForBundleIdentifier(targetBundle);
      }
   }
   else appIconWatcher.image = nil;
   //}
   return r;
}



%end

%ctor {
	@autoreleasepool {
		NSLog(@"Croutons, by Sticktron.");
		//loadPreferences();
      %init;
      prefs = [NSDictionary dictionaryWithContentsOfFile:@"/User/Library/Preferences/com.sticktron.croutons.plist"];
      if (!prefs) prefs = [[NSMutableDictionary alloc] init];;
      HBLogDebug(@"prefs %@", prefs);


      //@TODO filter out some things ??
	}
}
