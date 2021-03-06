/*******************************************************************************************************************
 *                                     ScummVMwrapper :: SVWconfig                                                 *
 *******************************************************************************************************************
 * File:             SVWSettings.m                                                                                 *
 * Copyright:        (c) 2010-2012 dotalux.com; syao                                                               *
 *******************************************************************************************************************/

#import "SVWSettings.h"

#pragma mark Constants
NSString * const kCFBundleDisplayName        = @"CFBundleDisplayName";
NSString * const kCFBundleName               = @"CFBundleName";
NSString * const kCFBundleShortVersionString = @"CFBundleShortVersionString";
NSString * const kCFBundleIdentifier         = @"CFBundleIdentifier";
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

NSString * const kGameIcns                   = @"%@/game.icns";
NSString * const kOldIcns                    = @"%@/old.icns";
NSString * const kGameDir                    = @"%@/game";
NSString * const kSavesDir                   = @"%@/saves";
NSString * const kSavesPlaceholder           = @"%@/saves/.dontdeletethis";
NSString * const kScummVMIcon                = @"scummvm.icns";
NSString * const kResidualVMIcon             = @"residualvm.icns";

NSUInteger const kSaveGameLocationLibrary    = 1;
NSUInteger const kSaveGameLocationBundle     = 0;

NSString * const kEngineType                 = @"engineType";
NSUInteger const kEngineTypeScummVM          = 0;
NSUInteger const kEngineTypeResidualVM       = 1;

NSString * const kDefaultBundleNameV2        = @"scumm_w";
NSString * const kDefaultBundleNameV3        = @"svwlauncher";

#pragma mark Implementation
@implementation SVWSettings

#pragma mark -
#pragma mark Properties
@synthesize engineType;
@synthesize edited;
@synthesize allScummGameIDs;
@synthesize allResidualVMGameIDs;
@synthesize allGameIDs;
@synthesize allGFXModes;
@synthesize allGameLanguages;
@synthesize engineIcon;

#pragma mark Common
@synthesize gameName;
@synthesize gameID;
@synthesize saveGameLocation;
@synthesize saveGameLocationOriginal;
@synthesize saveGameLocationEdited;
@synthesize fullScreenMode;
@synthesize gameLanguage;
@synthesize gameIconPath;
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

