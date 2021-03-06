/*******************************************************************************************************************
 *                                     ScummVMwrapper :: svwlauncher                                               *
 *******************************************************************************************************************
 * File:             SVWAppDelegate.m                                                                              *
 * Copyright:        (c) 2010-2012 dotalux.com; syao                                                               *
 *******************************************************************************************************************/

#import "SVWAppDelegate.h"

#pragma mark Constants
NSString * const kCFBundleDisplayName        = @"CFBundleDisplayName";
NSString * const kCFBundleName               = @"CFBundleName";
NSString * const kSVWFullScreen              = @"SVWFullScreen";
NSString * const kSVWAspectRatio             = @"SVWAspectRatio";
NSString * const kSVWGFXMode                 = @"SVWGFXMode";
NSString * const kSVWEnableSubtitles         = @"SVWEnableSubtitles";
NSString * const kSVWLanguage                = @"SVWLanguage";
NSString * const kSVWMusicVolume             = @"SVWMusicVolume";
NSString * const kSVWSFXVolume               = @"SVWSFXVolume";
NSString * const kSVWSpeechVolume            = @"SVWSpeechVolume";
NSString * const kSVWEngineType              = @"SVWEngineType";
NSString * const kSVWExtraArguments          = @"SVWExtraArguments";
NSString * const kSVWEnableSw3DRenderer      = @"SVWEnableSw3DRenderer";
NSString * const kSVWEnableFpsCounter        = @"SVWEnableFpsCounter";

NSString * const kSavesDir                   = @"%@/saves";
NSString * const kGameDir                    = @"%@/game";
NSString * const kThemeDir                   = @"%@/themes";
NSString * const kSavesPlaceholder           = @"%@/saves/.dontdeletethis";

NSString * const kScummVMExe                 = @"scummvm";
NSString * const kResidualVMExe              = @"residualvm";
NSString * const kConfigToolName             = @"ScummVMWrapperConfig.app";

NSUInteger const kEngineTypeScummVM          = 0;
NSUInteger const kEngineTypeResidualVM       = 1;

NSString * const kDefaultBundleNameV2        = @"scumm_w";
NSString * const kDefaultBundleNameV3        = @"svwlauncher";

NSString * const kApplicationSupportBaseDir  = @"SVWrapper";

@implementation SVWAppDelegate

#pragma mark -
#pragma mark Object creation, initialization, desctruction
- (id)init {
    self = [super init];
    NSLog(@"Init");
    if (self) {
        loaded = NO;
        engineType = kEngineTypeScummVM;
        gameID = [[NSString alloc] initWithString:@""];
        fullScreenMode = NO;
        aspectRatioCorrectionEnabled = NO;
        gfxMode = [[NSString alloc] initWithString:@""];
        subtitlesEnabled = YES;
        gameLanguage = [[NSString alloc] initWithString:@""];
        musicVolume = 192;
        sfxVolume = 192;
        speechVolume = 192;
        extraArguments = [[NSString alloc] initWithString:@""];
        sw3DRenderer = NO;
        fpsCounterEnabled = NO;
    }
    return self;
}

- (void)dealloc {
    [gameID release];
    [gameLanguage release];
    [extraArguments release];
    [gfxMode release];

    [super dealloc];
}

