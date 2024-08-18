/**
 * @file ViewController.h
 * @author wuliang (wuliang@poincares.com)
 * @brief
 * @version 0.1
 * @date 2024-07-12
 *
 * @copyright Copyright (c) 2024 @poincares.com
 *
 */

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *tfPingURL;
@property (weak, nonatomic) IBOutlet UITextField *tfPingTaskCount;



@property (weak, nonatomic) IBOutlet UITextField *tfHttpUrl;
@property (weak, nonatomic) IBOutlet UITextField *tfHttpTaskCount;


@property (weak, nonatomic) IBOutlet UITextField *tfTcpPingUrl;
@property (weak, nonatomic) IBOutlet UITextField *tfTcpPingTaskCount;

@property (weak, nonatomic) IBOutlet UITextField *tfMtrUrl;
@property (weak, nonatomic) IBOutlet UITextField *tfMtrTaskCount;



@property (weak, nonatomic) IBOutlet UIButton *btnAddPing;
@property (weak, nonatomic) IBOutlet UIButton *btnAddHttp;
@property (weak, nonatomic) IBOutlet UIButton *btnAddTcpPing;
@property (weak, nonatomic) IBOutlet UIButton *btnAddMtr;



@end

