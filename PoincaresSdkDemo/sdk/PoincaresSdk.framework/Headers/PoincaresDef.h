/**
 * @file PoincaresDef.h
 * @author wuliang (wuliang@poincares.com)
 * @brief 
 * @version 0.1
 * @date 2024-07-11
 * 
 * @copyright Copyright (c) 2024 @poincares.com
 * 
 */

#import <Foundation/Foundation.h>

/*!
 * @brief The definition of specific task type
 */
typedef NS_ENUM(NSInteger, PoincaresTaskType) {
  /*! The task type for not being specified. */
  TTNone = 0,
  /*! The task type for ping. */
  TTPing,
  /*! The task type for tcp ping. */
  TTTcpPing,
  /*! The task type for http. */  
  TTHttp,
  /*! The task type of mtr*/
  TTMtr,
};


/*!
 * @brief The definition of operation type
 */
typedef NS_ENUM(NSInteger, PoincaresOperationType) {
  /*! The operation type for not being specified. */  
  OTNone = 0,
  /*! The operation type description for session start*/
  OTStart,
  /*! The operation type description for session stop*/
  OTStop,
  /*! The operation type description for session adding task*/
  OTTaskAdding,
  /*! The operation type description for session internal
   *  scheduling request
   */
  OTSchedulingRequest,
  /*! The operation type description for session internal
   *  disaptch request
   */
  OTTaskDisaptchRequest,
  /*! The operation type description for session internal
   *  data report
   */
  OTDataReport,
};


/*!
 * @brief Special mode for the task which is keep alway runing by the interval
 *        it's for the field of PoincaresTaskDescBase's rounds
 */
static const int kCyclicTaskMode = -1;


@class PoincaresTaskDescPing;
@class PoincaresTaskDescHttp;
@class PoincaresTaskDescTcpPing;
@class PoincaresTaskDescMtr;


/*!
 * @brief This is the base-class of the task-description. Every task is represented by a task-description
 */
@interface PoincaresTaskDescBase : NSObject

/*!
 * The type of the task
 */
@property(assign, nonatomic)    PoincaresTaskType    type;

/*!
 * The id of the task
 */
@property(assign, nonatomic)    uint64_t      id; //long long, such a‰s: 99880011
/*!
 * The version of the task
 */
@property(assign, nonatomic)    uint32_t      version;     //int, 1,2,3.....
/*!
 * The target host of the task. such as: "www.example.com" or "11.22.11.22"
 */
@property(readwrite, nonatomic) NSString*     host;
/*!
 * The interval of the task, base on millisecond
 */
@property(assign, nonatomic)    int32_t       interval;
/*!
 * How many rounds to run, "kCyclicTaskMode" means no rounds limitation.
 */
@property(assign, nonatomic)    uint32_t      rounds;  //

/*!
 * The init method of base-class is not allowed to be called.
 *        Use the static create method to create instances of task-description 
 *        instead.
 */
- (instancetype)init NS_UNAVAILABLE;

/*!
 * Method to create instances of PoincaresTaskDescPing
 */
+ (PoincaresTaskDescPing *)createPingTaskWithId:(uint64_t)taskId
                                        version:(uint32_t)taskVersion
                                           host:(NSString *)taskHost
                                       interval:(int32_t)taskInterval
                                         rounds:(uint32_t)taskRounds
                                     packetSize:(uint32_t)taskPacketSize
                                    packetCount:(uint32_t)taskPacketCount
                                      perTimeOut:(int64_t)taskPerTimeOut
                                     perInterval:(int64_t)taskPerInterval;

/*!
 * Method to create instances of PoincaresTaskDescHttp
 */
+ (PoincaresTaskDescHttp*)createHttpTaskWithId:(uint64_t)taskId
                                      version:(uint32_t)taskVersion
                                         host:(NSString*)taskHost
                                     interval:(int32_t)taskInterval
                                       rounds:(uint32_t)taskRounds
                                         link:(NSString*)taskLink
                                         port:(uint16_t)taskPort
                                 protoVersion:(uint16_t)taskProtocolVersion
                                      timeout:(int64_t)perTimeout
                                  perInterval:(int64_t)perInterval;