- (void)applicationWillFinishLaunching:(NSNotification *)aNotification {
#pragma unused (aNotification)
    NSLog(@"Will Finish Launching");
    [self setConfigRun:NO];
    [self setConfigToolFound:NO];

    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    NSFileManager *fm = [NSFileManager defaultManager];

    // App bundle sanity check
    if (![bundlePath hasSuffix:@".app"]
        || ![fm fileExistsAtPath:[bundlePath stringByAppendingPathComponent:@"Contents/MacOS"]]) {
        NSLog(@"This application must be run from an Application Bundle.  Aborting.");
        [NSApp terminate:self]; // TODO: Check if it works
    }

    if ([fm fileExistsAtPath:[bundlePath stringByAppendingPathComponent:@"ScummVMWrapperConfig.app"]])
        [self setConfigToolFound:YES];

    if ([self isConfigToolFound]) {
        CGEventRef event = CGEventCreate(NULL);
        CGEventFlags modifiers = CGEventGetFlags(event);
        CFRelease(event);
        if ((modifiers&kCGEventFlagMaskAlternate) == kCGEventFlagMaskAlternate
            || (modifiers&kCGEventFlagMaskSecondaryFn) == kCGEventFlagMaskSecondaryFn) {
            [self setConfigRun:YES];
        }
    }
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
#pragma unused (aNotification)
    NSLog(@"Did Finish Launching"); // FIXME: Remove
    if ([self isConfigRun]) {
        [self runConfig];
        [NSApp terminate:self];
    }
    
    [self loadData];
    
    if (![self isLoaded]) {
        NSLog(@"Unable to load settings.  Aborting.");
        [self runConfig];
        [NSApp terminate:self];
    }
    
    NSMutableArray *args = [NSMutableArray array];
    
    [args addObject:[NSString stringWithFormat:@"--savepath=%@",
                     [NSString stringWithFormat:kSavesDir, [[NSBundle mainBundle] resourcePath]]]];
    [args addObject:[NSString stringWithFormat:@"--themepath=%@",
                     [NSString stringWithFormat:kThemeDir, [[NSBundle mainBundle] resourcePath]]]];
    [args addObject:[NSString stringWithFormat:@"--path=%@",
                     [NSString stringWithFormat:kGameDir, [[NSBundle mainBundle] resourcePath]]]];
    
    if ([self isFullScreenMode])
        [args addObject:@"--fullscreen"];
    else
        [args addObject:@"--no-fullscreen"];

    if ([self gameLanguage] != nil && [[self gameLanguage] length] > 0)
        [args addObject:[@"--language=" stringByAppendingString:[self gameLanguage]]];
    
    if ([self isSubtitlesEnabled])
        [args addObject:@"--subtitles"];
    else
        [args addObject:@"--no-subtitles"];

    NSString *engineExe = nil;
    NSUInteger range = 255;
    switch ([self engineType]) {
        case kEngineTypeScummVM:
            engineExe = kScummVMExe;
            if ([self isAspectRatioCorrectionEnabled])
                [args addObject:@"--aspect-ratio"];
            if ([self gfxMode] != nil && [[self gfxMode] length] > 0)
                [args addObject:[@"--gfx-mode=" stringByAppendingString:[self gfxMode]]];
            break;
        case kEngineTypeResidualVM:
            engineExe = kResidualVMExe;
            if ([self isFpsCounterEnabled])
                [args addObject:@"--show-fps"];
            else
                [args addObject:@"--no-show-fps"];
            if ([self isSw3DRenderer])
                [args addObject:@"--soft-renderer"];
            else
                [args addObject:@"--no-soft-renderer"];
            break;
    }
    
    if ([self musicVolume] <= range)
        [args addObject:[NSString stringWithFormat:@"--music-volume=%lu", (unsigned long)[self musicVolume]]];
    
    if ([self sfxVolume] <= range)
        [args addObject:[NSString stringWithFormat:@"--sfx-volume=%lu", (unsigned long)[self sfxVolume]]];
    
    if ([self speechVolume] <= range)
        [args addObject:[NSString stringWithFormat:@"--speech-volume=%lu", (unsigned long)[self speechVolume]]];
    
    engineExe = [[NSBundle mainBundle] pathForAuxiliaryExecutable:engineExe];
    if (engineExe == nil) {
        NSLog(@"Can't find engine.  Aborting.");
        [self runConfig];
        [NSApp terminate:self];
    }
    
    if ([self extraArguments] != nil && [[self extraArguments] length] > 0)
        [args addObjectsFromArray:[[self extraArguments] componentsSeparatedByString:@" "]];
    
    [args addObject:[self gameID]];
    
    NSLog(@"ScummvmWrapper: Starting %@", [self gameID]);
    
    // Run Engine
    NSTask *engineTask = [[NSTask alloc] init];
    [engineTask setArguments:args];
//  [engineTask setCurrentDirectoryPath:nil];
//  [engineTask setEnvironment:nil];
    [engineTask setLaunchPath:engineExe];
    [engineTask launch];
    [engineTask waitUntilExit];
    int status = [engineTask terminationStatus];
    
    if (status == 0)
        NSLog(@"ScummvmWrapper: Finished %@", [self gameID]);
    else
        NSLog(@"ScummvmWrapper: Aborted %@", [self gameID]);
    [engineTask release];

    [NSApp terminate: nil];
}

- (BOOL)runConfig {
    if (![self isConfigToolFound])
        return NO;
    return [[NSWorkspace sharedWorkspace] openFile:[[[NSBundle mainBundle] bundlePath]
                                                    stringByAppendingPathComponent:kConfigToolName]];
}

