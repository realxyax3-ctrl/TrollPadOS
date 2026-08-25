#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

static NSString * const kTPOSDomain = @"com.trollpados";

static id TPOSValue(NSString *key) {
    return (__bridge_transfer id)CFPreferencesCopyAppValue((__bridge CFStringRef)key,
                                                            (__bridge CFStringRef)kTPOSDomain);
}

static BOOL TPOSBool(NSString *key, BOOL def) {
    id v = TPOSValue(key);
    return v ? [v boolValue] : def;
}

static NSInteger TPOSInt(NSString *key, NSInteger def) {
    id v = TPOSValue(key);
    return v ? [v integerValue] : def;
}

static BOOL TPOSEnabled(void) { return TPOSBool(@"TPOSEnable", YES); }
static BOOL TPOSWindowing(void) {
    return TPOSEnabled() && TPOSBool(@"TPOSWindowedApps", YES) && !TPOSBool(@"TPOSFullscreenAppsOnly", NO);
}
static BOOL TPOSStage(void) { return TPOSEnabled() && TPOSBool(@"TPOSStageManager", YES); }
static BOOL TPOSGlobalPadTraits(void) { return TPOSEnabled() && TPOSBool(@"TPOSGlobalPadTraits", NO); }
static BOOL TPOSLandscape(void) { return TPOSEnabled() && TPOSBool(@"TPOSAllowLandscapeHomeScreen", YES); }

// -----------------------------------------------------------------------------
// iPad-style trait compatibility for UIKit processes where the host actually
// exposes these public UIKit APIs. Kept behind an opt-in switch because forcing
// iPad traits globally can change third-party app layouts.
// -----------------------------------------------------------------------------
%group TPUIKitTraits
%hook UITraitCollection
- (UIUserInterfaceIdiom)userInterfaceIdiom {
    return TPOSGlobalPadTraits() ? UIUserInterfaceIdiomPad : %orig;
}
- (UIUserInterfaceSizeClass)horizontalSizeClass {
    return TPOSGlobalPadTraits() ? UIUserInterfaceSizeClassRegular : %orig;
}
%end
%end

// -----------------------------------------------------------------------------
// SpringBoard/iPadOS multitasking compatibility.
// -----------------------------------------------------------------------------
%group TPSpringBoard

%hook SBTraitsPipelineManager
- (BOOL)isDevicePad  {
    return TPOSEnabled() ? YES : %orig;
}
%end

%hook UIStatusBarWindow
- (UIUserInterfaceIdiom)idiom  {
    return TPOSEnabled() ? UIUserInterfaceIdiomPad : %orig;
}
%end

%hook SBMedusaConfigurationUsageMetric
- (BOOL)isMedusaCapable  {
    return TPOSWindowing() ? YES : %orig;
}
- (BOOL)isMedusaEnabled  {
    return TPOSWindowing() ? YES : %orig;
}
- (unsigned long long)medusaCapabilities  {
    return TPOSWindowing() ? ~0ULL : %orig;
}
%end

%hook SBAppSwitcherSettings
- (BOOL)isMedusaEnabled  {
    return TPOSWindowing() ? YES : %orig;
}
- (BOOL)isMedusaCapable  {
    return TPOSWindowing() ? YES : %orig;
}
- (unsigned long long)medusaCapabilities  {
    return TPOSWindowing() ? ~0ULL : %orig;
}
%end

%hook SBPlatformController
- (BOOL)isMedusaEnabled  {
    return TPOSWindowing() ? YES : %orig;
}
%end

%hook SBMainWorkspace
- (BOOL)forceEnableMedusaForLandscapeOnlyApps {
    return TPOSEnabled() && TPOSWindowing() && TPOSBool(@"TPOSForceMedusaLandscapeOnlyApps", NO);
}
%end

%hook SBSwitcherChamoisSettings
- (BOOL)chamoisEnabled  {
    return TPOSStage() ? YES : %orig;
}
- (BOOL)hasEverUsedChamois  {
    return TPOSStage() ? YES : %orig;
}
- (long long)maximumNumberOfAppsOnStage {
    NSInteger n = TPOSInt(@"TPOSMaxAppsOnStage", 4);
    n = MAX(1, MIN(8, n));
    return TPOSStage() ? n : %orig;
}
%end

%hook SBChamoisExternalDisplayController
- (BOOL)isEnabled {
    return TPOSStage() && TPOSBool(@"TPOSExternalDisplayStageManager", NO) ? YES : %orig;
}
%end

%hook SBChamoisHideDock
- (BOOL)isHidden  {
    return TPOSStage() ? TPOSBool(@"TPOSChamoisHideDock", NO) : %orig;
}
%end

