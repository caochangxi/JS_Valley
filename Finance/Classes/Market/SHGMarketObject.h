//
//  SHGMarketObject.h
//  Finance
//
//  Created by changxicao on 15/12/10.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHGMarketObject : MTLModel<MTLJSONSerializing>
@property (strong, nonatomic) NSString *loginuserstate;
@property (strong, nonatomic) NSString *price;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *company;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *status;
@property (strong, nonatomic) NSString *headimageurl;
@property (strong, nonatomic) NSString *marketName;
@property (strong, nonatomic) NSString *realname;
@property (strong, nonatomic) NSString *marketId;
@property (strong, nonatomic) NSString *contactInfo;
@property (strong, nonatomic) NSString *detail;
@property (strong, nonatomic) NSString *commentNum;
@property (strong, nonatomic) NSString *createBy;
@property (strong, nonatomic) NSString *praiseNum;
@property (strong, nonatomic) NSString *createTime;
@property (strong, nonatomic) NSString *shareNum;
@property (strong, nonatomic) NSString *friendShip;
@property (strong, nonatomic) NSString *catalog;
@property (strong, nonatomic) NSString *firstcatalog;
@property (strong, nonatomic) NSString *secondcatalog;
@property (strong, nonatomic) NSString *firstcatalogid;
@property (strong, nonatomic) NSString *secondcatalogid;
@property (strong, nonatomic) NSString *isPraise;
@property (assign, nonatomic) BOOL isCollection;
@property (strong, nonatomic) NSString *position;//新增的业务地区
@property (strong, nonatomic) NSMutableArray *praiseList;
@property (strong, nonatomic) NSMutableArray *commentList;
@property (strong, nonatomic) NSString *isDeleted;//是否已经在服务端删除了
@property (strong, nonatomic) NSString *modifyTime;
@property (strong, nonatomic) NSString *anonymous;//是否委托大牛发布
@property (strong, nonatomic) NSString *model;//业务模式
@end



@interface SHGMarketSecondCategoryObject : MTLModel<MTLJSONSerializing>
@property (strong, nonatomic) NSString *parentId;
@property (strong, nonatomic) NSString *secondCatalogId;
@property (strong, nonatomic) NSString *secondCatalogName;
@end

@interface SHGMarketFirstCategoryObject : MTLModel<MTLJSONSerializing>
@property (strong, nonatomic) NSString *firstCatalogId;
@property (strong, nonatomic) NSString *firstCatalogName;
@property (strong, nonatomic) NSString *parentId;
@property (strong, nonatomic) NSArray *secondCataLogs;
@end


@interface SHGMarketCommentObject : MTLModel<MTLJSONSerializing>

@property (strong, nonatomic) NSString *commentId;
@property (strong, nonatomic) NSString *commentUserId;
@property (strong, nonatomic) NSString *commentDetail;
@property (strong, nonatomic) NSString *commentUserName;
@property (strong, nonatomic) NSString *commentOtherName;

- (CGFloat)heightForCell;

@end

@interface SHGMarketCityObject : MTLModel<MTLJSONSerializing>

@property (strong, nonatomic) NSString *cityId;
@property (strong, nonatomic) NSString *cityName;

@end

@interface SHGMarketSelectedObject : MTLModel<MTLJSONSerializing>

@property (strong, nonatomic) NSString *catalogId;

@end


typedef NS_ENUM(NSInteger, SHGMarketNoticeType)
{
    SHGMarketNoticeTypePositionTop = 0,
    SHGMarketNoticeTypePositionAny
};

@interface SHGMarketNoticeObject : SHGMarketObject

@property (strong, nonatomic) NSString *tipUrl;
@property (assign, nonatomic) SHGMarketNoticeType type;

@end
