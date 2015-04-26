
#import "InterfaceController.h"

#define FACE_ITEM_COUNT	8	// Watch画面に表示する選択肢の数

@interface InterfaceController() {
	
	NSArray* selectItem;	// 選択肢
	NSArray* buttons;		// ボタンオブジェクト
}

@property (weak, nonatomic) IBOutlet WKInterfaceButton *button000;
@property (weak, nonatomic) IBOutlet WKInterfaceButton *button001;
@property (weak, nonatomic) IBOutlet WKInterfaceButton *button002;
@property (weak, nonatomic) IBOutlet WKInterfaceButton *button003;
@property (weak, nonatomic) IBOutlet WKInterfaceButton *button004;
@property (weak, nonatomic) IBOutlet WKInterfaceButton *button005;
@property (weak, nonatomic) IBOutlet WKInterfaceButton *button006;
@property (weak, nonatomic) IBOutlet WKInterfaceButton *button007;
@property (weak, nonatomic) IBOutlet WKInterfaceButton *button008;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *infoLabel;
@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
	[super awakeWithContext:context];
	
	// Watch画面に配置したボタンオブジェクトの配列
	buttons = @[_button000, _button001, _button002,
				_button003, _button004, _button005,
				_button006, _button007, _button008,
				];
	
	// 記録する選択肢
	selectItem = @[	@"起床", @"就寝", @"食事",
					@"運動", @"読書", @"風呂",
					@"勉強", @"遊び", @"手伝",
					@"お酒", @"菓子", @"飲物"];
	
	// ８つ目のボタンまでは選択肢を設定する
	for(int i=0; i<FACE_ITEM_COUNT; i++) {
		[buttons[i] setTitle:selectItem[i]];
	}
	
	// ９つ目のボタンを押して、それ以降の選択肢を選択する
	[buttons[FACE_ITEM_COUNT] setTitle:@"他"];
}

- (void)willActivate {
	[super willActivate];
}

- (void)didDeactivate {
	[super didDeactivate];
}


#pragma mark - Button job

// 各ボタンが押された時の処理

- (IBAction)button000Pushed {
	[self sendEventToOwnerApp:selectItem[0]];
}

- (IBAction)button001Pushed {
	[self sendEventToOwnerApp:selectItem[1]];
}

- (IBAction)button002Pushed {
	[self sendEventToOwnerApp:selectItem[2]];
}

- (IBAction)button003Pushed {
	[self sendEventToOwnerApp:selectItem[3]];
}

- (IBAction)button004Pushed {
	[self sendEventToOwnerApp:selectItem[4]];
}

- (IBAction)button005Pushed {
	[self sendEventToOwnerApp:selectItem[5]];
}

- (IBAction)button006Pushed {
	[self sendEventToOwnerApp:selectItem[6]];
}

- (IBAction)button007Pushed {
	[self sendEventToOwnerApp:selectItem[7]];
}

- (IBAction)button008Pushed {
	
		// 画面に表示されていなかった選択肢（９番目〜）をotherSelection配列にまとめる
	NSMutableArray* otherSelection = [[NSMutableArray alloc] initWithCapacity:1];
	for(int i=FACE_ITEM_COUNT; i<selectItem.count; i++) {
		[otherSelection addObject:selectItem[i]];
	}
	
	[self presentTextInputControllerWithSuggestions:otherSelection
								   allowedInputMode:WKTextInputModePlain
										 completion:^(NSArray *results) {
											 if (results && results.count > 0) {
												 // 選択された、または音声入力されたNSString
												 NSString* result = [results objectAtIndex:0];
												 [self sendEventToOwnerApp:result];
											 }
											 else {
												 // 入力なし
											 }
										 }];
}


// オーナーiOSアプリに選択肢を伝達する
- (void)sendEventToOwnerApp:(NSString*)eventName {
	
	// 送信する情報（イベント名称）
	NSDictionary *requst = @{@"eventName":eventName};
	
	// iOSアプリへ情報を送信し、応答を受信する
	[InterfaceController openParentApplication:requst reply:^(NSDictionary *replyInfo, NSError *error) {
		
		if (error) {
			NSLog(@"%@", error);	// エラー時の処理
		}
		else {
			// iOSアプリからの応答をラベルに表示する
			[self.infoLabel setText:[replyInfo objectForKey:@"response"]];
		}
		
	}];
}

@end



