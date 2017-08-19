//
// Headers for Croutons.
//

@interface UIImage (Private)
+ (id)_applicationIconImageForBundleIdentifier:(id)arg1 format:(int)arg2;
+ (id)_applicationIconImageForBundleIdentifier:(id)arg1 format:(int)arg2 scale:(CGFloat)arg3;
+ (id)imageNamed:(id)arg1 inBundle:(id)arg2;
- (id)_applicationIconImageForFormat:(int)arg1 precomposed:(BOOL)arg2;
@end


@interface _UIStatusBarSystemNavigationItemButton : UIButton
+ (BOOL)_buttonTypeIsModernUI:(int)arg1;
- (CGRect)imageRectForContentRect:(CGRect)arg1;
- (BOOL)shouldLayoutImageOnRight;
- (CGRect)titleRectForContentRect:(CGRect)arg1;
- (UIImageView *)imageView;
- (UIImageView *)_imageView;
- (UILabel *)_titleView;
@end


@interface UISystemNavigationAction : NSObject
- (id)bundleIdForDestination:(int)arg1;
@end


@interface UIStatusBarForegroundStyleAttributes : NSObject
@property (nonatomic, readonly, retain) UIColor *tintColor;
@end

/* UIStatusBarSystemNavigationItemView > UIStatusBarBreadcrumbItemView */

@interface UIStatusBarItemView : UIView
@end

@interface UIStatusBarSystemNavigationItemView : UIStatusBarItemView
@property (nonatomic, retain) _UIStatusBarSystemNavigationItemButton *button;
@property (nonatomic) int currentLabelCompressionLevel;
@property (nonatomic) float maxWidth;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, readonly) UIStatusBarForegroundStyleAttributes *foregroundStyle;
- (id)initWithItem:(id)arg1 data:(id)arg2 actions:(int)arg3 style:(id)arg4;
- (CGSize)_buttonSize;
- (BOOL)_shouldLayoutImageOnRight;
- (float)addContentOverlap:(float)arg1;
- (float)extraLeftPadding;
- (float)extraRightPadding;
- (int)labelLineBreakMode;
- (BOOL)layoutImageOnTrailingEdge;
- (float)resetContentOverlap;
- (id)shortenedTitleWithCompressionLevel:(int)arg1;
- (float)updateContentsAndWidth;
- (void)userDidActivateButton:(id)arg1;
@end

@interface UIStatusBarBreadcrumbItemView : UIStatusBarSystemNavigationItemView
@property (nonatomic, retain) NSString *destinationText;
@property (nonatomic, retain) UISystemNavigationAction *systemNavigationAction;
@end

@interface UIStatusBarOpenInSafariItemView : UIStatusBarSystemNavigationItemView
@property (nonatomic, retain) NSString *destinationText;
@property (nonatomic, retain) UISystemNavigationAction *systemNavigationAction;
- (id)_displayStringFromURL:(id)arg1;
- (id)_nominalTitleWithDestinationText:(id)arg1;
- (BOOL)layoutImageOnTrailingEdge;
- (id)shortenedTitleWithCompressionLevel:(int)arg1;
- (BOOL)updateForNewData:(id)arg1 actions:(int)arg2;
- (void)userDidActivateButton:(id)arg1;
@end
