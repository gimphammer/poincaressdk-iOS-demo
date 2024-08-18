/**
 * @file PoincaresOperationObserver.h
 * @author wuliang (wuliang@poincares.com)
 * @brief an delegate for operation result
 * @version 0.1
 * @date 2024-07-11
 * 
 * @copyright Copyright (c) 2024 @poincares.com
 * 
 */


/*! @brief an delegate for operation result. The opreation result will be
 *  reported to the invoker via this observer
 */
@protocol PoincaresOperationObserver <NSObject>

/*! the speicific result is discribed by this API */
- (void)OnOperationEnd : (PoincaresOperationResult*) result;

@end

