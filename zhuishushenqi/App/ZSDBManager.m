//
//  ZSDBManager.m
//  zhuishushenqi
//
//  Created by yung on 2018/11/22.
//  Copyright © 2018年 QS. All rights reserved.
//

#import "ZSDBManager.h"
#import <objc/runtime.h>
#import <FMDB/FMDB.h>

/** SQLite五种数据类型 */
#define SQLTEXT     @"TEXT"
#define SQLINTEGER  @"INTEGER"
#define SQLREAL     @"REAL"
#define SQLBLOB     @"BLOB"
#define SQLNULL     @"NULL"
#define PrimaryKey  @"primary key"

#define primaryId   @"pk"

@interface ZSDBManager ()

@property (nonatomic, strong) FMDatabaseQueue *dbQueue;

@end

@implementation ZSDBManager

+ (instancetype)share {
    static ZSDBManager *share = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        share = [[ZSDBManager alloc] init];
    });
    return share;
}

- (BOOL)isTableExist:(NSObject <ZSDBModel>*)model {
    __block BOOL res = NO;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *tableName = [model tableName];
        res = [db tableExists:tableName];
    }];
    return res;
}

- (NSArray *)getColumnsFrom:(NSObject <ZSDBModel>*)model {
    NSMutableArray *columns = [NSMutableArray array];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *tableName = NSStringFromClass(self.class);
        FMResultSet *resultSet = [db getTableSchema:tableName];
        while ([resultSet next]) {
            NSString *column = [resultSet stringForColumn:@"name"];
            [columns addObject:column];
        }
    }];
    return [columns copy];
}

+ (NSString *)getColumnAndTypeString:(NSArray <ZSDBPropertyModel *>*)models {
    NSMutableString *pars = [NSMutableString string];
    for (ZSDBPropertyModel *model in models) {
        if (![model.type isEqualToString:NSStringFromProtocol(@protocol(ZSDBModel))]) {
            if (model.mappingKey) {
                [pars appendString:model.mappingKey];
            } else {
                [pars appendString:model.originalKey];
            }
            [pars appendString:model.type];
            NSInteger count = [models indexOfObject:model];
            if (count != models.count - 1) {
                [pars appendString:@","];
            }
        }
    }
    return pars;
}

+ (BOOL)createTable:(NSObject <ZSDBModel>*)model
{
    __block BOOL res = YES;
    [ZSDBManager.share.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *tableName = [model tableName];
        NSArray <ZSDBPropertyModel *>* propertys = [[ZSDBManager share]getPropertys:model];
        NSString *columeAndType = [self.class getColumnAndTypeString:propertys];
        NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(%@);",tableName,columeAndType];
        if (![db executeUpdate:sql]) {
            res = NO;
            *rollback = YES;
            return;
        };
        
        NSMutableArray *columns = [NSMutableArray array];
        FMResultSet *resultSet = [db getTableSchema:tableName];
        while ([resultSet next]) {
            NSString *column = [resultSet stringForColumn:@"name"];
            [columns addObject:column];
        }
        NSMutableArray *propertyStrings = @[].mutableCopy;
        for (ZSDBPropertyModel *model in propertys) {
            if (model.mappingKey) {
                [propertyStrings addObject:model.mappingKey];
            } else {
                [propertyStrings addObject:model.originalKey];
            }
        }
        
        NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)",columns];
        //过滤数组
        NSArray *resultArray = [propertyStrings filteredArrayUsingPredicate:filterPredicate];
        for (NSString *column in resultArray) {
            NSUInteger index = [propertyStrings indexOfObject:column];
            NSString *proType = [[propertys objectAtIndex:index] type];
            if (![proType isEqualToString:NSStringFromProtocol(@protocol(ZSDBModel))]) {
                NSString *fieldSql = [NSString stringWithFormat:@"%@ %@",column,proType];
                NSString *sql = [NSString stringWithFormat:@"ALTER TABLE %@ ADD COLUMN %@ ",[model tableName],fieldSql];
                if (![db executeUpdate:sql]) {
                    res = NO;
                    *rollback = YES;
                    return ;
                }
            }
        }
    }];
    
    return res;
}

