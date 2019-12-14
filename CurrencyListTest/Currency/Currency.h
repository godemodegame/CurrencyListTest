#import <Foundation/Foundation.h>

@interface Currency : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *currency;
@property (strong, nonatomic) NSString *amount;
@property (strong, nonatomic) NSString *changePercent;
@property (strong, nonatomic) NSString *symbol;

@end