#pragma mark -
#pragma mark Object creation, initialization, desctruction
- (id)init {
    self = [super init];
    edited = NO;
    engineIcon = [[NSImage imageNamed:@"scummvm.icns"] retain];
    allScummGameIDs = [[NSArray alloc] initWithObjects:
                       @"activity",             // Putt-Putt & Fatty Bear's Activity Pack
                       @"agi",                  // Sierra AGI game
                       @"airport",              // Let's Explore the Airport with Buzzy
                       @"arttime",              // Blue's Art Time Activities
                       @"atlantis",             // Indiana Jones and the Fate of Atlantis
                       @"balloon",              // Putt-Putt and Pep's Balloon-O-Rama
                       @"baseball",             // Backyard Baseball
                       @"baseball2001",         // Backyard Baseball 2001
                       @"Baseball2003",         // Backyard Baseball 2003
                       @"basketball",           // Backyard Basketball
                       @"Blues123Time",         // Blue's 123 Time Activities
                       @"BluesABCTime",         // Blue's ABC Time Activities
                       @"BluesBirthday",        // Blue's Birthday Adventure
                       @"BluesTreasureHunt",    // Blue's Treasure Hunt
                       @"bra",                  // The Big Red Adventure
                       @"brstorm",              // Bear Stormin'
                       @"catalog",              // Humongous Interactive Catalog
                       @"chase",                // SPY Fox in Cheese Chase
                       @"cine",                 // Cinematique evo.1 engine game
                       @"comi",                 // The Curse of Monkey Island
                       @"cruise",               // Cinematique evo.2 engine game
                       @"dig",                  // The Dig
                       @"dimp",                 // Demon in my Pocket
                       @"dog",                  // Putt-Putt and Pep's Dog on a Stick
                       @"draci",                // Draci Historie
                       @"drascula",             // Drascula: The Vampire Strikes Back
                       @"elvira1",              // Elvira - Mistress of the Dark
                       @"elvira2",              // Elvira II - The Jaws of Cerberus
                       @"farm",                 // Let's Explore the Farm with Buzzy
                       @"fbear",                // Fatty Bear's Birthday Surprise
                       @"fbpack",               // Fatty Bear's Fun Pack
                       @"feeble",               // The Feeble Files
                       @"football",             // Backyard Football
                       @"football2002",         // Backyard Football 2002
                       @"freddi",               // Freddi Fish 1: The Case of the Missing Kelp Seeds
                       @"freddi2",              // Freddi Fish 2: The Case of the Haunted Schoolhouse
                       @"freddi3",              // Freddi Fish 3: The Case of the Stolen Conch Shell
                       @"freddi4",              // Freddi Fish 4: The Case of the Hogfish Rustlers of Briny Gulch
                       @"freddicove",           // Freddi Fish 5: The Case of the Creature of Coral Cove
                       @"FreddisFunShop",       // Freddi Fish's One-Stop Fun Shop
                       @"ft",                   // Full Throttle
                       @"funpack",              // Putt-Putt's Fun Pack
                       @"gob",                  // Gob engine game
                       @"groovie",              // Groovie engine game
                       @"indy3",                // Indiana Jones and the Last Crusade
                       @"hugo1",                // Hugo 1: Hugo's House of Horrors
                       @"hugo2",                // Hugo 2: Whodunit?
                       @"hugo3",                // Hugo 3: Jungle of Doom
                       @"jumble",               // Jumble
                       @"jungle",               // Let's Explore the Jungle with Buzzy
                       @"kyra1",                // The Legend of Kyrandia
                       @"kyra2",                // The Legend of Kyrandia: The Hand of Fate
                       @"kyra3",                // The Legend of Kyrandia: Malcolm's Revenge
                       @"lol",                  // Lands of Lore: The Throne of Chaos
                       @"loom",                 // Loom
                       @"lost",                 // Pajama Sam's Lost & Found
                       @"lure",                 // Lure of the Temptress
                       @"made",                 // MADE engine game
                       @"maniac",               // Maniac Mansion
                       @"maze",                 // Freddi Fish and Luther's Maze Madness
                       @"mohawk",               // Mohawk Game
                       @"monkey",               // The Secret of Monkey Island
                       @"monkey2",              // Monkey Island 2: LeChuck's Revenge
                       @"moonbase",             // Moonbase Commander
                       @"mustard",              // SPY Fox in Hold the Mustard
                       @"nippon",               // Nippon Safes Inc.
                       @"pajama",               // Pajama Sam 1: No Need to Hide When It's Dark Outside
                       @"pajama2",              // Pajama Sam 2: Thunder and Lightning Aren't so Frightening
                       @"pajama3",              // Pajama Sam 3: You Are What You Eat From Your Head to Your Feet
                       @"parallaction",         // Parallaction engine game
                       @"pass",                 // Passport to Adventure
                       @"pjgames",              // Pajama Sam: Games to Play on Any Day
                       @"pn",                   // Personal Nightmare
                       @"puttcircus",           // Putt-Putt Joins the Circus
                       @"puttmoon",             // Putt-Putt Goes to the Moon
                       @"puttputt",             // Putt-Putt Joins the Parade
                       @"puttrace",             // Putt-Putt Enters the Race
                       @"PuttsFunShop",         // Putt-Putt's One-Stop Fun Shop
                       @"putttime",             // Putt-Putt Travels Through Time
                       @"puttzoo",              // Putt-Putt Saves the Zoo
                       @"puzzle",               // NoPatience
                       @"queen",                // Flight of the Amazon Queen
                       @"readtime",             // Blue's Reading Time Activities
                       @"saga",                 // SAGA Engine game
                       @"samnmax",              // Sam & Max Hit the Road
                       @"SamsFunShop",          // Pajama Sam's One-Stop Fun Shop
                       @"sci",                  // Sierra SCI Game
                       @"simon1",               // Simon the Sorcerer 1
                       @"simon2",               // Simon the Sorcerer 2
                       @"sky",                  // Beneath a Steel Sky
                       @"soccer",               // Backyard Soccer
                       @"Soccer2004",           // Backyard Soccer 2004
                       @"SoccerMLS",            // Backyard Soccer MLS Edition
                       @"socks",                // Pajama Sam's Sock Works
                       @"spyfox",               // SPY Fox 1: Dry Cereal
                       @"spyfox2",              // SPY Fox 2: Some Assembly Required
                       @"spyozon",              // SPY Fox 3: Operation Ozone
                       @"swampy",               // Swampy Adventures
                       @"sword1",               // Broken Sword: The Shadow of the Templars
                       @"sword1demo",           // Broken Sword: The Shadow of the Templars (Demo)
                       @"sword1mac",            // Broken Sword: The Shadow of the Templars (Mac)
                       @"sword1macdemo",        // Broken Sword: The Shadow of the Templars (Mac demo)
                       @"sword1psx",            // Broken Sword: The Shadow of the Templars (PlayStation)
                       @"sword1psxdemo",        // Broken Sword: The Shadow of the Templars (PlayStation demo)
                       @"sword2",               // Broken Sword II: The Smoking Mirror
                       @"sword2alt",            // Broken Sword II: The Smoking Mirror (alt)
                       @"sword2demo",           // Broken Sword II: The Smoking Mirror (Demo)
                       @"sword2psx",            // Broken Sword II: The Smoking Mirror (PlayStation)
                       @"sword2psxdemo",        // Broken Sword II: The Smoking Mirror (PlayStation/Demo)
                       @"teenagent",            // Teen Agent
                       @"tentacle",             // Day of the Tentacle
                       @"thinker1",             // Big Thinkers First Grade
                       @"thinkerk",             // Big Thinkers Kindergarten
                       @"tinsel",               // Tinsel engine game
                       @"toon",                 // Toonstruck
                       @"touche",               // Touche: The Adventures of the Fifth Musketeer
                       @"tsage",                // Tsunami TsAGE-based Game
                       @"tucker",               // Bud Tucker in Double Trouble
                       @"water",                // Freddi Fish and Luther's Water Worries
                       @"waxworks",             // Waxworks
                       @"zak",                  // Zak McKracken and the Alien Mindbenders
                       nil];
    
    allResidualVMGameIDs = [[NSArray alloc] initWithObjects:
                            @"grim",        // Grim Fandango
                            @"myst3",       // Myst III Exile
                            nil];
    allGameIDs = [allScummGameIDs retain];

    allGFXModes = [[NSArray alloc] initWithObjects:
                   @"1x",
                   @"2x",
                   @"3x",
                   @"2xsai",
                   @"super2xsai",
                   @"supereagle",
                   @"advmame2x",
                   @"advmame3x",
                   @"hq2x",
                   @"hq3x",
                   @"tv2x",
                   @"dotmatrix",
                   nil];
    allGameLanguages = [[NSArray alloc] initWithObjects:
                        @"en",
                        @"de",
                        @"fr",
                        @"it",
                        @"pt",
                        @"es",
                        @"jp",
                        @"zh",
                        @"kr",
                        @"se",
                        @"gb",
                        @"hb",
                        @"ru",
                        @"cz",
                        nil];
    if (self) {
        engineType = kEngineTypeScummVM;
        gameName = [[NSString alloc] initWithString:@""];
        gameID = [[NSString alloc] initWithString:@""];
        saveGameLocation = kSaveGameLocationLibrary;
        saveGameLocationOriginal = kSaveGameLocationLibrary;
        saveGameLocationEdited = NO;
        fullScreenMode = NO;
        aspectRatioCorrectionEnabled = NO;
        gfxMode = [[NSString alloc] initWithString:[allGFXModes objectAtIndex:1]];
        subtitlesEnabled = YES;
        gameLanguage = [[NSString alloc] initWithString:@""];
        musicVolume = 192;
        sfxVolume = 192;
        speechVolume = 192;
        gameIconPath = [[NSString alloc] initWithString:[[self class] defaultIconPath]];
        extraArguments = [[NSString alloc] initWithString:@""];
        sw3DRenderer = NO;
        fpsCounterEnabled = NO;

        [self loadData];
    }
    return self;
}