//- (BOOL)saveOrUpdate:(NSObject <ZSDBModel>*)model {
//    NSString *primaryKey = [model primaryKey];
//    id primaryValue = [model valueForKey:primaryKey];
//    if ([primaryValue intValue] <= 0) {
//        return [self save];
//    }
//    return [self update];
//}

- (BOOL)save:(NSObject <ZSDBModel>*)model
{
    NSString *tableName = [model tableName];
    NSMutableString *keyString = [NSMutableString string];
    NSMutableString *valueString = [NSMutableString string];
    NSMutableArray *insertValues = [NSMutableArray  array];
    NSArray <ZSDBPropertyModel* >*columns = [self getPropertys:model];
    for (int i = 0; i < columns.count; i++) {
        NSString *columnName = columns[i].mappingKey ? columns[i].mappingKey:columns[i].originalKey;
        [keyString appendFormat:@"%@,", columnName];
        [valueString appendString:@"?,"];
        id value = [model valueForKey:columnName];
        if (!value) {
            value = @"";
        }
        [insertValues addObject:value];
    }
    
    [keyString deleteCharactersInRange:NSMakeRange(keyString.length - 1, 1)];
    [valueString deleteCharactersInRange:NSMakeRange(valueString.length - 1, 1)];
    __block BOOL res = NO;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@(%@) VALUES (%@);", tableName, keyString, valueString];
        res = [db executeUpdate:sql withArgumentsInArray:insertValues];
        NSLog(res?@"插入成功":@"插入失败");
    }];
    return res;
}

/** 批量保存用户对象 */
+ (BOOL)saveObjects:(NSArray <ZSDBModel>*)array
{
    __block BOOL res = YES;
    // 如果要支持事务
    [ZSDBManager.share.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        for (NSObject <ZSDBModel>*model in array) {
            NSString *tableName = [model tableName];
            NSMutableString *keyString = [NSMutableString string];
            NSMutableString *valueString = [NSMutableString string];
            NSMutableArray *insertValues = [NSMutableArray  array];
            NSArray <ZSDBPropertyModel* >*columns = [ZSDBManager.share getPropertys:model];
            for (int i = 0; i < columns.count; i++) {
                NSString *columnName = columns[i].mappingKey ? columns[i].mappingKey:columns[i].originalKey;
                [keyString appendFormat:@"%@,", columnName];
                [valueString appendString:@"?,"];
                id value = [model valueForKey:columnName];
                if (!value) {
                    value = @"";
                }
                [insertValues addObject:value];
            }
            [keyString deleteCharactersInRange:NSMakeRange(keyString.length - 1, 1)];
            [valueString deleteCharactersInRange:NSMakeRange(valueString.length - 1, 1)];
            
            NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@(%@) VALUES (%@);", tableName, keyString, valueString];
            BOOL flag = [db executeUpdate:sql withArgumentsInArray:insertValues];
            NSLog(flag?@"插入成功":@"插入失败");
            if (!flag) {
                res = NO;
                *rollback = YES;
                return;
            }
        }
    }];
    return res;
}

/** 更新单个对象 */
- (BOOL)update:(NSObject <ZSDBModel>*)model
{
    __block BOOL res = NO;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *tableName = [model tableName];
        id primaryValue = [model valueForKey:[model primaryKey]];
        if (!primaryValue || primaryValue <= 0) {
            return ;
        }
        NSMutableString *keyString = [NSMutableString string];
        NSMutableArray *updateValues = [NSMutableArray  array];
        NSArray <ZSDBPropertyModel* >*columns = [ZSDBManager.share getPropertys:model];
        for (int i = 0; i < columns.count; i++) {
            NSString *columnName = columns[i].mappingKey ? columns[i].mappingKey:columns[i].originalKey;
            [keyString appendFormat:@" %@=?,", columnName];
            id value = [model valueForKey:columnName];
            if (!value) {
                value = @"";
            }
            [updateValues addObject:value];
        }
        
        //删除最后那个逗号
        [keyString deleteCharactersInRange:NSMakeRange(keyString.length - 1, 1)];
        NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE %@ = ?;", tableName, keyString, primaryId];
        [updateValues addObject:primaryValue];
        res = [db executeUpdate:sql withArgumentsInArray:updateValues];
        NSLog(res?@"更新成功":@"更新失败");
    }];
    return res;
}

