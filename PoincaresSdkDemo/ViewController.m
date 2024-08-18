/**
 * @file ViewController.m
 * @author wuliang (wuliang@poincares.com)
 * @brief
 * @version 0.1
 * @date 2024-07-12
 *
 * @copyright Copyright (c) 2024 @poincares.com
 *
 */


#import "ViewController.h"
#import <PoincaresSdk/PoincaresSdk.h>
#import "PoincareWrapper.h"

@interface ViewController ()


@property (readwrite, nonatomic) PoincareWrapper* pcWrapper;
- (void)initializePoincares;
- (IBAction)showAlert : (NSString*) msg;

@end

NSString* kTitleStart=@"Start by Server Config";
NSString* kTitleStop=@"Stop Session";

@implementation ViewController


- (void)initializePoincares {
  _pcWrapper = [[PoincareWrapper alloc] init];

  [self enableSingleTaskAdd:NO];

}

- (void)enableSingleTaskAdd : (BOOL)enable {
  _btnAddPing.enabled = enable;
  _btnAddHttp.enabled = enable;
  _btnAddTcpPing.enabled = enable;
  _btnAddMtr.enabled = enable;
}



- (IBAction)showAlert : (NSString*) msg{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                   message:msg
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

// UITextFieldDelegate 方法，当用户点击 Return 键时调用
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    // 隐藏键盘
    [textField resignFirstResponder];
    return YES;
}



- (void)viewDidLoad {
  [super viewDidLoad];
  [self initializePoincares];

  // Do any additional setup after loading the view.
}

//@property (weak, nonatomic) IBOutlet UITextField *tfPingURL;
//@property (weak, nonatomic) IBOutlet UITextField *tfPingTaskCount;
//@property (weak, nonatomic) IBOutlet UIButton *pingStart;

- (IBAction)startByServerConfig:(id)sender {
  UIButton* btn = (UIButton*)sender;
  
  if (NO == _pcWrapper.isStarted) {
    [_pcWrapper start];
    [btn setTitle:kTitleStop
         forState:UIControlStateNormal];
    
    [self enableSingleTaskAdd:YES];
    
  }
  else {
    [_pcWrapper stop];
    [btn setTitle:kTitleStart
         forState:UIControlStateNormal];
    [self enableSingleTaskAdd:NO];
  }

}



- (IBAction)addPingTask:(id)sender {
  int taskCount = [_tfPingTaskCount.text intValue];
  if (0 == taskCount || taskCount < -1) {
    [self showAlert: @"Invalid TaskCount!\nCheck your format, or check value=-1 or value>0"];
    return;
  }
  
  if (nil == _tfPingURL.text || _tfPingURL.text.length <= 0) {
    [self showAlert: @"You need to set the URL to ping"];
    return;
  }
  
  [_pcWrapper addTask:_tfPingURL.text
             taskType:TTPing
            taskCount:taskCount];
  
  _btnAddPing.enabled = NO;
}


- (IBAction)addHttpTask:(id)sender {
  int taskCount = [_tfHttpTaskCount.text intValue];
  if (0 == taskCount || taskCount < -1) {
    [self showAlert: @"Invalid TaskCount!\nCheck your format, or check value=-1 or value>0"];
    return;
  }
  
  if (nil == _tfHttpUrl.text || _tfHttpUrl.text.length <= 0) {
    [self showAlert: @"You need to set the URL to ping"];
    return;
  }
  
  [_pcWrapper addTask:_tfHttpUrl.text
             taskType:TTHttp
            taskCount:taskCount];
  
  _btnAddHttp.enabled = NO;
}



- (IBAction)addTcpPingTask:(id)sender {
  int taskCount = [_tfTcpPingTaskCount.text intValue];
  if (0 == taskCount || taskCount < -1) {
    [self showAlert: @"Invalid TaskCount!\nCheck your format, or check value=-1 or value>0"];
    return;
  }
  
  if (nil == _tfTcpPingUrl.text || _tfTcpPingUrl.text.length <= 0) {
    [self showAlert: @"You need to set the URL to ping"];
    return;
  }
  
  [_pcWrapper addTask:_tfTcpPingUrl.text
             taskType:TTTcpPing
            taskCount:taskCount];
  
  _btnAddTcpPing.enabled = NO;
  
}


- (IBAction)addMtrTask:(id)sender {
  int taskCount = [_tfMtrTaskCount.text intValue];
  if (0 == taskCount || taskCount < -1) {
    [self showAlert: @"Invalid TaskCount!\nCheck your format, or check value=-1 or value>0"];
    return;
  }
  
  if (nil == _tfMtrUrl.text || _tfMtrUrl.text.length <= 0) {
    [self showAlert: @"You need to set the URL to ping"];
    return;
  }
  
  [_pcWrapper addTask:_tfMtrUrl.text
             taskType:TTMtr
            taskCount:taskCount];
  
  _btnAddMtr.enabled = NO;
}




@end