#pragma mark Load
- (BOOL)loadData {
    NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:[[[[NSBundle mainBundle] bundlePath]
                                                                       stringByAppendingPathComponent:@"Contents"]
                                                                      stringByAppendingPathComponent:@"Info.plist"]];
    NSFileManager *fm = [NSFileManager defaultManager];
    
    [self resetDefaultValues];
    
    if (prefs != nil && [prefs objectForKey:kCFBundleName] != nil) {
        id readObj;
        if ((readObj=[prefs objectForKey:kSVWEngineType]) != nil)
            [self setEngineType:[readObj unsignedIntegerValue]];
        if ((readObj=[prefs objectForKey:kCFBundleName]) != nil) {
            if ([readObj isEqualToString:kDefaultBundleNameV2] || [readObj isEqualToString:kDefaultBundleNameV3]) {
                [self setLoaded:NO];
                return [self isLoaded];
            }
            [self setGameID:readObj];
        }
        if ((readObj=[prefs objectForKey:kSVWFullScreen]) != nil)
            [self setFullScreenMode:[readObj boolValue]];
        if ((readObj=[prefs objectForKey:kSVWAspectRatio]) != nil)
            [self setAspectRatioCorrectionEnabled:[readObj boolValue]];
        if ((readObj=[prefs objectForKey:kSVWGFXMode]) != nil)
            [self setGfxMode:readObj];
        if ((readObj=[prefs objectForKey:kSVWEnableSubtitles]) != nil)
            [self setSubtitlesEnabled:[readObj boolValue]];
        if ((readObj=[prefs objectForKey:kSVWLanguage]) != nil)
            [self setGameLanguage:readObj];
        if ((readObj=[prefs objectForKey:kSVWMusicVolume]) != nil)
            [self setMusicVolume:[readObj unsignedIntegerValue]];
        if ((readObj=[prefs objectForKey:kSVWSFXVolume]) != nil)
            [self setSfxVolume:[readObj unsignedIntegerValue]];
        if ((readObj=[prefs objectForKey:kSVWSpeechVolume]) != nil)
            [self setSpeechVolume:[readObj unsignedIntegerValue]];
        if ((readObj=[prefs objectForKey:kSVWExtraArguments]) != nil)
            [self setExtraArguments:readObj];
        if ((readObj=[prefs objectForKey:kSVWEnableSw3DRenderer]) != nil)
            [self setSw3DRenderer:[readObj boolValue]];
        if ((readObj=[prefs objectForKey:kSVWEnableFpsCounter]) != nil)
            [self setFpsCounterEnabled:[readObj boolValue]];
    } else {
        [self setLoaded:NO];
        return [self isLoaded];
    }

    if ((![fm fileExistsAtPath:[NSString stringWithFormat:kSavesPlaceholder, [[NSBundle mainBundle] resourcePath]]])) {
        [fm removeItemAtPath:[NSString stringWithFormat:kSavesDir, [[NSBundle mainBundle] resourcePath]] error:nil];
        NSString *librarySavePath = [self findOrCreateDirectory:NSApplicationSupportDirectory inDomain:NSUserDomainMask
                                           appendPathComponent:[self gameID] error:nil];
        [fm createSymbolicLinkAtPath:[NSString stringWithFormat:kSavesDir, [[NSBundle mainBundle] resourcePath]]
                 withDestinationPath:librarySavePath error:nil];
    }

    [self setLoaded:YES];
    return [self isLoaded];
}

#pragma mark Setters and Getters
- (void)resetDefaultValues {
    [self setLoaded:NO];
    [self setEngineType:kEngineTypeScummVM];
    [self setGameID:@""];
    [self setFullScreenMode:NO];
    [self setAspectRatioCorrectionEnabled:NO];
    [self setGfxMode:@""];
    [self setSubtitlesEnabled:YES];
    [self setGameLanguage:@""];
    [self setMusicVolume:192];
    [self setSfxVolume:192];
    [self setSpeechVolume:192];
    [self setSw3DRenderer:NO];
    [self setFpsCounterEnabled:NO];
    [self setExtraArguments:@""];
}

- (NSString *)findOrCreateDirectory:(NSSearchPathDirectory)searchPathDirectory
                           inDomain:(NSSearchPathDomainMask)domainMask appendPathComponent:(NSString *)appendComponent
                              error:(NSError **)errorOut {
    NSArray* paths = NSSearchPathForDirectoriesInDomains(searchPathDirectory, domainMask, YES);
    
    if ([paths count] == 0) {
        if (errorOut) {
            //NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
            //                          NSLocalizedStringFromTable(@"No path found for directory in domain.",
            //                                                     @"Errors", nil),
            //                          NSLocalizedDescriptionKey,
            //                          [NSNumber numberWithInteger:searchPathDirectory],
            //                          @"NSSearchPathDirectory",
            //                          [NSNumber numberWithInteger:domainMask],
            //                          @"NSSearchPathDomainMask",
            //                          nil];
            *errorOut = nil; // FIXME
            //*errorOut = [NSError errorWithDomain:myDomain code:myCode userInfo:userInfo];
        }
        return nil;
    }
    
    // Normally only need the first path
    NSString *resolvedPath = [paths objectAtIndex:0];
    
    if (appendComponent) {
        resolvedPath = [[resolvedPath stringByAppendingPathComponent:kApplicationSupportBaseDir]
                        stringByAppendingPathComponent:appendComponent];
    }
    
    // Create the path if it doesn't exist
    NSError *error;
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL success = [fm createDirectoryAtPath:resolvedPath withIntermediateDirectories:YES attributes:nil error:&error];
    if (!success) {
        if (errorOut) {
            *errorOut = error;
        }
        return nil;
    }

    // If we've made it this far, we have a success
    if (errorOut) {
        *errorOut = nil;
    }
    return resolvedPath;
}

#pragma mark -
#pragma mark Properties
@synthesize configRun;
@synthesize configToolFound;

@synthesize loaded;
@synthesize engineType;

#pragma mark Common
@synthesize gameID;
@synthesize fullScreenMode;
@synthesize gameLanguage;
@synthesize subtitlesEnabled;
@synthesize extraArguments;
@synthesize musicVolume;
@synthesize sfxVolume;
@synthesize speechVolume;

#pragma mark ScummVM
@synthesize aspectRatioCorrectionEnabled;
@synthesize gfxMode;

#pragma mark ResidualVM
@synthesize sw3DRenderer;
@synthesize fpsCounterEnabled;

@end

