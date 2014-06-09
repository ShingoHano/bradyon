//
//  ThirdViewController.m
//  bradyon
//
//  Created by 羽野 真悟 on 12/10/21.
//  Copyright (c) 2012年 羽野 真悟. All rights reserved.
//

#import "ThirdViewController.h"
#import "DDXMLDocument.h"
#import "DDXMLElement.h"

@interface ThirdViewController ()

@end

@implementation ThirdViewController

@synthesize dataSouce;

/*******************************************************************
 関数名　　initWithNibName
 概要    UIViewControllerクラスの初期処理　他Viewからの画面遷移に必要
 引数	(NSString *)nibNameOrNil        :xib
 (NSBundle *)nibBundleOrNil      :Bundle
 戻り値	(id)initWithNibName             :xibの名前
 *******************************************************************/
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    [self loadData];                //辞書データロード
    self.title=titleString;         //タブタイトル設定
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //        self.title = NSLocalizedString(@"First", @"First");
        self.tabBarItem.image = [UIImage imageNamed:@"circle_green_16_ns.png"];
    }
    return self;
}

/*******************************************************************
 関数名　　viewWillAppear
 概要    viewが表示される直前に呼び出される
 引数	(BOOL)animated
 戻り値	なし
 *******************************************************************/
/*- (void)viewWillAppear:(BOOL)animated
 {
 [self loadData];                //辞書データロード
 self.title=titleString;         //タブタイトル設定
 }*/

/*******************************************************************
 関数名　　viewDidLoad
 概要		viewが呼び出された時の初期処理　各種変数の初期化など
 引数		なし
 戻り値	なし
 *******************************************************************/
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadData];                        //辞書データロード
    
    stDate=[NSDate date];                   //開始時刻
    alertFlag=0;                            //変数初期化
    url=[NSURL URLWithString:urlString];    //URL
    
    /*
     if(passString.length<4)
     {
     lock=0;
     }*/
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        // iPhone
        CGRect r = [[UIScreen mainScreen] bounds];
        if (r.size.height == 480)           //iPhone4
        {
            iFlag=0;
        }
        else                                //iPhone5
        {
            iFlag=1;
        }
    }
    
    CGRect frame = [[UIScreen mainScreen] applicationFrame];
    float w_width = self.view.frame.size.width;
    float w_height = frame.size.height-self.tabBarController.tabBar.frame.size.height+20;
    
    //UIToolbarの生成
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0,w_height-50, frame.size.width, 40)];
    toolBar.barStyle=UIBarStyleBlack;
    toolBar.tintColor=[UIColor blackColor];
    [self.view addSubview:toolBar];
    
    /*
     UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
     infoButton.frame=CGRectMake(5, 5, 30, 30);
     [infoButton addTarget:self action:@selector(infoView) forControlEvents:UIControlEventTouchUpInside];
     [toolBar addSubview:infoButton];*/
    
    //タッチパッドの生成
    UIView *touchView = [[UIView alloc] init];
    touchView.frame=CGRectMake(0, 0, frame.size.width, 50);
    UIImage *backgroundImage = [UIImage imageNamed:@"blue_wall3.png"];
    touchView.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
    [toolBar addSubview:touchView];
    
    //UIWebViewの生成
    webView = [[UIWebView alloc] init];
    webView.frame=CGRectMake(0, 0, w_width, w_height-50);
    
    //画面サイズの取得
    int screenW = [[UIScreen mainScreen] applicationFrame].size.width;
    int screenH = [[UIScreen mainScreen] applicationFrame].size.height;
    
    //iPadの場合
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        webView.frame=CGRectMake(0, 0,screenW, screenH-69);
    }

    webView.delegate = self;
    webView.scalesPageToFit = YES;
    webView.backgroundColor = [UIColor clearColor];
    webView.alpha=0.99;
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"wall2"]];
    [self.view addSubview:webView];
    
    [self goHome];                      //タブホームURL表示
    [self timeStart];                   //時間計測用メソッドをコール
}

/*******************************************************************
 関数名　　touchesBegan
 概要	 画面下部スクロール部フリック時の始点座標取得
 引数　　 (NSSet *)touches withEvent
 　　　　 (UIEvent *)event
 戻り値	なし
 *******************************************************************/
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch * touchBegan = [touches anyObject];
    _tBegan = [ touchBegan locationInView: self.view ];
}

/*******************************************************************
 関数名　　touchesEnded
 概要	 画面下部スクロール部フリック時の終点座標取得
 　　　　　上フリック操作時のアイテム補充処理
 引数　　 (NSSet *)touches withEvent
 　　　　 (UIEvent *)event
 戻り値	なし
 *******************************************************************/
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch * touchEnded = [touches anyObject];
    _tEnded = [ touchEnded locationInView: self.view ];
    
    NSInteger distanceHorizontal = ABS( _tEnded.x - _tBegan.x );
    NSInteger distanceVertical = ABS( _tEnded.y - _tBegan.y );
    
    int screenH = [[UIScreen mainScreen] applicationFrame].size.height;
    
    
    if([touchEnded tapCount]==2)                        //ダブルクリックで更新
    {
        if(webView2==nil)                               //1画面表示の場合
        {
            [self reloadWebView];
        }
        else                                            //2画面表示の場合
        {
            if(_tEnded.y>=screenH/2)                          //上段のタッチパッドの場合
            {
                [webView2 reload];
            }
            else                                        //下段のタッチパッドの場合
            {
                [self reloadWebView];
            }
        }
    }
    
    if(distanceHorizontal<10 && distanceVertical<10)    //タッチの誤差の範囲
    {
        return;
    }
    
    else if ( distanceHorizontal > distanceVertical )   //左右フリック
    {
        if ( _tEnded.x > _tBegan.x ) {                  //右フリック
            if(suggestTableView)
            {
                [menuView addSubview:suggestTableView];
                [menuView addSubview:searchBar];
                return;
            }
            
            if(webView2==nil)                           //1画面表示の場合
            {
                [self goFoward];
            }
            else                                        //2画面表示の場合
            {
                if(_tEnded.y>=screenH/2)                          //上段のタッチパッドの場合
                {
                    [webView2 goForward];
                }
                else                                    //下段のタッチパッドの場合
                {
                    [self goFoward];
                }
            }
        }
        else                                            //左フリック
        {
            if(suggestTableView)
            {
                [suggestTableView removeFromSuperview];
                [searchBar removeFromSuperview];
                return;
            }
            
            if(webView2==nil)                           //1画面表示の場合
            {
                [self goBack];
            }
            else                                        //2画面表示の場合
            {
                if(_tEnded.y>=screenH/2)                          //上段のタッチパッドの場合
                {
                    [webView2 goBack];
                }
                else                                    //下段のタッチパッドの場合
                {
                    [self goBack];
                }
            }
        }
    }
    else {                                              //上下フリック
        if ( _tEnded.y > _tBegan.y )                    //下フリック
        {
        }
        else
        {                                               //上フリック
            [self menuView];
        }
    }
}


