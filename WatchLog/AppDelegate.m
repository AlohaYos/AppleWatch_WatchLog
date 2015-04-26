
#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	
	// ログの準備
	_lifeLogData = [[NSMutableArray alloc] initWithCapacity:1];
	
	// 保存されているログを読み込む
	[self loadLifeLog];
	
	return YES;
}

#pragma mark - Communicate with WatchKit extension

// WatchKit extensionとの会話
- (void)application:(UIApplication *)application handleWatchKitExtensionRequest:(NSDictionary *)userInfo reply:(void (^)(NSDictionary *))reply{
	
	// AppleWatchからのリクエスト（=記録する文字列）を取得する
	NSString *requestStr = [userInfo objectForKey:@"eventName"];
	
	// ログを記録
	[self addLifeLogData:requestStr];
	
	// AppleWatchへ応答を返す
	NSDictionary *response;
	response = @{@"response" : [NSString stringWithFormat:@"%@を記録しました",requestStr]};
	reply(response);
}

#pragma mark - Life Log Job

// ログを追加する
-(void)addLifeLogData:(NSString*)eventName {
	
	// 記録するアイテムを作成（日付時刻、イベント名称）
	NSDictionary *event = @{	@"datetime"	:	[NSDate new],
								@"eventName":	eventName
								};
	
	// イベントを追加して、ファイルを上書き保存する
	[self.lifeLogData addObject:event];
	[self saveLifeLog];
	
	// イベントが追加されたことをViewControllerへ通知し、TableView内容を表示しなおす
	NSNotification *n =	[NSNotification notificationWithName:@"LifeLogAdded" object:self userInfo:nil];
	[[NSNotificationCenter defaultCenter] postNotification:n];
}

// ログファイルの名称
- (NSString*)lifeLogFileName {
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"LifeLogList.plist"];
	
	return path;
}

// 保存したログを読み込む
- (void)loadLifeLog {
	
	[self.lifeLogData removeAllObjects];
	[self.lifeLogData setArray:[NSArray arrayWithContentsOfFile:[self lifeLogFileName]]];
}

// ログを保存する
- (void)saveLifeLog {
	
	[self.lifeLogData writeToFile:[self lifeLogFileName] atomically:YES];
}

// イベントが追加された時の通知先を登録する
- (void)registerLifeLogAddNotificationTo:(id)target selector:(SEL)selector {
	
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc addObserver:target selector:selector name:@"LifeLogAdded" object:nil];
}

@end
