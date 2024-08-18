## PoincaresSDK简介

PoincaresSDK是一款有poincares.com发布的网络诊断SDK，它具备ICMP Ping、HTTP、MTR以及TCP Ping多种诊断方式。PoincaresSDK配合服务器端的大数据分析与挖掘，向用户提供详尽全面的网络状况分析与诊断，可为用户网络选型提供有力的决策依据。

<br /><br />

## 前置准备

在使用SDK前，需先在[官网](https://www.poincares.com)申请AppKey以及AppSecret。并替换demo PoincaresSessionWrapper中的全局变量：

```objective-c
NSString* gAppKey	   = @"to apply on www.poincares.com";
NSString* gAppSecret = @"to apply on www.poincares.com";
```

<br /><br />



## iOS SDK API使用说明

SDK核心类是PoincaresSession，用户可通过PoincaresSession来进行网络侦测的各项操作。

### PoincaresSession创建

```objective-c
+ (instancetype)sharedSessionWithAppKey : (NSString*) appKey
                          withAppSecret : (NSString*) appSecret
                             withAppTag : (PoincaresAppTag*) appTag
                withSchedulingServerUrl : (NSString*) url
                   withOpeationObserver : (id<PoincaresOperationObserver>) observer;
```

通过`PoincaresFactory`获取一个Session示例句柄

appKey ：是用于集成本SDK的Application标识，可在poincares.com官网申请。

appSecret：会在官网申请appKey是一并分配。

appTag：所涉及到的java数据结构类NDAppTag主要是对app的一些附属描述，详情可以参阅SDK API Doc

url：是调度服务器地址，SDK在拉取app用户在服务器侧的探测任务配置时，需要用到

observer：是操作回调。PoincaresSDK 除了stop，其他接口都是异步接口。因此针对PoincaresSession的某项调用（比如start()调用）最终的调用结果，会通过该observer反馈给应用层。在实现该delegate时，请特别留意，请勿在回调里运行重负载操作。建议，可以将回调的信息抛到其他线程做进一步处理。详情，可以参阅Demo。有关作用在Session上的各种Operation的具体类型可参与SDK API Doc中PoincaresDef.h - PoincaresOperationType部分说明。

<br />

### PoincaresSession启动

获取到Session实例后，即可进一步调用以下接口：

```objective-c
int err = [_session start];
```

通过Session的start()接口，启动网络侦测。sdk会连接之前的schedulingServerUrl地址，拉取任务配置，并启动相应任务。

<br />

### PoincaresSession停止

相应的停止接口为:

```objective-c
- (int) stop;
```

<br />