/*******************************************************************
 関数名　　infoView
 概要	 タッチパッドの操作方法を表示する
 引数     なし
 戻り値    なし
 *******************************************************************/
/*-(void)infoView
 {
 // UIAlertViewの生成
 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"タッチパッドの操作説明"
 message:@" 上フリック　　： メニュー表示\n"
 " 左フリック　　： 戻る\n"
 " 右フリック　　： 進む\n"
 " ダブルクリック： 更新\n"
 delegate:self
 cancelButtonTitle:@"OK"
 otherButtonTitles: nil];
 [alertView show];
 
 //メッセージを左揃えにする
 ((UILabel *)[[alertView subviews] objectAtIndex:2]).textAlignment = NSTextAlignmentLeft;
 }*/

/*******************************************************************
 関数名　　lockView
 概要	 ロック状態であることを表示する
 引数     なし
 戻り値    なし
 *******************************************************************/
/*-(void)lockView
 {
 // UIAlertViewの生成
 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString( @"ロックされています",nil)
 message:NSLocalizedString(@"メニューの設定機能と検索機能はロックされています。\n",nil)
 delegate:self
 cancelButtonTitle:@"OK"
 otherButtonTitles: nil];
 [alertView show];
 }*/

/*******************************************************************
 関数名　　menuView
 概要	 メニューを表示する
 引数     なし
 戻り値    なし
 *******************************************************************/
-(void)menuView
{
    if(menuView)                                //メニュー画面表示中にコールされた場合
    {
        [menuView removeFromSuperview];         //メニュー画面を画面から削除する
        menuView=nil;
        searchBar=nil;
        suggestTableView=nil;
        return;
    }
    
    if(iFlag==0)                                //iPhone5
    {
        menuView=[[UIView alloc]initWithFrame:CGRectMake(0,0,320,391)];
    }
    else                                        //iPhone4
    {
        menuView=[[UIView alloc]initWithFrame:CGRectMake(0,0,320,479)];
    }
    //画面サイズの取得
    int screenW = [[UIScreen mainScreen] applicationFrame].size.width;
    int screenH = [[UIScreen mainScreen] applicationFrame].size.height;
    
    //iPadの場合
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        menuView.frame=CGRectMake(0, 0,screenW, screenH-69);
    }
    
    UIImage *backgroundImage = [UIImage imageNamed:@"wall2.png"];
    menuView.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
    [self.view addSubview:menuView];
    
    UIFont *bbFont=[UIFont fontWithName:@"Helvetica-Bold" size:14];
    
    
    BButton *Button1 = [[BButton alloc]init];
    [Button1 setType:6];
    Button1.titleLabel.font=bbFont;
    Button1.frame = CGRectMake(-10, 0, screenW+20,30);
    [Button1 setTitle:NSLocalizedString(@"Google検索",nil) forState:UIControlStateNormal];
    [Button1 addTarget:self action:@selector(goGoogle)
      forControlEvents:UIControlEventTouchUpInside];
    [menuView addSubview:Button1];
    
    BButton *Button2 = [[BButton alloc]init];
    [Button2 setType:0];
    Button2.titleLabel.font=bbFont;
    Button2.frame = CGRectMake(-10, 30, screenW+20, 30);
    [Button2 setTitle:NSLocalizedString(@"タブタイトル設定",nil) forState:UIControlStateNormal];
    [Button2 addTarget:self action:@selector(clickedButtonAtIndex0)
      forControlEvents:UIControlEventTouchUpInside];
    [menuView addSubview:Button2];
    
    BButton *Button3 = [[BButton alloc]init];
    [Button3 setType:6];
    Button3.titleLabel.font=bbFont;
    Button3.frame = CGRectMake(-10, 60, screenW+20, 30);
    [Button3 setTitle:NSLocalizedString(@"タブURL設定",nil) forState:UIControlStateNormal];
    [Button3 addTarget:self action:@selector(clickedButtonAtIndex1)
      forControlEvents:UIControlEventTouchUpInside];
    [menuView addSubview:Button3];
    
    BButton *Button4 = [[BButton alloc]init];
    [Button4 setType:0];
    Button4.titleLabel.font=bbFont;
    Button4.frame = CGRectMake(-10, 90, screenW+20, 30);
    [Button4 setTitle:NSLocalizedString(@"オートリロード設定",nil) forState:UIControlStateNormal];
    [Button4 addTarget:self action:@selector(clickedButtonAtIndex2)
      forControlEvents:UIControlEventTouchUpInside];
    [menuView addSubview:Button4];
    
    BButton *Button5 = [[BButton alloc]init];
    [Button5 setType:6];
    Button5.titleLabel.font=bbFont;
    Button5.frame = CGRectMake(-10, 120, screenW+20, 30);
    [Button5 setTitle:NSLocalizedString(@"タブホームへ移動",nil) forState:UIControlStateNormal];
    [Button5 addTarget:self action:@selector(goHome)
      forControlEvents:UIControlEventTouchUpInside];
    [menuView addSubview:Button5];
    
    BButton *button6 = [[BButton alloc]init];
    [button6 setType:0];
    button6.titleLabel.font=bbFont;
    button6.frame = CGRectMake(-10, 150, screenW+20, 30);
    [button6 setTitle:NSLocalizedString(@"2画面表示ON/OFF",nil) forState:UIControlStateNormal];
    [button6 addTarget:self action:@selector(twoDisplay)
      forControlEvents:UIControlEventTouchUpInside];
    [menuView addSubview:button6];
    
    //iPadの場合
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        Button1.frame=CGRectMake(-10, 0, screenW+20, 60);
        Button2.frame=CGRectMake(-10, 60, screenW+20, 60);
        Button3.frame=CGRectMake(-10, 120, screenW+20, 60);
        Button4.frame=CGRectMake(-10, 180, screenW+20, 60);
        Button5.frame=CGRectMake(-10, 240, screenW+20, 60);
        button6.frame=CGRectMake(-10, 300, screenW+20, 60);
    }
}

/*******************************************************************
 関数名　　passWordAlert
 概要	 パスワードの設定と解除を行う
 引数     なし
 戻り値    なし
 *******************************************************************/
