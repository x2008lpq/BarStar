//  Created by Newline Analytics Inc. on 01/08/13.
//  Copyright (c) 2013 Connor Curran. All rights reserved.

#import <Foundation/Foundation.h>

#define kBackGroudQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

////184.154.233.9/~stthoma8/SocialNightLifeApp.com/BarStar/index.php?command=streamFbook&fbookID=1438959115
#define SERVER_ADDRESS @"http://184.154.233.9/~stthoma8/SocialNightLifeApp.com/BarStar/"

#define kImagePathUrl @"http://184.154.233.9/~stthoma8/SocialNightLifeApp.com//BarStar/upload/"

#define kMainURL @"index.php?"



@interface StreamEntity : NSObject
{
}
@property(nonatomic,retain) NSString *barTitle;
@property(nonatomic,retain) NSString *address;
@property(nonatomic,retain) NSString *latitude;
@property(nonatomic,retain) NSString *longitude;

@property(nonatomic,retain) NSString *percentage;

@property(nonatomic,retain) NSString *datetime;
@property(nonatomic,retain) NSString *photoId;
@property(nonatomic,retain) NSString *cityName;

-(id) initWithDictionary:(NSMutableDictionary *)dict;



@end


@protocol ServerAPIViewDelegate <NSObject>
@required
- (void)  API_CALLBACK_ServerError:(NSString*)error;

@optional
- (void)  API_CALLBACK_InsertWithFB:(NSArray *)fbookIdArray;

- (void)  API_CALLBACK_RegisterWithFB:(NSMutableArray *)fbookIdArray;
- (void)  API_CALLBACK_RegisgterDevice:(NSDictionary*)fbDict;
-(void) API_CALLBACK_GetAllBars:(NSArray *)barsArray;
-(void) API_CALLBACK_GetAllImages:(NSArray *)barImagesArray;
-(void) API_CALLBACK_ReviewDetails:(NSArray *)reviewArray;
-(void)API_CALLBACK_PostReviewResponse:(NSArray *)responseArray;
-(void)API_CALLBACK_OerAllVotes:(NSArray *)data;
-(void)API_CALLBACK_UpdateVotes:(NSArray *)data;
-(void)API_CALLBACK_UndoVotes:(NSArray *)data;
-(void)API_CALLBACK_BarImages:(NSArray *)data;
-(void)API_CALLBACK_UpdatePercentage:(NSArray *)data;

//-(void)API_CALLBACK_GetStartUpMessages:(NSMutableArray *)data;

@end


@interface BarServerAPI : NSObject
{
    NSInteger m_nServerCall;
    id <ServerAPIViewDelegate> serverAPIDelegate;
}

@property (nonatomic, assign) id <ServerAPIViewDelegate> serverAPIDelegate;

+(void) SetDelegate :(id) delegate;
+(void) Initialize;
+(void) Uninitialize;
+(void) API_InsertWithFbookId:(NSString *)fbookId withDelegate:(id)delegate withFbookName:(NSString *)fbookName withDate:(NSString *)date withDeviceId:(NSString *)deviceId;


+(void) API_RegisterWithFbookId:(NSString *)fbookId withDelegate:(id)delegate;
+(void)API_RegisterDeviceId:(NSString*) deviceId withDelegate:(id)delegate;
+(void)API_GetAllBarImagesWithDelegate:(id)delegate;
+(void)API_GetAllbarDetails:(id)delegate;
+(void)API_GetAllReviews:(id)delegate forBarName:(NSString *)barname;
+(void)API_GetOverAllVotes:(id)delegate forBarName:(NSString *)barname WithFbookId:(NSString *)fbookId ;

+(void)API_GetSelectedBarImagesWithDelegate:(id)delegate withBarName:(NSString *)barName;;

+(void)API_UpdateVote:(id)delegate forBarName:(NSString *)barname WithFbookName:(NSString *)fbookName withVote:(NSString *)vote;

+(void)API_UpdatePercentage:(id)delegate forBarName:(NSString *)barname WithFbookId:(NSString *)fbookId withPercentage:(NSString *)percentage;


+(void)API_UndoVote:(id)delegate forBarName:(NSString *)barname WithFbookName:(NSString *)fbookName;

+(void)API_PostReviews:(id)delegate forBarName:(NSString *)barname withReview:(NSString *)review WithTime:(NSString *)dateTime withfbName:(NSString *)fbname;


+(NSURL*)urlForImageWithId:(NSNumber*)IdPhoto isThumb:(BOOL)isThumb;

+(void) receiveInsertResponse:(NSData *)responseData ;

+(void) receiveRegisterResponse:(NSData *)responseData ;
+(void) receiveRegisterDeviceResponse:(NSData *)responseData;
+(void) receiveGetAllBarDetails:(NSData *)responseData;
+(void) receiveAllBarImages:(NSData *)responseData;
+(void) receiveAllBarReviews:(NSData *)responseData;
+(void) receivePostReviewResponse:(NSData *)responseData;
+(void) receiveOverAllVotesResponse:(NSData *)responseData;
+(void) receiveUpdateVotesResponse:(NSData *)responseData;
+(void) receiveUndoVotesResponse:(NSData *)responseData;
+(void) receiveUpdatePercentageResponse:(NSData *)responseData;

+(void) receiveBarImagesResponse:(NSData *)responseData;

@end