/** 批量更新用户对象*/
+ (BOOL)updateObjects:(NSArray <ZSDBModel>*)array
{
    __block BOOL res = YES;
    // 如果要支持事务
    [ZSDBManager.share.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        for (NSObject <ZSDBModel>*model in array) {
            id primaryValue = [model valueForKey:[model primaryKey]];
            if (!primaryValue || primaryValue <= 0) {
                res = NO;
                *rollback = YES;
                return;
            }
            
            NSMutableString *keyString = [NSMutableString string];
            NSMutableArray *updateValues = [NSMutableArray  array];
            NSArray <ZSDBPropertyModel* >*columns = [ZSDBManager.share getPropertys:model];
            for (int i = 0; i < columns.count; i++) {
                NSString *columnName = columns[i].mappingKey ? columns[i].mappingKey:columns[i].originalKey;
                [keyString appendFormat:@" %@=?,", columnName];
                id value = [model valueForKey:columnName];
                if (!value) {
                    value = @"";
                }
                [updateValues addObject:value];
            }
            
            //删除最后那个逗号
            [keyString deleteCharactersInRange:NSMakeRange(keyString.length - 1, 1)];
            NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE %@=?;", [model tableName], keyString, [model primaryKey]];
            [updateValues addObject:primaryValue];
            BOOL flag = [db executeUpdate:sql withArgumentsInArray:updateValues];
            NSLog(flag?@"更新成功":@"更新失败");
            if (!flag) {
                res = NO;
                *rollback = YES;
                return;
            }
        }
    }];
    
    return res;
}

/** 删除单个对象 */
- (BOOL)deleteObject:(NSObject <ZSDBModel>*)model
{
    __block BOOL res = NO;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *tableName = [model tableName];
        id primaryValue = [model valueForKey:[model primaryKey]];
        if (!primaryValue || primaryValue <= 0) {
            return ;
        }
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = ?",tableName,[model primaryKey]];
        res = [db executeUpdate:sql withArgumentsInArray:@[primaryValue]];
        NSLog(res?@"删除成功":@"删除失败");
    }];
    return res;
}

/** 批量删除用户对象 */
+ (BOOL)deleteObjects:(NSArray <ZSDBModel>*)array
{
    __block BOOL res = YES;
    // 如果要支持事务
    [ZSDBManager.share.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        for (NSObject <ZSDBModel>*model in array) {
            NSString *tableName = [model tableName];
            id primaryValue = [model valueForKey:[model primaryKey]];
            if (!primaryValue || primaryValue <= 0) {
                return ;
            }
            
            NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = ?",tableName,[model primaryKey]];
            BOOL flag = [db executeUpdate:sql withArgumentsInArray:@[primaryValue]];
            NSLog(flag?@"删除成功":@"删除失败");
            if (!flag) {
                res = NO;
                *rollback = YES;
                return;
            }
        }
    }];
    return res;
}

/** 通过条件删除数据 */
+ (BOOL)deleteObjectsByCriteria:(NSString *)criteria model:(NSObject <ZSDBModel>*)model
{
    __block BOOL res = NO;
    [ZSDBManager.share.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *tableName = [model tableName];
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ %@ ",tableName,criteria];
        res = [db executeUpdate:sql];
        NSLog(res?@"删除成功":@"删除失败");
    }];
    return res;
}

/** 通过条件删除 (多参数）--2 */
+ (BOOL)deleteObjectsWithModel:(NSObject <ZSDBModel>*)model Format:(NSString *)format, ...
{
    va_list ap;
    va_start(ap, format);
    NSString *criteria = [[NSString alloc] initWithFormat:format locale:[NSLocale currentLocale] arguments:ap];
    va_end(ap);
    
    return [self deleteObjectsByCriteria:criteria model:model];
}

/** 清空表 */
+ (BOOL)clearTable:(NSObject <ZSDBModel>*)model
{
    __block BOOL res = NO;
    [ZSDBManager.share.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *tableName = [model tableName];
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@",tableName];
        res = [db executeUpdate:sql];
        NSLog(res?@"清空成功":@"清空失败");
    }];
    return res;
}

