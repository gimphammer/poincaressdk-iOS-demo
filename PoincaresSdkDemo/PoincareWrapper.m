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
NSString* gAppKey   =@"to apply on www.poincares.com";
NSString* gAppSecret=@"to apply on www.poincares.com";


NSString* gSchedulingServerUrl=@"https://account-dev.poincares.com/config/center/info";

NSString* gAppName = @"PoincarsSDKDemo_iOS";
NSString* gAppVersion = @"1.0.0";
NSString* gAppId   = @"PoincarsSDKDemo_iOS_default_id";
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
  
  self.pingRecord = [[DemoTaskRecord alloc] initWithID : 1
                                           withVersion : 1];
  
  self.httpRecord = [[DemoTaskRecord alloc] initWithID : 1000
                                           withVersion : 1];
  
  self.tcpPingRecord = [[DemoTaskRecord alloc] initWithID : 2000
                                              withVersion : 1];
  
  self.mtrRecord  = [[DemoTaskRecord alloc] initWithID : 3000
                                           withVersion : 1];
  
  
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
           taskCount : (int) taskRounds
{
  if (nil == self.session)
    return DErrorAddTask;
  
  PoincaresTaskDescBase* taskDesc = nil;
  switch (type) {
    case TTPing:
      {
        int pktCnt = 10;
        int pktInterval = 1000;
        int jobInterval = pktInterval * pktCnt + 1000 * 60;
        
        taskDesc = [PoincaresTaskDescBase createPingTaskWithId:_pingRecord.taskID++
                                                       version:_pingRecord.taskVersion++
                                                          host:host
                                                      interval:jobInterval
                                                        rounds:taskRounds //5//kCyclicTaskMode
                                                    packetSize:64
                                                   packetCount:pktCnt
                                                    perTimeOut:1000
                                                   perInterval:pktInterval];
      }
      break;
    case TTHttp:
      {
        int jobInterval = 1000 * 60;
        
                
        NSString* linkUrl = host;
        //link should have the whole URL with protocol
        if (![host hasPrefix:@"https://"] || ![host hasPrefix:@"http://"]) {
          linkUrl = [[NSString alloc] initWithFormat:@"%s%@", "https://", host];
        }
        
        
        taskDesc = [PoincaresTaskDescBase createHttpTaskWithId:_httpRecord.taskID++
                                                       version:_httpRecord.taskVersion++
                                                          host:host
                                                      interval:jobInterval
                                                        rounds:taskRounds
                                                          link:linkUrl
                                                          port:80
                                                  protoVersion:2 /*it's not used now, reserved*/
                                                       timeout:1000*10];
        
      }
      break;
    case TTTcpPing:
      {
        int perTimeout = 1000 * 2;
        int perInterval= 1000 * 2;
        int connectCnt = 10;
        
        int jobInterval = perInterval * connectCnt + 1000 * 60;
        taskDesc = [PoincaresTaskDescBase createTcpPingTaskWithId:_tcpPingRecord.taskID++
                                                          version:_tcpPingRecord.taskVersion++
                                                             host:host
                                                         interval:jobInterval
                                                           rounds:taskRounds
                                                             port:80
                                                     connectCount:connectCnt
                                                       perTimeout:perTimeout
                                                      perInterval:perInterval];
      }
      break;
    case TTMtr:
      {
        int packetCnt   = 10;
        int perTimeout  = 100;
        int perInterval = 1000;
        int jobInterval = perInterval*packetCnt + 1000 * 60;
        
        taskDesc = [PoincaresTaskDescBase createMtrTaskWithId:_mtrRecord.taskID++
                                                      version:_mtrRecord.taskVersion++
                                                         host:host
                                                     interval:jobInterval
                                                       rounds:taskRounds
                                                   packetSize:64
                                                  packetCount:packetCnt
                                                   perTimeout:perTimeout
                                                  perInterval:perInterval];
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
  
  if (result) {
    __block PoincaresOperationResult* resultCloned = [result clone];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // 在主线程上处理数据并输出log
      NSMutableString *opInfo = [[NSMutableString alloc] init];
      [opInfo appendFormat: @"%@ OnOperationEnd: opType(%@), errCode(0x%x), extraMsg(\"%@\")",
       gLogPrefix, [self OpType2String:resultCloned.opType], resultCloned.errCode,resultCloned.extraMsg ];
      
      if (OTTaskAdding == resultCloned.opType) {
        [opInfo appendFormat: @", taskType(%@), taskId(%lld), taskVersion(%d) ",
         [self TaskType2String:resultCloned.taskType], resultCloned.taskId, resultCloned.taskVersion];
      }

      NSLog(@"%@", opInfo);
    });
    
  }  
}


@end


