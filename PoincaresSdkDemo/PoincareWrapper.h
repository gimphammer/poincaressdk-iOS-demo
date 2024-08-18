/**
 * @file PoincareWrapper.h
 * @author wuliang (wuliang@poincares.com)
 * @brief
 * @version 0.1
 * @date 2024-07-12
 *
 * @copyright Copyright (c) 2024 @poincares.com
 *
 */

#import <PoincaresSdk/PoincaresSdk.h>


typedef NS_ENUM(int, DemoError){
  DErrorNone   = 0,
  DErrorStart  = 1,
  DErrorStop   = 2,
  DErrorAddTask= 3,
  DErrorAddTaskUnsupportType= 4,
  DErrorAddTaskInternal     = 5,
};


@interface DemoTaskRecord : NSObject

@property(assign, nonatomic) uint64_t taskID;
@property(assign, nonatomic) uint32_t taskVersion;
- (instancetype) init;

@end


@interface PoincareWrapper : NSObject <PoincaresOperationObserver>

@property (readwrite, nonatomic) PoincaresSession* session;

@property (assign, nonatomic) BOOL isStarted;
@property (readwrite, nonatomic) DemoTaskRecord*  pingRecord;
@property (readwrite, nonatomic) DemoTaskRecord*  httpRecord;
@property (readwrite, nonatomic) DemoTaskRecord*  tcpPingRecord;
@property (readwrite, nonatomic) DemoTaskRecord*  mtrRecord;

- (instancetype) init;
//- (BOOL)isSessionStarted;
- (DemoError)start;
- (DemoError)stop;
- (DemoError)addTask : (NSString* )host
            taskType : (PoincaresTaskType) type
           taskCount : (int) taskCount;

//implement the delegate of PoincaresOperationObserver
- (void)OnOperationEnd : (PoincaresOperationResult*) result;



@end