- (NSArray *)queryAll:(NSObject <ZSDBModel>*)model {
    NSLog(@"ZSDBModel---%s",__func__);
    NSMutableArray *models = [NSMutableArray array];
    [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        NSString *tableName = [model tableName];
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@",tableName];
        FMResultSet *resultSet = [db executeQuery:sql];
        while ([resultSet next]) {
            Class modelClass = [model class];
            NSObject <ZSDBModel>*queryModel = [[modelClass alloc] init];
            NSArray <ZSDBPropertyModel* >*columns = [self getPropertys:queryModel];
            for (NSInteger i = 0; i< columns.count; i++) {
                NSString *columnName = columns[i].mappingKey ? columns[i].mappingKey:columns[i].originalKey;
                NSString *columnType = columns[i].type;
                if ([columnType isEqualToString:SQLTEXT]) {
                    [queryModel setValue:[resultSet stringForColumn:columnName] forKey:columnName];
                } else if ([columnType isEqualToString:SQLBLOB]) {
                    [queryModel setValue:[resultSet dataForColumn:columnName] forKey:columnName];
                } else if ([columnName isEqualToString:NSStringFromProtocol(@protocol(ZSDBModel))]) {
                    // 单独查询这个表即可
                } else {
                    [queryModel setValue:[NSNumber numberWithLongLong:[resultSet longLongIntForColumn:columnName]] forKey:columnName];
                }
            }
            [models addObject:queryModel];
            FMDBRelease(queryModel);
        }
    }];
    return models;
}

/** 查找某条数据 */
+ (instancetype)findFirstByCriteria:(NSString *)criteria model:(NSObject <ZSDBModel> *)model
{
    NSArray *results = [ZSDBManager findByCriteria:criteria model:model];
    if (results.count < 1) {
        return nil;
    }
    
    return [results firstObject];
}

+ (instancetype)findByPK:(int)inPk model:(NSObject <ZSDBModel> *)model
{
    NSString *condition = [NSString stringWithFormat:@"WHERE %@=%d",primaryId,inPk];
    return [self findFirstByCriteria:condition model:model];
}

+ (NSArray *)findWithModel:(NSObject <ZSDBModel> *)model Format:(NSString *)format, ...
{
    va_list ap;
    va_start(ap, format);
    NSString *criteria = [[NSString alloc] initWithFormat:format locale:[NSLocale currentLocale] arguments:ap];
    va_end(ap);
    return [self findByCriteria:criteria model:model];
}

/** 通过条件查找数据 */
+ (NSArray *)findByCriteria:(NSString *)criteria model:(NSObject <ZSDBModel> *)model
{
    NSMutableArray *users = [NSMutableArray array];
    [ZSDBManager.share.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *tableName = [model tableName];
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ %@",tableName,criteria];
        FMResultSet *resultSet = [db executeQuery:sql];
        while ([resultSet next]) {
            NSObject <ZSDBModel> *result = [[[model class] alloc] init];
            NSArray <ZSDBPropertyModel* >*columns = [ZSDBManager.share getPropertys:result];
            for (int i=0; i< columns.count; i++) {
                NSString *columnName = columns[i].mappingKey ? columns[i].mappingKey:columns[i].originalKey;
                NSString *columnType = columns[i].type;
                if ([columnType isEqualToString:SQLTEXT]) {
                    [result setValue:[resultSet stringForColumn:columnName] forKey:columnName];
                } else if ([columnType isEqualToString:SQLBLOB]) {
                    [result setValue:[resultSet dataForColumn:columnName] forKey:columnName];
                } else if ([columnName isEqualToString:NSStringFromProtocol(@protocol(ZSDBModel))]) {
                    // 单独查询这个表即可
                } else {
                    [result setValue:[NSNumber numberWithLongLong:[resultSet longLongIntForColumn:columnName]] forKey:columnName];
                }
            }
            [users addObject:model];
            FMDBRelease(model);
        }
    }];
    
    return users;
}