- (void)dealloc {
    [self saveData];

    [gameName release];
    [gameID release];
    [gfxMode release];
    [gameLanguage release];
    [gameIconPath release];
    [extraArguments release];

    [allGameIDs release];
    [allScummGameIDs release];
    [allResidualVMGameIDs release];
    [allGFXModes release];
    [allGameLanguages release];

    [super dealloc];
}

#pragma mark Load and Save
- (BOOL)loadData {
    NSBundle *wrapperBundle = [NSBundle bundleWithPath:[[[NSBundle mainBundle] bundlePath]
                                                        stringByDeletingLastPathComponent]];
//  if (![[wrapperBundle bundlePath] hasSuffix:@".app"])
//      return NO;

    NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:
                           [[[wrapperBundle bundlePath] stringByAppendingPathComponent:@"Contents"]
                            stringByAppendingPathComponent:@"Info.plist"]];
    NSFileManager *filemanager = [NSFileManager defaultManager];

    [self resetDefaultValues];

    if (prefs != nil && [prefs objectForKey:kCFBundleName] != nil) {
        id readObj;
        if ((readObj=[prefs objectForKey:kSVWEngineType]) != nil)
            [self setEngineType:[readObj unsignedIntegerValue]];
        if ((readObj=[prefs objectForKey:kCFBundleDisplayName]) != nil)
            [self setGameName:readObj];
        if ((readObj=[prefs objectForKey:kCFBundleName]) != nil) {
            if ([readObj isEqualToString:kDefaultBundleNameV2] || [readObj isEqualToString:kDefaultBundleNameV3])
                [self setGameID:@""];
            else
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
    }

    if (([filemanager fileExistsAtPath:[NSString stringWithFormat:kSavesPlaceholder, [wrapperBundle resourcePath]]]))
        [self setSaveGameLocation:kSaveGameLocationBundle];
    else
        [self setSaveGameLocation:kSaveGameLocationLibrary];
    [self setSaveGameLocationOriginal:[self saveGameLocation]];
    [self setSaveGameLocationEdited:NO];

    [self setGameIconPath:[NSString stringWithString:[[self class] defaultIconPath]]];
    [self setEdited:NO];
    return (prefs != nil && [prefs objectForKey:kCFBundleName] != nil);
}

