
@interface UIStatusBarItemView : UIView
// {
//     BOOL  _allowsUpdates;
//     float  _currentOverlap;
//     UIStatusBarForegroundStyleAttributes * _foregroundStyle;
//     struct CGContext { } * _imageContext;
//     float  _imageContextScale;
//     UIStatusBarItem * _item;
//     _UILegibilityImageSet * _lastGeneratedTextImage;
//     float  _lastGeneratedTextImageLetterSpacing;
//     NSString * _lastGeneratedTextImageText;
//     UIStatusBarLayoutManager * _layoutManager;
//     _UILegibilityView * _legibilityView;
//     BOOL  _visible;
// }
// @property (nonatomic) BOOL allowsUpdates;
// @property (nonatomic, readonly) UIStatusBarForegroundStyleAttributes *foregroundStyle;
// @property (nonatomic, readonly) UIStatusBarItem *item;
// @property (nonatomic) UIStatusBarLayoutManager *layoutManager;
// @property (getter=isVisible, nonatomic) BOOL visible;
+ (id)createViewForItem:(id)arg1 withData:(id)arg2 actions:(int)arg3 foregroundStyle:(id)arg4;
- (BOOL)_shouldAnimatePropertyWithKey:(id)arg1;
- (BOOL)_shouldReverseLayoutDirection;
- (float)addContentOverlap:(float)arg1;
- (float)adjustFrameToNewSize:(float)arg1;
- (BOOL)allowsUpdates;
- (BOOL)animatesDataChange;
- (void)beginDisablingRasterization;
- (void)beginImageContextWithMinimumWidth:(float)arg1;
- (id)cachedImageWithText:(id)arg1 truncatedWithEllipsesAtMaxWidth:(float)arg2 letterSpacing:(float)arg3;
- (void)clearCachedTextImage;
- (id)contentsImage;
- (float)currentLeftOverlap;
- (float)currentOverlap;
- (float)currentRightOverlap;
- (void)dealloc;
- (id)description;
- (void)endDisablingRasterization;
- (void)endImageContext;
- (float)extraLeftPadding;
- (float)extraRightPadding;
- (id)foregroundStyle;
- (id)imageFromImageContextClippedToWidth:(float)arg1;
- (id)imageWithShadowNamed:(id)arg1;
- (id)imageWithText:(id)arg1;
- (id)initWithItem:(id)arg1 data:(id)arg2 actions:(int)arg3 style:(id)arg4;
- (BOOL)isVisible;
- (id)item;
- (id)layoutManager;
- (float)legibilityStrength;
- (int)legibilityStyle;
- (float)maximumOverlap;
- (float)neededSizeForImageSet:(id)arg1;
- (void)performPendedActions;
- (float)resetContentOverlap;
- (void)setAllowsUpdates:(BOOL)arg1;
- (void)setContentMode:(int)arg1;
- (void)setCurrentOverlap:(float)arg1;
- (void)setLayerContentsImage:(id)arg1;
- (void)setLayoutManager:(id)arg1;
- (void)setPersistentAnimationsEnabled:(BOOL)arg1;
- (float)setStatusBarData:(id)arg1 actions:(int)arg2;
- (void)setVisible:(BOOL)arg1;
- (void)setVisible:(BOOL)arg1 frame:(CGRect)arg2 duration:(double)arg3;
- (void)setVisible:(BOOL)arg1 settingAlpha:(BOOL)arg2;
- (float)shadowPadding;
- (float)standardPadding;
- (int)textAlignment;
- (id)textFont;
- (int)textStyle;
- (float)updateContentsAndWidth;
- (BOOL)updateForNewData:(id)arg1 actions:(int)arg2;
- (void)willMoveToWindow:(id)arg1;
@end

@interface _UIStatusBarSystemNavigationItemButton : UIButton
+ (BOOL)_buttonTypeIsModernUI:(int)arg1;
- (CGRect)imageRectForContentRect:(CGRect)arg1;
- (BOOL)shouldLayoutImageOnRight;
- (CGRect)titleRectForContentRect:(CGRect)arg1;
//
- (UIImageView *)imageView;
- (UIImageView *)_imageView;
- (UILabel *)_titleView;
@end

@interface UIStatusBarSystemNavigationItemView : UIStatusBarItemView
// {
//     UIButton * _button;
//     int  _currentLabelCompressionLevel;
//     float  _maxWidth;
// }
@property (nonatomic, retain) _UIStatusBarSystemNavigationItemButton *button;
// @property (nonatomic) int currentLabelCompressionLevel;
// @property (nonatomic) float maxWidth;
// @property (nonatomic, retain) NSString *title;
- (CGSize)_buttonSize;
- (BOOL)_shouldLayoutImageOnRight;
- (float)addContentOverlap:(float)arg1;
// - (id)button;
- (int)currentLabelCompressionLevel;
- (float)extraLeftPadding;
- (float)extraRightPadding;
- (int)labelLineBreakMode;
- (BOOL)layoutImageOnTrailingEdge;
- (float)maxWidth;
- (float)resetContentOverlap;
// - (void)setButton:(id)arg1;
- (void)setCurrentLabelCompressionLevel:(int)arg1;
- (void)setMaxWidth:(float)arg1;
- (void)setTitle:(id)arg1;
- (id)shortenedTitleWithCompressionLevel:(int)arg1;
- (id)title;
- (float)updateContentsAndWidth;
- (void)userDidActivateButton:(id)arg1;
@end


@class UISystemNavigationAction;

@interface UIStatusBarBreadcrumbItemView : UIStatusBarSystemNavigationItemView {
    NSString * _destinationText;
    UISystemNavigationAction * _systemNavigationAction;
}
@property (nonatomic, retain) NSString *destinationText;
@property (nonatomic, retain) UISystemNavigationAction *systemNavigationAction;
- (NSString *)destinationText;
- (float)extraRightPadding;
- (int)labelLineBreakMode;
- (void)setDestinationText:(NSString *)arg1;
- (void)setSystemNavigationAction:(UISystemNavigationAction *)arg1;
- (id)shortenedTitleWithCompressionLevel:(int)arg1;
- (UISystemNavigationAction *)systemNavigationAction;
- (BOOL)updateForNewData:(id)arg1 actions:(int)arg2;
- (void)userDidActivateButton:(id)arg1;
@end

// @interface UIStatusBarNavigationItemView : UIStatusBarAppIconItemView
// - (id)_appBundleIdentifier;
// - (int)buttonType;
// @end

@interface UIImage (Private)
+ (id)_applicationIconImageForBundleIdentifier:(id)arg1 format:(int)arg2;
+ (id)_applicationIconImageForBundleIdentifier:(id)arg1 format:(int)arg2 scale:(float)arg3;
- (id)_applicationIconImageForFormat:(int)arg1 precomposed:(BOOL)arg2;
@end

@interface UISystemNavigationAction : NSObject
- (id)bundleIdForDestination:(int)arg1;
@end
