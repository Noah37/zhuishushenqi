//
//  CSIIBaseModel.m
//  O2O_Clients
//
//  Created by chaozhi on 16/3/9.
//  Copyright © 2016年 QS. All rights reserved.
//

#import "XYCBaseModel.h"
#import "YYModel.h"
@implementation XYCBaseModel
+(NSArray *)modelWithModleClass:(Class )modelClass withJsArray:(NSArray *)JSONArray withError:(NSError **)error;
{
    if (JSONArray == nil || ![JSONArray isKindOfClass:NSArray.class]) {
        if (error != NULL) {
            NSDictionary *userInfo = @{
                                       NSLocalizedDescriptionKey: NSLocalizedString(@"Missing JSON array", @""),
                                       NSLocalizedFailureReasonErrorKey: [NSString stringWithFormat:NSLocalizedString(@"%@ could not be created because an invalid JSON array was provided: %@", @""), NSStringFromClass(modelClass), JSONArray.class],
                                       };
            *error = [NSError errorWithDomain:@"modelWithModleClass" code:1 userInfo:userInfo];
        }
        return nil;
    }
    NSMutableArray *models = [NSMutableArray arrayWithCapacity:JSONArray.count];
    for (NSDictionary *dictionary in JSONArray
         ) {
        NSObject *model  = [modelClass yy_modelWithDictionary:dictionary];
        if (model == nil) {
            return nil;
        }
        [models addObject:model];
    }
    return models;
}
@end