/*-(void)passwordAlert
 {
 //ロックされていない時
 if(lock==0)
 {
 alertFlag=30;
 
 // UIAlertViewの生成
 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"パスワード設定",nil)
 message:NSLocalizedString(@"メニューの設定機能と検索機能をロックします。"
 "半角英数字4文字以上12文字以内で設定してください。\n\n\n",nil)
 delegate:self
 cancelButtonTitle:@"Cancel"
 otherButtonTitles:@"OK", nil];
 
 // UITextFieldの生成
 textField = [[UITextField alloc] initWithFrame:CGRectMake(12, 115, 260, 25)];
 textField.borderStyle = UITextBorderStyleRoundedRect;
 //    textField.textAlignment = UITextAlignmentLeft;
 textField.font = [UIFont fontWithName:@"Arial-BoldMT" size:18];
 textField.textColor = [UIColor grayColor];
 textField.minimumFontSize = 8;
 textField.adjustsFontSizeToFitWidth = YES;
 //    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
 textField.delegate = self;
 textField.text=@"";
 
 textField.keyboardType=UIKeyboardTypeNamePhonePad;
 
 // アラートビューにテキストフィールドを埋め込む
 [alertView addSubview:textField];
 //    [textField release];
 
 // アラート表示
 [alertView show];
 //    [alertView release];
 
 // テキストフィールドをファーストレスポンダに
 [textField becomeFirstResponder];
 }
 
 //ロックされている時
 else
 {
 alertFlag=40;
 
 // UIAlertViewの生成
 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"パスワード解除",nil)
 message:NSLocalizedString(@"メニューの設定機能と検索機能のロックを解除します。"
 "パスワードを入力してください\n\n\n",nil)
 delegate:self
 cancelButtonTitle:@"Cancel"
 otherButtonTitles:@"OK", nil];
 
 // UITextFieldの生成
 textField = [[UITextField alloc] initWithFrame:CGRectMake(12, 115, 260, 25)];
 textField.borderStyle = UITextBorderStyleRoundedRect;
 //    textField.textAlignment = UITextAlignmentLeft;
 textField.font = [UIFont fontWithName:@"Arial-BoldMT" size:18];
 textField.textColor = [UIColor grayColor];
 textField.minimumFontSize = 8;
 textField.adjustsFontSizeToFitWidth = YES;
 //    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
 textField.delegate = self;
 textField.text=@"";
 
 textField.keyboardType=UIKeyboardTypeNamePhonePad;
 
 // アラートビューにテキストフィールドを埋め込む
 [alertView addSubview:textField];
 //    [textField release];
 
 // アラート表示
 [alertView show];
 //    [alertView release];
 
 // テキストフィールドをファーストレスポンダに
 [textField becomeFirstResponder];
 }
 }*/


/*******************************************************************
 関数名　　willPresentAlertView
 概要	 アラート表示前に呼ばれる
 引数     なし
 戻り値    なし
 *******************************************************************/
/*- (void)willPresentAlertView:(UIAlertView *)alertView
 {
 // カスタムアラートの場合
 if (alertView.tag == 1)
 {
 // アラートの表示サイズを設定
 CGRect frame = [[UIScreen mainScreen] applicationFrame];
 CGRect alertFrame;
 alertFrame = CGRectMake(0, frame.size.height-140, 320,100);
 alertView.frame = alertFrame;
 
 // アラート上のオブジェクトの位置を修正(アラート表示サイズを変更すると位置がずれるため)
 for (UIView* view in alertView.subviews) {
 // ボタン
 if ([view isKindOfClass:NSClassFromString(@"UIThreePartButton")] ||     // iOS4用
 [view isKindOfClass:NSClassFromString(@"UIAlertButton")])           // iOS5用
 {
 // ボタンのサイズを設定
 view.frame = CGRectMake(0, 0, alertFrame.size.width-20, 30);
 
 // 「いいえ」ボタン
 //                if (uiButtonNum == 0)
 {
 view.center = CGPointMake(alertView.frame.size.width / 2.0, 70);
 }
 }
 }
 }
 }*/

/*******************************************************************
 関数名　　timeStart
 概要	時間計測開始諸処理
 引数	なし
 戻り値	なし
 *******************************************************************/
-(void)timeStart
{
    if(reloadTime>=1 && reloadTime<=10800)     //オートリロード機能が設定されている場合
    {
        timer = [NSTimer scheduledTimerWithTimeInterval:(1.0)
                                                 target:self
                                               selector:@selector(onTimer:)
                                               userInfo:nil
                                                repeats:YES];
    }
}

/*******************************************************************
 関数名　　onTimer
 概要	 時間計測処理
 引数　　 (NSTimer*)timerParameter
 戻り値	なし
 *******************************************************************/
-(void)onTimer:(NSTimer*)timerParameter {
    nowDate=[NSDate date];                                      //現在時刻を取得
    int timedif=[nowDate timeIntervalSinceDate:(stDate)];       //開始時刻との差分
    
    if(reloadTime==0)                                           //オートリロード機能オフ　0除算回避
    {
        return;
    }
    
    if(timedif%reloadTime==0)                                   //設定秒ごとに画面をウェブビューをリロード
    {
        [self reloadWebView];
    }
}

/*******************************************************************
 関数名　　twoDisplay
 概要	 2画面表示ON/OFF
 引数　　 なし
 戻り値	なし
 *******************************************************************/
