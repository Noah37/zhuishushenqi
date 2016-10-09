//
//  CSIIBaseModel.h
//  O2O_Clients
//
//  Created by chaozhi on 16/3/9.
//  Copyright © 2016年 CNY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYCBaseModel : NSObject
+(NSArray *)modelWithModleClass:(Class )modelClass withJsArray:(NSArray *)JSONArray withError:(NSError **)error;
@end
