/**
 * @file PoincareWrapper.m
 * @author wuliang (wuliang@poincares.com)
 * @brief
 * @version 0.1
 * @date 2024-07-12
 *
 * @copyright Copyright (c) 2024 @poincares.com
 *
 */

#import "PoincareWrapper.h"




#pragma mark - Global variable and misc definiton
NSString* gAppKey=@"to apply on www.poincares.com";
NSString* gAppSecret=@"to apply on www.poincares.com";
NSString* gSchedulingServerUrl=@"http://8.149.142.50:81/config/center/info";

NSString* gAppName = @"PoincarsSDKDemo_iOS";
NSString* gAppVersion = @"0.99.0";
NSString* gAppId = @"PoincarsSDKDemo_iOS_default_id";
NSString* gAppVersionCode = @"PoincarsSDKDemo_iOS_versionCode_none";

NSString* gLogPrefix=@"[PoincaresSdkDemo]";



@implementation DemoTaskRecord  //utils class for inconvenience

- (instancetype)init {
  self = [super init];
  self.taskID      = 100;
  self.taskVersion = 100;
  
  return self;
}

- (instancetype)initWithID : (uint64_t)taskInitId
               withVersion : (uint32_t)taskInitVersion
{
  self = [super init];
  self.taskID      = taskInitId;
  self.taskVersion = taskInitVersion;
  
  return self;
}

@end

@interface PoincareWrapper ()

- (NSString*)OpType2String:(PoincaresOperationType) opType;
- (NSString*)TaskType2String:(PoincaresTaskType) taskType;

@end


#pragma mark - Implementation of PoincareWrapper
@implementation PoincareWrapper

- (instancetype) init {
  self = [super init];
  
  self.pingRecord = [[DemoTaskRecord alloc] initWithID : 100
                                           withVersion : 100];
  self.httpRecord = [[DemoTaskRecord alloc] initWithID : 300
                                           withVersion : 300];
  self.tcpPingRecord = [[DemoTaskRecord alloc] initWithID : 500
                                              withVersion : 500];
  self.mtrRecord  = [[DemoTaskRecord alloc] initWithID : 700
                                           withVersion : 700];
  
  
  PoincaresAppTag* appTag = [[PoincaresAppTag alloc] init];
  appTag.name        = gAppName;
  appTag.version     = gAppVersion;
  appTag.idendtifier = gAppId;
  appTag.versionCode = gAppVersionCode;

  self.session = [PoincaresSession sharedSessionWithAppKey:gAppKey
                                             withAppSecret:gAppSecret
                                                withAppTag:appTag
                                   withSchedulingServerUrl:gSchedulingServerUrl withOpeationObserver:(id<PoincaresOperationObserver>)self];
  if (nil == self.session) {
    NSLog(@"%@ PoincaresSession create failed", gLogPrefix);
  }
  
  
  return self;
}


- (NSString*)OpType2String:(PoincaresOperationType) opType
{
  switch (opType) {
    case OTStart:
      return @"OTStart";
    case OTStop:
      return @"OTStop";
    case OTTaskAdding:
      return @"OTTaskAdding";
    case OTSchedulingRequest:
      return @"OTSchedulingRequest";
    case OTTaskDisaptchRequest:
      return @"OTTaskDisaptchRequest";
    case OTDataReport:
      return @"OTDataReport";
    default:
      return @"Unknow";
  }
  
}
- (NSString*)TaskType2String:(PoincaresTaskType) taskType {
  switch (taskType) {
    case TTPing:
      return @"Ping";
    case TTTcpPing:
      return @"TcpPing";
    case TTHttp:
      return @"Http";
//    case TTDnsParsing:
//      return @"DnsParsing";
//    case TTTraceRouter:
//      return @"TraceRouter";
    case TTMtr:
      return @"Mtr";
    default:
      return @"Unknow";
  }
}

- (DemoError)start {
  if (YES == _isStarted)
    return DErrorNone;
  
  if (NO == _isStarted && nil != _session) {
    int err = [_session start];
    if (err) {
      NSLog(@"%@ start session internal err=0x%x", gLogPrefix, err);
      return DErrorStart;
    }
    else {
      _isStarted = YES;
      return DErrorNone;
    }
  }
  
  return DErrorStart;
}

- (DemoError)stop {
  if (nil != self.session) {
    self.isStarted = NO;
    return [self.session stop];
    
  }
  
  return DErrorStop;
}


- (DemoError)addTask : (NSString* )host
            taskType : (PoincaresTaskType) type
           taskCount : (int) taskCount
{
  if (nil == self.session)
    return DErrorAddTask;
  
  PoincaresTaskDescBase* taskDesc;
  switch (type) {
    case TTPing:
      {
        taskDesc = [PoincaresTaskDescBase createPingTaskWithId:_pingRecord.taskID++
                                                       version:_pingRecord.taskVersion++
                                                          host:host
                                                      interval:10000
                                                        rounds:taskCount //5//kCyclicTaskMode
                                                    packetSize:64
                                                   packetCount:10
                                                    perTimeOut:1000
                                                   perInterval:1000];
      }
      break;
    default:
      return DErrorAddTaskUnsupportType;
  }
  
  int err = [_session addTask:taskDesc];
  if (err) {
    NSLog(@"%@ addTask internal error=0x%x", gLogPrefix, err);
    return DErrorAddTaskInternal;
  }
  
  return DErrorNone;
}


- (void)OnOperationEnd : (PoincaresOperationResult*) result {
  NSLog(@"%@ OnOperationEnd: opType(%@), errCode(0x%x), extraMsg(\"%@\"), taskType(%@), taskId(%lld), taskVersion(%d)", gLogPrefix, [self OpType2String:result.opType], result.errCode, result.extraMsg, [self TaskType2String:result.taskType], result.taskId, result.taskVersion);
}


@end