- (void)twoDisplay
{
    CGRect webviewFrame=webView.frame;
    
    //画面サイズの取得
    int screenW = [[UIScreen mainScreen] applicationFrame].size.width;
    int screenH = [[UIScreen mainScreen] applicationFrame].size.height;
    
    if(webView.frame.size.height>=screenH/2)
    {
        webviewFrame.size.height=webviewFrame.size.height/2;            //ウェブビューのサイズを半分にする
        webView.frame=webviewFrame;
        
        //2画面目のUIWebViewの生成
        webView2 = [[UIWebView alloc] init];
        webView2.frame=CGRectMake(0, webviewFrame.size.height+30, 320, webviewFrame.size.height-30);
        
        //iPadの場合
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            webView2.frame=CGRectMake(0, webviewFrame.size.height+30,screenW, webviewFrame.size.height-30);
        }
        
        webView2.delegate = self;
        webView2.scalesPageToFit = YES;
        webView2.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"wall2"]];
        webView2.alpha=0.99;
        
        //メニュー用のビューを画面から削除する
        [menuView removeFromSuperview];
        menuView=nil;
        [self.view addSubview:webView2];
        
        [self loadData];                                                //他のタブのタイトルとURLを取得
        
        UIImage *buttonImage = [UIImage imageNamed:@"Default.png"];     //ボタンのデフォルトの色
        //        UIImage *hilightImage= [UIImage imageNamed:@"red_wall5.png"];   //ボタンをクリックした際の色
        
        BButtonType type=0;
        
        //タブ1つ目を表示するボタン
        twoButton1 = [[BButton alloc]init];
        [twoButton1 setType:type];
        twoButton1.frame = CGRectMake(screenW/2-130, 40, 120, 30);
        [twoButton1 setTitle:titleString2 forState:UIControlStateNormal];
        [twoButton1 addTarget:self action:@selector(goTab2)
             forControlEvents:UIControlEventTouchUpInside];
        [webView2 addSubview:twoButton1];
        
        //タブ2つ目を表示するボタン
        twoButton2 = [[BButton alloc]init];
        [twoButton2 setType:type];
        twoButton2.frame = CGRectMake(screenW/2+10, 40, 120, 30);
        [twoButton2 setTitle:titleString3 forState:UIControlStateNormal];
        [twoButton2 addTarget:self action:@selector(goTab3)
             forControlEvents:UIControlEventTouchUpInside];
        [webView2 addSubview:twoButton2];
        
        //タブ3つ目を表示するボタン
        twoButton3 = [[BButton alloc]init];
        [twoButton3 setType:type];
        twoButton3.frame = CGRectMake(screenW/2-130, 100, 120, 30);
        [twoButton3 setTitle:titleString4 forState:UIControlStateNormal];
        [twoButton3 addTarget:self action:@selector(goTab4)
             forControlEvents:UIControlEventTouchUpInside];
        [webView2 addSubview:twoButton3];
        
        //タブ4つ目を表示するボタン
        twoButton4 =[[BButton alloc]init];
        [twoButton4 setType:type];
        twoButton4.frame = CGRectMake(screenW/2+10, 100, 120, 30);
        [twoButton4 setTitle:titleString5 forState:UIControlStateNormal];
        [twoButton4 addTarget:self action:@selector(goTab5)
             forControlEvents:UIControlEventTouchUpInside];
        [webView2 addSubview:twoButton4];
        
        //iPadの場合
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            twoButton1.frame = CGRectMake(screenW/2-130, 100, 120, 60);
            twoButton2.frame = CGRectMake(screenW/2+10, 100, 120, 60);
            twoButton3.frame = CGRectMake(screenW/2-130, 220, 120, 60);
            twoButton4.frame = CGRectMake(screenW/2+10, 220, 120, 60);
        }
        
        //タッチパッド用のツールバー
        toolBar2 = [[UIToolbar alloc] initWithFrame:CGRectMake(0, webviewFrame.size.height, screenW, 30)];
        [toolBar2 setBackgroundImage:buttonImage forToolbarPosition:UIToolbarPositionTop barMetrics:UIBarMetricsDefault];
        toolBar2.backgroundColor=[UIColor colorWithPatternImage:buttonImage];
        
        //タッチパッドの生成
        UIView *touchView = [[UIView alloc] init];
        touchView.frame=CGRectMake(0, 0, screenW, 30);
        //    touchView.backgroundColor = [UIColor blackColor];
        UIImage *backgroundImage = [UIImage imageNamed:@"blue_wall3.png"];
        touchView.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
        //    [self.view addSubview:touchView];
        [toolBar2 addSubview:touchView];
        [self.view addSubview:toolBar2];
    }
    
    else
    {
        webviewFrame.size.height=webviewFrame.size.height*2;        //ウェブビューのサイズを元に戻す
        webView.frame=webviewFrame;
        [webView2 removeFromSuperview];                             //2画面目のウェブビューを画面から削除
        webView2=nil;
        [menuView removeFromSuperview];                             //メニュー用のビューを画面から削除
        menuView=nil;
        [toolBar2 removeFromSuperview];                             //2画面目のツールバーを画面から削除
        toolBar2=nil;
    }
}

/*******************************************************************
 関数名　　goTab2
 概要	 タブ1つ目を表示する処理
 引数　　 なし
 戻り値	なし
 *******************************************************************/
-(void)goTab2
{
    //タブ選択ボタンを画面から削除
    [twoButton1 removeFromSuperview];
    [twoButton2 removeFromSuperview];
    [twoButton3 removeFromSuperview];
    [twoButton4 removeFromSuperview];
    
    //1つ目のタブURLの内用を表示する
    NSURL *url2=[NSURL URLWithString:urlString2];
    NSURLRequest *req = [NSURLRequest requestWithURL:url2];
    [webView2 loadRequest:req];
}

/*******************************************************************
 関数名　　goTab3
 概要	 タブ2つ目を表示する処理
 引数　　 なし
 戻り値	なし
 *******************************************************************/
-(void)goTab3
{
    //タブ選択ボタンを画面から削除
    [twoButton1 removeFromSuperview];
    [twoButton2 removeFromSuperview];
    [twoButton3 removeFromSuperview];
    [twoButton4 removeFromSuperview];
    
    //2つ目のタブURLの内用を表示する
    NSURL *url2=[NSURL URLWithString:urlString3];
    NSURLRequest *req = [NSURLRequest requestWithURL:url2];
    [webView2 loadRequest:req];
}

/*******************************************************************
 関数名　　goTab4
 概要	 タブ3つ目を表示する処理
 引数　　 なし
 戻り値	なし
 *******************************************************************/
-(void)goTab4
{
    //タブ選択ボタンを画面から削除
    [twoButton1 removeFromSuperview];
    [twoButton2 removeFromSuperview];
    [twoButton3 removeFromSuperview];
    [twoButton4 removeFromSuperview];
    
    //3つ目のタブURLの内用を表示する
    NSURL *url2=[NSURL URLWithString:urlString4];
    NSURLRequest *req = [NSURLRequest requestWithURL:url2];
    [webView2 loadRequest:req];
}

/*******************************************************************
 関数名　 goTab5
 概要	タブ4つ目を表示する処理
 引数　　 なし
 戻り値	なし
 *******************************************************************/
-(void)goTab5
{
    //タブ選択ボタンを画面から削除
    [twoButton1 removeFromSuperview];
    [twoButton2 removeFromSuperview];
    [twoButton3 removeFromSuperview];
    [twoButton4 removeFromSuperview];
    
    //4つ目のタブURLの内用を表示する
    NSURL *url2=[NSURL URLWithString:urlString5];
    NSURLRequest *req = [NSURLRequest requestWithURL:url2];
    [webView2 loadRequest:req];
}

/*******************************************************************
 関数名  goGooGle
 概要	グーグルサイト表示
 引数	なし
 戻り値	なし
 *******************************************************************/