- (NSArray <ZSDBPropertyModel *>*)getPropertys:(NSObject <ZSDBModel>*)model {
    NSString *foreignKey;
    NSString *primaryKey;
    NSDictionary <NSString *,NSString *> *mapping;
    NSArray <NSString *>*ignoredKeys;
    mapping = [model dbColumnMapping];
    primaryKey = [model primaryKey];
    foreignKey = [model foreignKey];
    ignoredKeys = [model ignoredKeys];
    NSMutableArray *propertys = @[].mutableCopy;
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([model class], &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        //获取属性名
        NSString *propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        // 如果在忽略列表中,不处理
        if ([ignoredKeys containsObject:propertyName]) {
            continue;
        }
        id propertyValue = [model valueForKey:propertyName];
        ZSDBPropertyModel *propertyModel = [[ZSDBPropertyModel alloc] init];
        propertyModel.originalKey = propertyName;
        propertyModel.value = propertyValue;
        
        if (mapping[propertyName]) {
            propertyModel.mappingKey = mapping[propertyName];
        }
        if ([propertyName isEqualToString:primaryKey]) {
            propertyModel.isPrimaryKey = YES;
        } else {
            propertyModel.isPrimaryKey = NO;
        }
        
        if ([propertyValue conformsToProtocol:@protocol(ZSDBModel)]) {
            propertyModel.type = [NSString stringWithFormat:@"%@",@protocol(ZSDBModel)];
            propertyModel.value = [self getPropertys:propertyValue];
            continue;
        }
        //获取属性类型等参数
        NSString *propertyType = [NSString stringWithCString: property_getAttributes(property) encoding:NSUTF8StringEncoding];
        /*
         各种符号对应类型，部分类型在新版SDK中有所变化，如long 和long long
         c char         C unsigned char
         i int          I unsigned int
         l long         L unsigned long
         s short        S unsigned short
         d double       D unsigned double
         f float        F unsigned float
         q long long    Q unsigned long long
         B BOOL
         @ 对象类型 //指针 对象类型 如NSString 是@“NSString”
         
         
         64位下long 和long long 都是Tq
         SQLite 默认支持五种数据类型TEXT、INTEGER、REAL、BLOB、NULL
         因为在项目中用的类型不多，故只考虑了少数类型
         */
        if ([propertyType hasPrefix:@"T@\"NSString\""]) {
            propertyModel.type = SQLTEXT;
        } else if ([propertyType hasPrefix:@"T@\"NSData\""]) {
            propertyModel.type = SQLBLOB;
        } else if ([propertyType hasPrefix:@"Ti"]||[propertyType hasPrefix:@"TI"]||[propertyType hasPrefix:@"Ts"]||[propertyType hasPrefix:@"TS"]||[propertyType hasPrefix:@"TB"]||[propertyType hasPrefix:@"Tq"]||[propertyType hasPrefix:@"TQ"] || [propertyType hasPrefix:@"T@\"NSNumber\""]) {
            propertyModel.type = SQLINTEGER;
        } else {
            propertyModel.type = SQLREAL;
        }
    }
    return propertys;
}

+ (NSString *)dbPathWithDirectoryName:(NSString *)directoryName
{
    NSString *docsdir = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSFileManager *filemanage = [NSFileManager defaultManager];
    if (directoryName == nil || directoryName.length == 0) {
        docsdir = [docsdir stringByAppendingPathComponent:@"zhuishushenqi"];
    } else {
        docsdir = [docsdir stringByAppendingPathComponent:directoryName];
    }
    BOOL isDir;
    BOOL exit =[filemanage fileExistsAtPath:docsdir isDirectory:&isDir];
    if (!exit || !isDir) {
        [filemanage createDirectoryAtPath:docsdir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *dbpath = [docsdir stringByAppendingPathComponent:@"zssq.sqlite"];
    return dbpath;
}

+ (NSString *)dbPath
{
    return [self dbPathWithDirectoryName:nil];
}

- (FMDatabaseQueue *)dbQueue
{
    if (_dbQueue == nil) {
        _dbQueue = [[FMDatabaseQueue alloc] initWithPath:[self.class dbPath]];
    }
    return _dbQueue;
}

@end
