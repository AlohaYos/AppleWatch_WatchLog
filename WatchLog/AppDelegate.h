
#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow			*window;
@property (nonatomic, strong) NSMutableArray*	lifeLogData;	// ログデータを格納する配列

// イベントが追加された時の通知先を登録する
- (void)registerLifeLogAddNotificationTo:(id)target selector:(SEL)selector;

@end