- (void)goGoogle {
    /*    if(lock==1)
     {
     [self lockView];
     return;
     }*/
    /*
     NSURL *googleUrl=[NSURL URLWithString:@"http://www.google.com"];
     NSURLRequest *req = [NSURLRequest requestWithURL:googleUrl];
     [webView loadRequest:req];
     
     //メニュー用のビューを画面から削除
     [menuView removeFromSuperview];
     menuView=nil;*/
    
    //画面サイズの取得
    int screenW = [[UIScreen mainScreen] applicationFrame].size.width;
    
    // サーチーバー生成
    searchBar = [[UISearchBar alloc] init];
    searchBar.delegate = self;
    searchBar.showsCancelButton = YES;
    searchBar.placeholder = NSLocalizedString(@"検索ワード",nil);
    searchBar.keyboardType = UIKeyboardTypeDefault;
    searchBar.frame = CGRectMake(0, 0,screenW, 50);
    searchBar.barStyle = UIBarStyleBlack;
    [menuView addSubview:searchBar];
    //[searchBar release];
    
    // テーブルビュー生成
    suggestTableView = [[SuggestTableView alloc] initWithFrame:CGRectMake(0, searchBar.frame.size.height, screenW, self.view.frame.size.height - 80) style:UITableViewStylePlain];
    suggestTableView.dataSource = self;
    suggestTableView.delegate = self;
    suggestTableView.touchSelector = @selector(touchToTableView:);
    suggestTableView.rowHeight = 40;
    suggestTableView.contentMode = UIViewContentModeScaleAspectFill;
    suggestTableView.clipsToBounds = YES;
    suggestTableView.delaysContentTouches = NO; // UIScrollViewのフリック判定の待ち時間を０にする
    [menuView addSubview:suggestTableView];
    //[suggestTableView release];
    
    // データソース初期化
    self.dataSouce = [[NSMutableArray alloc] init];
    
    [searchBar becomeFirstResponder];
}

- (void)reloadTableView {
	[suggestTableView reloadData];
}


//================
// デリゲート
//================

//--------------------------
// SuggestTableViewDelegate
//--------------------------

- (void)touchToTableView:(SuggestTableView *)_suggestTableView {
	[searchBar resignFirstResponder];
}

//---------------------
// UICearchBarDelegate
//---------------------

// 検索テキストボックス内に変更があったときに呼ばれる
- (void)searchBar:(UISearchBar *)_searchBar textDidChange:(NSString *)_searchText
{
	_searchText=[[_searchText stringByReplacingOccurrencesOfString:@" " withString:@"+"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    // テキストボックスに入力された内容で、URLを生成
	NSString *searchUrl = [[NSString alloc]initWithFormat:@"http://google.co.jp/complete/search?output=toolbar&q=%@&hl=jp",_searchText];
	
	// リクエスト
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:searchUrl]];
	// 既に通信中ならキャンセルする。
	if (suggestConnection != nil) {
		[suggestConnection cancel];
	}
	suggestConnection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
}

// 検索を押したときの処理
- (void)searchBarSearchButtonClicked:(UISearchBar *)activeSearchBar
{
    NSString *query = [[searchBar.text stringByReplacingOccurrencesOfString:@" " withString:@"+"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *requesturl = [NSURL URLWithString:
                         [NSString stringWithFormat:@"http://www.google.co.jp/search?q=%@&output=toolbar", query]];
    NSURLRequest *request = [NSURLRequest requestWithURL:requesturl];
    [webView loadRequest:request];
    [activeSearchBar resignFirstResponder];
    
    [menuView removeFromSuperview];
    menuView=nil;
    searchBar=nil;
    suggestTableView=nil;
}

// キャンセルボタンを押すと呼ばれる
-(void)searchBarCancelButtonClicked:(UISearchBar*)_searchBar {
	[_searchBar resignFirstResponder];
}

//--------------------------
// NSURLConnectionDelegate
//--------------------------

// ヘッダ受信
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
	// データを初期化
	async_data = [[NSMutableData alloc] initWithData:0];
	
}

// ダウンロード中
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
	// データを追加する
	[async_data appendData:data];
}

// エラー発生
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	//NSString *error_str = [error localizedDescription];
    //	[suggestConnection release];
	suggestConnection = nil;
    //	[async_data release];
}

// ダウンロード完了
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	
	DDXMLDocument *_doc = [[DDXMLDocument alloc] initWithData:async_data options:0 error:nil];
	DDXMLElement *_root = [_doc rootElement];
	NSArray *_titleArray = [_root nodesForXPath:@"/toplevel/CompleteSuggestion/suggestion/@data" error:nil ];
	
	[dataSouce removeAllObjects];
	for (int i = 0; i < [_titleArray count]; i++) {
        [self.dataSouce addObject:[[_titleArray objectAtIndex:i] stringValue]];
	}
	
    //	[suggestConnection release];
	suggestConnection = nil;
    //	[async_data release];
	
	[self reloadTableView];
}

//-------------------------
// TableViewDelegate
//-------------------------

