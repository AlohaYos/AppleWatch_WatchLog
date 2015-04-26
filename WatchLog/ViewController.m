
#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController () {
	AppDelegate*	appDelegate;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	// ログが更新された時の通知を登録
	appDelegate = [UIApplication sharedApplication].delegate;
	[appDelegate registerLifeLogAddNotificationTo:self selector:@selector(tableViewDataSourceChanged)];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return appDelegate.lifeLogData.count;	// 行数=ログの個数
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
	
	// 表示するログ内容を取得する
	NSDictionary *item  = [appDelegate.lifeLogData objectAtIndex:indexPath.row];
	NSDate *eventDate   = [item valueForKey:@"datetime"];
	NSString* eventName = [item valueForKey:@"eventName"];
	
	// イベントの発生時刻を文字列化
	NSDateFormatter *outputDateFormatter = [[NSDateFormatter alloc] init];
	NSString *outputDateFormatterStr = @"yyyy/MM/dd HH:mm:ss";
	[outputDateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"JST"]];
	[outputDateFormatter setDateFormat:outputDateFormatterStr];
	NSString *outputDateStr = [outputDateFormatter stringFromDate:eventDate];
	
	// セルに設定する
	cell.textLabel.text = eventName;
	cell.detailTextLabel.text = outputDateStr;
	
	return cell;
}

#pragma mark - Data changed (Notification)

// ログが更新された時の処理
- (void)tableViewDataSourceChanged {
	
	// データソースを読み直し
	[self.tableView reloadData];
	
	// TableViewの最終行を表示する
	long section = [self.tableView numberOfSections] - 1;
	long row = [self.tableView numberOfRowsInSection:section] - 1;
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
	[self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}


@end