- (void)saveData {
    NSBundle *wrapperBundle = [NSBundle bundleWithPath:[[[NSBundle mainBundle] bundlePath]
                                                        stringByDeletingLastPathComponent]];
    NSMutableDictionary *prefs = [NSMutableDictionary dictionaryWithContentsOfFile: 
                                  [[[wrapperBundle bundlePath] stringByAppendingPathComponent:@"Contents"]
                                   stringByAppendingPathComponent:@"Info.plist"]];
    if (prefs == nil) {
        prefs = [NSMutableDictionary dictionary];
    }

    NSFileManager *filemanager = [NSFileManager defaultManager];

    if ([self gameName] != nil && ![[self gameName] isEqualToString:@""])
        [prefs setObject:[NSString stringWithString:[self gameName]] forKey:kCFBundleDisplayName];
    else
        [prefs removeObjectForKey:kCFBundleDisplayName];
    
    NSString *safeGameID = [self gameID];
    if ([[safeGameID stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""])
        safeGameID = [NSString stringWithString:kDefaultBundleNameV3];
    [prefs setObject:safeGameID forKey:kCFBundleName];
    [prefs setObject:[NSString stringWithFormat:@"com.dotalux.scummwrapper.%@", safeGameID] forKey:kCFBundleIdentifier];

    [prefs setObject:[NSNumber numberWithBool:[self isFullScreenMode]] forKey:kSVWFullScreen];
    
    [prefs setObject:[NSNumber numberWithBool:[self isAspectRatioCorrectionEnabled]] forKey:kSVWAspectRatio];
    
    if ([self gfxMode] != nil && ![[self gfxMode] isEqualToString:@""])
        [prefs setObject:[NSString stringWithString:[self gfxMode]] forKey:kSVWGFXMode];
    else
        [prefs removeObjectForKey:kSVWGFXMode];

    [prefs setObject:[NSNumber numberWithBool:[self isSubtitlesEnabled]] forKey:kSVWEnableSubtitles];

    if ([self gameLanguage] != nil && ![[self gameLanguage] isEqualToString:@""])
        [prefs setObject:[NSString stringWithString:[self gameLanguage]] forKey:kSVWLanguage];
    else
        [prefs removeObjectForKey:kSVWLanguage];

    [prefs setObject:[NSNumber numberWithUnsignedInteger:[self musicVolume]] forKey:kSVWMusicVolume];
    [prefs setObject:[NSNumber numberWithUnsignedInteger:[self sfxVolume]] forKey:kSVWSFXVolume];
    [prefs setObject:[NSNumber numberWithUnsignedInteger:[self speechVolume]] forKey:kSVWSpeechVolume];

    [prefs setObject:[NSNumber numberWithUnsignedInteger:[self engineType]] forKey:kSVWEngineType];

    if ([self extraArguments] != nil && ![[self extraArguments] isEqualToString:@""])
        [prefs setObject:[NSString stringWithString:[self extraArguments]] forKey:kSVWExtraArguments];
    else
        [prefs removeObjectForKey:kSVWExtraArguments];

    [prefs setObject:[NSNumber numberWithBool:[self isSw3DRenderer]] forKey:kSVWEnableSw3DRenderer];
    [prefs setObject:[NSNumber numberWithBool:[self isFpsCounterEnabled]] forKey:kSVWEnableFpsCounter];

    if ([self saveGameLocation] == kSaveGameLocationLibrary) {
        // TODO: Optimize this by adding an utility function to get the saves or game path (also useful in AppController)
        [filemanager removeItemAtPath:[NSString stringWithFormat:kSavesDir, [wrapperBundle resourcePath]] error:nil];
    } else {
        if (![filemanager fileExistsAtPath:[NSString stringWithFormat:kSavesPlaceholder, [wrapperBundle
                                                                                          resourcePath]]]) {
            [filemanager removeItemAtPath:[NSString stringWithFormat:kSavesDir, [wrapperBundle resourcePath]]
                                    error:nil];
        }
        [filemanager createDirectoryAtPath:[NSString stringWithFormat:kSavesDir, [wrapperBundle resourcePath]]
               withIntermediateDirectories:NO attributes:nil error:nil];
        [filemanager createFileAtPath:[NSString stringWithFormat:kSavesPlaceholder, [wrapperBundle resourcePath]]
                             contents:nil attributes:nil];
    }

    [prefs writeToFile:[[[wrapperBundle bundlePath] stringByAppendingPathComponent:@"Contents"] 
                        stringByAppendingPathComponent:@"Info.plist"] atomically: YES];

    if (![[self gameIconPath] isEqualToString:[[self class] defaultIconPath]]) {
        [filemanager removeItemAtPath:[NSString stringWithFormat:kOldIcns, [wrapperBundle resourcePath]] error:nil];
        [filemanager moveItemAtPath:[[self class] defaultIconPath] toPath:[NSString stringWithFormat:kOldIcns,
                                                                           [wrapperBundle resourcePath]] error:nil];
        [filemanager copyItemAtPath:[self gameIconPath] toPath:[[self class] defaultIconPath] error:nil];
    }
    [[NSApp mainWindow] setDocumentEdited:NO];
}

#pragma mark Setters and Getters
- (void)resetDefaultValues {
    [self setEngineType:kEngineTypeScummVM];
    [self setGameName:@""];
    [self setGameID:@""];
    [self setSaveGameLocation:kSaveGameLocationLibrary];
    [self setSaveGameLocationOriginal:kSaveGameLocationLibrary];
    [self setSaveGameLocationEdited:NO];
    [self setFullScreenMode:NO];
    [self setAspectRatioCorrectionEnabled:NO];
    [self setGfxMode:[NSString stringWithString:[[self allGFXModes] objectAtIndex:1]]];
    [self setSubtitlesEnabled:YES];
    [self setGameLanguage:@""];
    [self setMusicVolume:192];
    [self setSfxVolume:192];
    [self setSpeechVolume:192];
    [self setGameIconPath:[NSString stringWithString:[[self class] defaultIconPath]]];
    [self setSw3DRenderer:NO];
    [self setFpsCounterEnabled:NO];
    [self setExtraArguments:@""];
//  [self setEdited:NO];
}

- (void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:kEngineType]) {
        NSNumber *num = value;
        switch ([num integerValue]) {
            case kEngineTypeScummVM:
                [self setAllGameIDs:[self allScummGameIDs]];
                [self setEngineIcon:[NSImage imageNamed:kScummVMIcon]];
                break;
            case kEngineTypeResidualVM:
                [self setAllGameIDs:[self allResidualVMGameIDs]];
                [self setEngineIcon:[NSImage imageNamed:kResidualVMIcon]];
                break;
            default:
                break;
        }
    }
    if ([self valueForKey:key] == value)
        return;
    [super setValue:value forKey:key];
    [self setEdited:YES];
}

#pragma mark Class methods
+ (NSString *)defaultIconPath {
    return [NSString stringWithFormat:kGameIcns,
            [[NSBundle bundleWithPath:[[[NSBundle mainBundle] bundlePath] stringByDeletingLastPathComponent]]
             resourcePath]];
}

@end