- (NSString *) tableView:(UITableView *) tableView titleForHeaderInSection:(NSInteger) section {
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [dataSouce count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
	
	cell.textLabel.text = [dataSouce objectAtIndex:indexPath.row];
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	// セルの選択状態を解除する
    [suggestTableView deselectRowAtIndexPath:indexPath animated:YES];
	
    NSString *query =[dataSouce objectAtIndex:indexPath.row];
    query= [[query stringByReplacingOccurrencesOfString:@" " withString:@"+"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *requesturl = [NSURL URLWithString:
                         [NSString stringWithFormat:@"http://www.google.co.jp/search?q=%@&output=toolbar", query]];
    NSURLRequest *request = [NSURLRequest requestWithURL:requesturl];
    [webView loadRequest:request];
    //    [activeSearchBar resignFirstResponder];
    
    [menuView removeFromSuperview];
    menuView=nil;
    searchBar=nil;
    suggestTableView=nil;
    
    /*
     // ここで選択された文字列で検索等を行う。
     UIAlertView *alert = [
     [UIAlertView alloc]
     initWithTitle : NSLocalizedString(@"お知らせ", @"")
     message : [NSString stringWithFormat:@"%@ が選択されました。", [dataSouce objectAtIndex:indexPath.row]]
     delegate : nil
     cancelButtonTitle : @"OK"
     otherButtonTitles : nil
     ];
     [alert show];
     //	[alert release];*/
}

//===============
// Util
//===============

// エンコード

- (NSString *)encodeURIComponent:(NSString* )s {
    return ((__bridge NSString*)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                        (CFStringRef)s,
                                                                        NULL,
                                                                        (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                        kCFStringEncodingUTF8));
}

/*******************************************************************
 関数名　　goHome
 概要	ホームURL表示
 引数	なし
 戻り値	なし
 *******************************************************************/
- (void)goHome {
    url=[NSURL URLWithString:urlString];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [webView loadRequest:req];
    
    //メニュー用のビューを画面から削除
    [menuView removeFromSuperview];
    menuView=nil;
}

/*******************************************************************
 関数名　　goBack
 概要	ウェブビューのページバック
 引数	なし
 戻り値	なし
 *******************************************************************/
- (void)goBack {
    [webView goBack];
}

/*******************************************************************
 関数名　　goFoward
 概要	ウェブビューのページフォワード
 引数	なし
 戻り値	なし
 *******************************************************************/
- (void)goFoward {
    [webView goForward];
}

/*******************************************************************
 関数名　　reloadWebView
 概要	ウェブビューのリロード表示
 引数	なし
 戻り値	なし
 *******************************************************************/
- (void)reloadWebView {
    [webView reload];
}

/*******************************************************************
 関数名  webViewDidStartLoad
 概要	webViewのロード時に呼ばれる
 引数	(UIWebView*)webView  - webView
 戻り値	なし
 *******************************************************************/
- (void)webViewDidStartLoad:(UIWebView*)webView {
    //インジケーターの表示
    //    [activityIndicator startAnimating];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

/*******************************************************************
 関数名  webViewDidStartLoad
 概要	webViewのHTML取得成功時に呼ばれる
 引数	(UIWebView*)webView  - webView
 戻り値	なし
 *******************************************************************/
- (void)webViewDidFinishLoad:(UIWebView*)webView {
    //インジケーターの非表示
    //    [activityIndicator stopAnimating];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

/*******************************************************************
 関数名  webViewdidFailLoadWithError
 概要	webViewのHTML取得失敗時に呼ばれる
 引数	(UIWebView*)webView  - webView
 戻り値	なし
 *******************************************************************/
- (void)webView:(UIWebView*)webView
didFailLoadWithError:(NSError*)error {
    //インジケーターの非表示
    //    [activityIndicator stopAnimating];
    //    NSLog(error);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSInteger err_code = [error code];
    if (err_code == NSURLErrorCancelled) { // 読み込みストップの場合は何もしない
        return;
    }
    
    //通信エラーのアラートを表示
    UIAlertView *alert =
    [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"通信エラー",nil) message:NSLocalizedString(@"インターネットの接続を確認できません。",nil)
                              delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

/*******************************************************************
 関数名  viewActionSheet
 概要	アクションシートの表示
 引数	なし
 戻り値	なし
 *******************************************************************/
/*- (void)viewActionSheet
 {
 if(lock==1)
 {
 [self lockView];
 return;
 }
 
 // アクションシート作成
 UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
 actionSheet.delegate = self;
 actionSheet.backgroundColor=[UIColor lightGrayColor];
 actionSheet.actionSheetStyle=UIActionSheetStyleDefault;
 actionSheet.title = NSLocalizedString(@"タブの設定を行います。",nil);
 [actionSheet addButtonWithTitle:NSLocalizedString(@"タイトル設定",nil)];
 [actionSheet addButtonWithTitle:NSLocalizedString(@"URL設定",nil)];
 [actionSheet addButtonWithTitle:NSLocalizedString(@"オートリロード設定",nil)];
 [actionSheet addButtonWithTitle:@"OK"];
 actionSheet.cancelButtonIndex = 3;
 [actionSheet showInView:self.view.window];
 }*/

/*******************************************************************
 関数名  loadData
 概要	辞書データロード
 引数	なし
 戻り値	なし
 *******************************************************************/
- (void)loadData
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    titleString=[userDefaults stringForKey:@"TITLE3"];
    titleString=titleString?titleString:@"tab3";            //NULL化されていた場合は"デフォルトタブ名を設定
    urlString=[userDefaults stringForKey:@"URL3"];
    urlString=urlString?urlString:@"http://google.com";     //NULL化されていた場合はGoogleURLを設定
    
    titleString2=[userDefaults stringForKey:@"TITLE1"];
    titleString2=titleString2?titleString2:@"tab1";            //NULL化されていた場合は"デフォルトタブ名を設定
    urlString2=[userDefaults stringForKey:@"URL1"];
    urlString2=urlString2?urlString2:@"http://google.com";     //NULL化されていた場合はGoogleURLを設定
    
    titleString3=[userDefaults stringForKey:@"TITLE2"];
    titleString3=titleString3?titleString3:@"tab2";            //NULL化されていた場合は"デフォルトタブ名を設定
    urlString3=[userDefaults stringForKey:@"URL2"];
    urlString3=urlString3?urlString3:@"http://google.com";     //NULL化されていた場合はGoogleURLを設定
    
    titleString4=[userDefaults stringForKey:@"TITLE4"];
    titleString4=titleString4?titleString4:@"tab4";            //NULL化されていた場合は"デフォルトタブ名を設定
    urlString4=[userDefaults stringForKey:@"URL4"];
    urlString4=urlString4?urlString4:@"http://google.com";     //NULL化されていた場合はGoogleURLを設定
    
    titleString5=[userDefaults stringForKey:@"TITLE5"];
    titleString5=titleString5?titleString5:@"tab5";            //NULL化されていた場合は"デフォルトタブ名を設定
    urlString5=[userDefaults stringForKey:@"URL5"];
    urlString5=urlString5?urlString5:@"http://google.com";     //NULL化されていた場合はGoogleURLを設定
    
    reloadTime=[userDefaults integerForKey:@"RELOAD3"];
    reloadTime=reloadTime?reloadTime:0;                     //NULL化されていた場合は0を設定
    
    /*passString=[userDefaults stringForKey:@"PASSWORD"];
     passString=passString?passString:@"";
     lock=[userDefaults integerForKey:@"LOCK"];*/
}

/*******************************************************************
 関数名  saveData
 概要	辞書データセーブ
 引数	なし
 戻り値	なし
 *******************************************************************/
- (void)saveData:(int)index
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    //アクションシートでindexに値を設定されてコールされる
    if(index==0)
        [userDefaults setObject:titleString forKey:@"TITLE3"];
    else if(index==1)
        [userDefaults setObject:urlString forKey:@"URL3"];
    else if(index==2)
        [userDefaults setInteger:reloadTime forKey:@"RELOAD3"];
    //    [userDefaults setObject:@"test" forKey:@"TITLE3"];
    else if(index==3)
    {
        //        [userDefaults setObject:passString forKey:@"PASSWORD"];
        //        [userDefaults setInteger:lock forKey:@"LOCK"];
    }
    else if(index==4)
    {
        //        [userDefaults setInteger:lock forKey:@"LOCK"];
    }
    
    //データ保存
    [userDefaults synchronize];
}

/*******************************************************************
 関数名  actionSheet
 概要	アクションシートの表示
 引数	(UIActionSheet*)actionSheetclickedButtonAtIndex　- アクションシート
 (NSInteger)buttonIndex　- クリックされたボタンインデックス
 戻り値	なし
 *******************************************************************/
/*-(void)actionSheet:(UIActionSheet*)actionSheet
 clickedButtonAtIndex:(NSInteger)buttonIndex {
 switch (buttonIndex) {
 case 0:            // １番目のボタンが押されたときの処理を記述する
 alertFlag=0;
 [self buttonDidPushed:0];
 break;
 case 1:            // ２番目のボタンが押されたときの処理を記述する
 alertFlag=1;
 [self buttonDidPushed:1];
 break;
 case 2:            // ３番目のボタンが押されたときの処理を記述する
 alertFlag=2;
 [self buttonDidPushed:2];
 break;
 case 3:            // 4番目のボタンが押されたときの処理を記述する
 break;
 default:
 break;
 }
 }*/

/*******************************************************************
 関数名  clickedButtonAtIndex0
 概要	タイトル設定画面表示用ドライバ　アクションシートから切り出し
 引数	なし
 戻り値	なし
 *******************************************************************/
- (void)clickedButtonAtIndex0
{
    alertFlag=0;
    [self buttonDidPushed:0];
}

/*******************************************************************
 関数名  clickedButtonAtIndex1
 概要	URL設定画面表示用ドライバ　アクションシートから切り出し
 引数	なし
 戻り値	なし
 *******************************************************************/
- (void)clickedButtonAtIndex1
{
    alertFlag=1;
    [self buttonDidPushed:1];
}

/*******************************************************************
 関数名  clickedButtonAtIndex2
 概要	オートリロード設定画面表示用ドライバ　アクションシートから切り出し
 引数	なし
 戻り値	なし
 *******************************************************************/
- (void)clickedButtonAtIndex2
{
    alertFlag=2;
    [self buttonDidPushed:2];
}


/*******************************************************************
 関数名  buttonDidPushed
 概要	アクションシートのボタンをクリックした際の処理
 引数	(int)index        //クリック元アクションシートのインデックス
 戻り値	なし
 *******************************************************************/
- (void)buttonDidPushed:(int)index
{
    NSString *alertTitle;
    NSString *alertMessage;
    NSString *alertString;
    NSString *itemString;
    
    if(index==0)
    {
        alertTitle=NSLocalizedString(@"タイトル設定",nil);
        alertMessage=NSLocalizedString(@"このタブの名前を全角6文字（半角12文字）以内で入力してください。\n\n\n",nil);
        //表示中のwebページのタイトルを取得
        NSString *tempString=[webView stringByEvaluatingJavaScriptFromString:@"document.title"];
        alertString=tempString;
        //名前入力サポートの電話キーパッド
        textField.keyboardType=UIKeyboardTypeNamePhonePad;
        itemString=NSLocalizedString(@"タイトル",nil);
        //        alertString=titleString;
    }
    else if(index==1)
    {
        alertTitle=NSLocalizedString(@"URL設定",nil);
        alertMessage=NSLocalizedString(@"http://で始まるURLを入力してください。\n\n\n",nil);
        //表示中のwebページのURLを取得
        NSURL *tempURL=webView.request.URL;
        alertString=tempURL.absoluteString;
        //URL入力に使用するキーボード
        textField.keyboardType=UIKeyboardTypeURL;
        itemString=@"URL";
        //        alertString=urlString;
    }
    else if(index==2)
    {
        alertTitle=NSLocalizedString(@"オートリロード設定",nil);
        alertMessage=NSLocalizedString(@"0秒~10800秒の間の任意の整数秒を設定してください。（0推奨）\n\n\n",nil);
        //設定されているリロード時間を取得
        alertString=[NSString stringWithFormat:@"%d",reloadTime];
        //数字テンキー
        textField.keyboardType=UIKeyboardTypeNumberPad;
        itemString=NSLocalizedString(@"秒数",nil);
    }
    
    /*
     // UIAlertViewの生成
     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle
     message:alertMessage
     delegate:self
     cancelButtonTitle:@"Cancel"
     otherButtonTitles:@"OK", nil];*/
    
    DDSocialDialogTheme dialogTheme = 0;
    BButtonType type=0;
    
    blankDialog = [[DDSocialDialog alloc] initWithFrame:CGRectMake(0., 0., 300., 250.) theme:dialogTheme];
    blankDialog.dialogDelegate = self;
    
    //Title Name
    blankDialog.titleLabel.text = NSLocalizedString(alertTitle,nil);
    
    textField = [[UITextField alloc] initWithFrame:CGRectMake(85, 130, 165, 25)];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.font = [UIFont fontWithName:@"Arial-BoldMT" size:18];
    textField.textColor = [UIColor grayColor];
    textField.text=alertString;
    textField.minimumFontSize = 8;
    textField.adjustsFontSizeToFitWidth = YES;
    textField.delegate = self;
    textField.keyboardType=UIKeyboardTypeDefault;
    [ textField becomeFirstResponder];
    
    //Explanation
    UILabel *expLabel=[[UILabel alloc]initWithFrame:CGRectMake(15, 40, 250, 80)];
    expLabel.text=NSLocalizedString(alertMessage,nil);
    expLabel.font=[UIFont fontWithName:@"Arial" size:12];
    expLabel.textColor=[UIColor colorWithRed:0.202 green:0.3 blue:0.202 alpha:0.99];
    expLabel.numberOfLines=4;
    expLabel.textAlignment=NSTextAlignmentCenter;
    
    //Item Name
    UILabel *itemLabel=[[UILabel alloc]initWithFrame:CGRectMake(15, 130, 60, 25)];
    itemLabel.text=NSLocalizedString(itemString,nil);
    itemLabel.font=[UIFont fontWithName:@"Arial" size:12];
    itemLabel.textColor=[UIColor colorWithRed:0.202 green:0.3 blue:0.202 alpha:0.99];
    itemLabel.textAlignment=NSTextAlignmentCenter;
    
    //Left Button
    BButton *cancelBtn = [[BButton alloc] initWithFrame:CGRectMake(40,180, 80, 30) type:type];
    [cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelDialog) forControlEvents:UIControlEventTouchUpInside];
    [blankDialog addSubview:cancelBtn];
    
    //Right Button
    BButton *okBtn = [[BButton alloc] initWithFrame:CGRectMake(160,180, 80, 30) type:type];
    [okBtn setTitle:@"OK" forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(okDialog) forControlEvents:UIControlEventTouchUpInside];
    [blankDialog addSubview:okBtn];
    
    [blankDialog addSubview:textField];
    [blankDialog addSubview:expLabel];
    [blankDialog addSubview:itemLabel];
    [blankDialog addSubview:cancelBtn];
    [blankDialog addSubview:okBtn];
    
    [blankDialog show];
}

-(void)cancelDialog
{
    [blankDialog cancel];
}

-(void)okDialog
{
    if(alertFlag==0)
    {
        // テキストフィールド未入力の場合
        if ([textField.text length]==0)
        {
            [self errorAlertView:0];
        }
        //文字数オーバー
        //                else if([textField.text length]>6)
        else if([textField.text lengthOfBytesUsingEncoding:NSShiftJISStringEncoding]>12)
        {
            [self errorAlertView:3];
        }
        //正常入力
        else
        {
            titleString=textField.text;
            [self saveData:0];
            //                    [self viewDidLoad];
            self.title=titleString;
            [menuView removeFromSuperview];
            menuView=nil;
            [blankDialog cancel];
        }
    }
    else if(alertFlag==1)
    {
        textString=textField.text;
        
        // テキストフィールド未入力の場合
        if ([textField.text length]==0)
        {
            [self errorAlertView:1];
        }
        else if(!([textString hasPrefix:@"http://"] || [textString hasPrefix:@"https://"]))
        {
            [self errorAlertView:4];
        }
        //正常入力
        else
        {
            urlString=textField.text;
            [self saveData:1];
            [menuView removeFromSuperview];
            menuView=nil;
            [blankDialog cancel];
        }
    }
    else if(alertFlag==2)
    {
        // テキストフィールド未入力の場合
        if ([textField.text length]==0) {
            [self errorAlertView:2];
        }
        else if(textField.text.intValue<0 || textField.text.intValue>10800)
        {
            [self errorAlertView:5];
        }
        //正常入力
        else
        {
            reloadTime=textField.text.intValue;
            [self saveData:2];
            [self timeStart];
            [menuView removeFromSuperview];
            menuView=nil;
            [blankDialog cancel];
        }
    }        /*            case 30:
              // テキストフィールド未入力の場合
              if ([textField.text length]==0) {
              [self errorAlertView:31];
              }
              else
              {
              if( ([textField.text lengthOfBytesUsingEncoding:NSShiftJISStringEncoding]>12) || ([textField.text lengthOfBytesUsingEncoding:NSShiftJISStringEncoding]<4) )
              {
              [self errorAlertView:32];
              }
              //正常入力
              else
              {
              NSMutableCharacterSet *checkCharSet = [[NSMutableCharacterSet alloc] init];
              [checkCharSet addCharactersInString:@"abcdefghijklmnopqrstuvwxyz"];
              [checkCharSet addCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZ"];
              [checkCharSet addCharactersInString:@"1234567890"];
              if([[textField.text stringByTrimmingCharactersInSet:checkCharSet] length] > 0){
              //エラー処理
              [self errorAlertView:33];
              }
              else
              {
              lock=1;
              passString=textField.text;
              [self saveData:3];
              break;
              }
              //                        [self viewDidLoad];
              }
              }
              break;
              case 40:
              if(!([textField.text isEqualToString:passString]))
              {
              [self errorAlertView:41];
              }
              else
              {
              lock=0;
              [self saveData:4];
              break;
              }*/
    
}


/*******************************************************************
 関数名  errorAlertView
 概要	テキストフィールドの入力エラーアラート表示
 引数	(int)errorNumber    - エラー番号
 戻り値	なし
 *******************************************************************/
- (void)errorAlertView:(int)errorNumber
{
    NSString *errorString;
    //    alertFlag=3+errorNumber;        //エラーメッセージ表示後に再入力を促すために加算処理
    
    if(errorNumber==0)
    {
        errorString=NSLocalizedString(@"タイトルが入力されていません。\n",nil);
    }
    else if(errorNumber==1)
    {
        errorString=NSLocalizedString(@"URLが入力されていません。\n",nil);
    }
    else if(errorNumber==2)
    {
        errorString=NSLocalizedString(@"数値が入力されていません。\n",nil);
    }
    else if(errorNumber==3)
    {
        errorString=NSLocalizedString(@"入力文字数オーバーです。\n",nil);
    }
    else if(errorNumber==4)
    {
        errorString=NSLocalizedString(@"http://で始まるアドレスを入力してください。\n",nil);
    }
    else if(errorNumber==5)
    {
        errorString=NSLocalizedString(@"0~10800までの整数を入力してください。\n",nil);
    }
    else if(errorNumber==31)
    {
        errorString=NSLocalizedString(@"文字が入力されていません。\n",nil);
    }
    else if(errorNumber==32)
    {
        errorString=NSLocalizedString(@"4文字以上12文字以内で入力してください。\n",nil);
    }
    else if(errorNumber==33)
    {
        errorString=NSLocalizedString(@"半角英数字を入力してください。\n",nil);
    }
    else if(errorNumber==41)
    {
        errorString=NSLocalizedString(@"パスワードが一致しません。\n",nil);
    }
    
    // UIAlertViewの生成
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"入力エラー",nil)
                                                        message:errorString // テキストフィールドのスペースを確保するため、空白を設定
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
    
    // アラート表示
    [alertView show];
    // テキストフィールドをファーストレスポンダに
    //        [textField becomeFirstResponder];
}

/*******************************************************************
 関数名  AlertView
 概要	テキストフィールドの入力エラーアラート表示
 引数	(UIAlertView *)alertView -アラートビュー
 clickedButtonAtIndex:(NSInteger)buttonIndex -クリックされたボタンインデックス
 戻り値	なし
 *******************************************************************/
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    //エラーアラートからOKが選択された場合、設定画面からキャンセルが選択された場合
    if (buttonIndex == 0) {
        /*
         if(alertFlag>=3 && alertFlag<=29)
         {
         //再入力を促す
         alertFlag%=3;
         [self buttonDidPushed:alertFlag];
         }*/
        /*        else if(alertFlag>=34 && alertFlag<=36)
         {
         [self passwordAlert];
         }
         else if(alertFlag==44)
         {
         [self passwordAlert];
         }*/
    }
    
    // 設定画面からOKが選択された場合
    if (buttonIndex == 1) {
    }
}

/*******************************************************************
 関数名  didReceiveMemoryWarning
 概要	メモリ不足時に呼ばれる
 引数	なし
 戻り値	なし
 *******************************************************************/
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end