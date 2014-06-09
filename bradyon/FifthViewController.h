//
//  FifthViewController.h
//  bradyon
//
//  Created by 羽野 真悟 on 12/10/21.
//  Copyright (c) 2012年 羽野 真悟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuggestTableView.h"
#import "DDSocialDialog.h"

@interface FifthViewController : UIViewController <UIWebViewDelegate,UITextFieldDelegate,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,DDSocialDialogDelegate>
{
    UIWebView *webView;             // インターネット表示用ウェブビュー
    UIWebView *webView2;            // 2画面目のウェブビュー
    UITextField *textField;         // タブタイトル、URL入力用テキストフィールド
    UIView *menuView;               // メニュー画面用のビュー
    BButton *twoButton1;           // 2画面目の選択ボタン
    BButton *twoButton2;           // 2画面目の選択ボタン
    BButton *twoButton3;           // 2画面目の選択ボタン
    BButton *twoButton4;           // 2画面目の選択ボタン
    UIToolbar *toolBar2;            // 2画面目のタッチパッド用ツールバー
    
    NSString *urlString;            // タブホームURL文字列
    NSURL *url;                     // URLリクエスト用
    NSString *titleString;          // タブタイトル文字列
    NSString *urlString2;           // タブホームURL文字列
    NSString *titleString2;         // タブタイトル文字列
    NSString *urlString3;           // タブホームURL文字列
    NSString *titleString3;         // タブタイトル文字列
    NSString *urlString4;           // タブホームURL文字列
    NSString *titleString4;         // タブタイトル文字列
    NSString *urlString5;           // タブホームURL文字列
    NSString *titleString5;         // タブタイトル文字列
    NSInteger reloadTime;           // オートリロードの間隔
    NSString *textString;           // テキストフィールドに入力された文字列を一時的に格納
    NSInteger alertFlag;            // アラートビュー呼び出し分岐処理用変数
    NSInteger iFlag;                // iPhone4 or 5 判定フラグ
    NSDate *stDate;                 // 開始時刻
    NSDate *nowDate;                // 現在時刻
    NSTimer *timer;                 // タイム計測用変
    CGPoint _tBegan, _tEnded;       // タッチ座標取得
    
    SuggestTableView *suggestTableView;
	NSMutableArray *dataSouce;
	NSURLConnection *suggestConnection;
	NSMutableData *async_data;
	UISearchBar *searchBar;
    
    //DDSocialLoginDialog
    DDSocialDialog *blankDialog;
}

@property (nonatomic, retain) NSMutableArray *dataSouce;

@end