@end



/*!
 * @brief It's the description for ping task
 */
@interface PoincaresTaskDescPing : PoincaresTaskDescBase

/*! The size of the packet */
@property(assign, nonatomic) uint32_t  packetSize;
/*! How many packets to be send for one round of ping task */
@property(assign, nonatomic) uint32_t  packetCount;
/*! Interval for per packet, base on millisecond */
@property(assign, nonatomic) int64_t   perInterval;
/*! Time out for per packet, base on millisecond */
@property(assign, nonatomic) int64_t   perTimeOut;  //time out for per packet, base on millisecond

@end


/*! 
 * @brief it's the description for http task
 */
@interface PoincaresTaskDescHttp : PoincaresTaskDescBase
/*! The link means the complete url you wanna detect */
@property(readwrite, nonatomic)  NSString* link;
/*! The port of the target website */
@property(assign, nonatomic)  uint16_t port;
/*! The version of the protocol.
 * 1 means http, 2 means http 2. It's reserved 
 */
@property(assign, nonatomic)  uint16_t protocolVersion;
/*! The time out for per-packet, base on millisecond */  
@property(assign, nonatomic)  int64_t  perTimeout;
/*! The interval for per-packet, base on millisecond */
@property(assign, nonatomic)  int64_t  perInterval;
@end


/*!
 * @brief it's the description for tcp ping task
 */
@interface PoincaresTaskDescTcpPing : PoincaresTaskDescBase
/*! The tcp port of the target host */
@property(assign, nonatomic)  uint16_t port;
/*! How many packets to be send for one round of tcp ping task 
 *  The statistics is related to the packet numbers.
 */
@property(assign, nonatomic)  uint32_t packetNum;
/*! Timeout for every packet, base on millisecond */
@property(assign, nonatomic)  int64_t  perTimeout;
/*! Interval for every packet, base on millisecond */
@property(assign, nonatomic)  int64_t  perInterval;
@end


/*!
 * @brief it's the description for mtr task
 */
@interface PoincaresTaskDescMtr : PoincaresTaskDescBase
/*! Packe size for mtr task. 64 bytes is recommended */
@property(assign, nonatomic)  uint32_t packetSize;
/*! Packet num for one round mtr task. The statics is related to the packet nums. */
@property(assign, nonatomic)  uint32_t packetNum;
/*! Timeout for every packet, base on millisecond */
@property(assign, nonatomic)  int64_t  perTimeout;
/*! Interval for every packet, base on millisecond */
@property(assign, nonatomic)  int64_t  perInterval;
@end




/*!
 * @brief Asynchronous mechanism is used to notify invoke the result of 
 *        the operation. When you call start or addTask, the opration result
 *        will be notified to invoker through PoincaresOperationObserver with
 *        this PoincaresOperationResult
 */
@interface PoincaresOperationResult : NSObject
/*! To identify the operation type */
@property(assign, nonatomic)    PoincaresOperationType opType;
/*! To identify the operation error. 0 means no error. */
@property(assign, nonatomic)    int        errCode;
/*! Extra message for explaination on error, if there is */
@property(readwrite, nonatomic) NSString*  extraMsg;
/*! Only valid when it's the operation of addTask, 
 * to identify which task you wanna add 
 */
@property(assign, nonatomic)    PoincaresTaskType taskType;
/*! Only valid when it's the operation of addTask, 
 * to identify the taskID you wanna add
 */
@property(assign, nonatomic)    uint64_t   taskId;
/*! Only valid when it's the operation of addTask, 
 * to identify the taskVersion you wanna add
 */
@property(assign, nonatomic)    uint32_t   taskVersion;
@end


/*!
 * @brief It's extra info of application who use Poincares SDK.
 *        It's for your convenience when to do the data review on web.
 */
@interface PoincaresAppTag : NSObject
/*! Your app's version */
@property(readwrite, nonatomic)  NSString* version;
/*! Your app's name */
@property(readwrite, nonatomic)  NSString* name;
/*! Your app's id */
@property(readwrite, nonatomic)  NSString* idendtifier;
/*! Your app's versionCode */
@property(readwrite, nonatomic)  NSString* versionCode;
@end