// -----------------------------------------------------------------------------
// Requested merged "Quáº£n lÃ½ mÃ n hÃ¬nh" group.
// -----------------------------------------------------------------------------
%hook SBAppResizeGrabberView
- (void)setHidden:(BOOL)arg1 {
    if (TPOSEnabled() && TPOSBool(@"TPOSFullscreenAppsOnly", NO)) arg1 = YES;
    %orig(arg1);
}
- (instancetype)initWithFrame:(CGRect)frame {
    id r = %orig;
    if (TPOSEnabled() && TPOSBool(@"TPOSFullscreenAppsOnly", NO)) [r setHidden:YES];
    return r;
}
%end

%hook SBSwitcherChamoisLayoutAttributes
- (void)setAllowedTouchResizeCorners:(unsigned long long)corners {
    %orig((TPOSEnabled() && TPOSBool(@"TPOSFullscreenAppsOnly", NO)) ? 0ULL : corners);
}
%end

// -----------------------------------------------------------------------------
// External display / arrangement compatibility.
// -----------------------------------------------------------------------------
%hook SBExternalDisplayRuntimeAvailabilitySettings
- (BOOL)isAirPlayExternalDisplayAvailable {
    return TPOSEnabled() && TPOSBool(@"TPOSAirPlayExternalDisplay", NO) ? YES : %orig;
}
%end

%hook SBExternalDisplayController
- (BOOL)shouldUseExternalDisplay {
    return TPOSEnabled() && TPOSBool(@"TPOSExternalDisplayFullScreen", NO) ? YES : %orig;
}
%end

// -----------------------------------------------------------------------------
// Dock / Home Screen / app-switcher compatibility.
// -----------------------------------------------------------------------------
%hook SBHomeScreenViewController
- (BOOL)SBAppLibraryInDockEnabled {
    return TPOSEnabled() && TPOSBool(@"TPOSAppLibraryInDock", YES);
}
- (BOOL)_deviceSupportsEnhancedMultitasking  {
    return TPOSEnabled() ? YES : %orig;
}
%end

%hook SBDockView
- (BOOL)shouldShowRecents  {
    return TPOSEnabled() && TPOSBool(@"TPOSRecentsInDock", YES);
}
%end

%hook SBFloatingDockController
- (BOOL)isFloatingDockSupported  {
    return TPOSEnabled() && TPOSBool(@"TPOSFloatingDock", YES);
}
%end

%hook SBHomeGestureSettings
- (BOOL)homeScreenRotationEnabled  {
    return TPOSLandscape() ? YES : %orig;
}
- (long long)homeScreenRotationStyle  {
    return TPOSLandscape() ? 2LL : %orig;
}
%end

%hook SBCoverSheetPrimarySlidingViewController
- (BOOL)shouldRotateToInterfaceOrientation:(long long)o {
    return TPOSLandscape() ? YES : %orig;
}
%end

%hook SBFullScreenSwitcherLiveContentOverlayCoordinator
- (BOOL)usesiPadSwitcherStyle {
    return TPOSEnabled() && TPOSBool(@"TPOSIPadSwitcherAnimation", YES) ? YES : %orig;
}
%end

// -----------------------------------------------------------------------------
// Keyboard / input UI.
// -----------------------------------------------------------------------------
%hook UIKeyboardImpl
- (BOOL)showShortcutButtons {
    return TPOSEnabled() && TPOSBool(@"TPOSKeyboardShortcutButtons", YES);
}
%end

%hook UIKeyboardDockView
- (BOOL)shouldShowShortcutButtons {
    return TPOSEnabled() && TPOSBool(@"TPOSKeyboardShortcutButtons", YES);
}
- (UIUserInterfaceIdiom)idiom {
    return TPOSEnabled() && TPOSBool(@"TPOSSpoofIdiomKeyboard", YES)
        ? UIUserInterfaceIdiomPad : %orig;
}
%end

%hook UISystemInputAssistantViewController
- (BOOL)showsShortcutButtons {
    return TPOSEnabled() && TPOSBool(@"TPOSKeyboardShortcutButtons", YES);
}
%end

%end // TPSpringBoard

// -----------------------------------------------------------------------------
// iPadOS-style Picture in Picture compatibility when the AVKit class is present.
// This enables the capability advertisement only; actual PiP still depends on
// the host app and OS entitlement/support.
// -----------------------------------------------------------------------------
%group TPAVKit
%hook AVPictureInPictureController
+ (BOOL)isPictureInPictureSupported {
    return TPOSEnabled() && TPOSBool(@"TPOSPictureInPicture", NO) ? YES : %orig;
}
%end
%end // TPAVKit

%ctor {
    if (objc_getClass("UITraitCollection")) {
        %init(TPUIKitTraits);
    }

    if (objc_getClass("SBApplication") || objc_getClass("SBMainWorkspace") || objc_getClass("SBTraitsPipelineManager")) {
        %init(TPSpringBoard);
    }

    if (objc_getClass("AVPictureInPictureController")) {
        %init(TPAVKit);
    }
}
