/**
 * @file PoincaresSession.h
 * @author wuliang (wuliang@poincares.com)
 * @brief 
 * @version 0.1
 * @date 2024-07-11
 * 
 * @copyright Copyright (c) 2024 @poincares.com
 * 
 */


/*!
 * @brief This is the main operation class
 */
@interface PoincaresSession : NSObject

/*!  
 * Use thie API to get the shared instance of PoincaresSession
 * @param appKey The app key of the app, apply it from www.poincares.com
 * @param appSecret The app secret of the app, apply it from www.poincares.com
 * @param appTag it contains extra info about app
 * @param url The url of the scheduling server, which session will used. you can get
 *            it when appli for the appKey.
 * @param observer The observer of the operation result
 * @return the instance of PoincaresSession
 */
+ (instancetype)sharedSessionWithAppKey : (NSString*) appKey
                          withAppSecret : (NSString*) appSecret
                             withAppTag : (PoincaresAppTag*) appTag
                withSchedulingServerUrl : (NSString*) url
                   withOpeationObserver : (id<PoincaresOperationObserver>) observer;

/*!
 * Add task by manual. Usually session will get the task config from server.
 * But, you can also add a task by manual.
 * @param The task description
 * @return 0 if success, otherwise failed. don't forget to 
 *         check PoincaresOperationObserver to get final result 
 *         because of asynchronized process
 */
- (int) addTask : (PoincaresTaskDescBase*)desp;
/*! Start the session */
- (int) start;
/*! Stop the session */
- (int) stop;

@end
