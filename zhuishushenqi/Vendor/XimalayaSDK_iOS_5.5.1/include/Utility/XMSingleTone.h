//
//  XMSingleTone.h
//  ting
//
//  Created by cszhan on 14-5-28.
//
//

// declare (.h)
#define DECLARE_SINGLETON_METHOD(className, singletonName)    \
+ (className *)singletonName;

// define (.m)
#define DEFINE_SINGLETON_METHOD(className, singletonName)     \
static className *singletonName = nil; \
+ (className *)singletonName \
{\
@synchronized(self) {\
if (singletonName == nil) {\
singletonName = [[self alloc] init];\
}\
}\
return singletonName;\
}\
\
+ (id)allocWithZone:(NSZone *)zone \
{\
@synchronized(self) {\
if (singletonName == nil) { \
singletonName = [super allocWithZone:zone];\
return singletonName;\
}\
}\
return nil;\
}\
\
+ (id)copyWithZone:(NSZone *)zone \
{\
return self;\
}\
