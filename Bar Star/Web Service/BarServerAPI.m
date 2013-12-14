//  Created by Newline Analytics Inc. on 01/08/13.
//  Copyright (c) 2013 Connor Curran. All rights reserved.

#import "BarServerAPI.h"
#import "BarDetailViewController.h"

@implementation BarServerAPI

@synthesize serverAPIDelegate;
static BarServerAPI *objServerAPI = nil;


+(void) Initialize
{
    if(objServerAPI)
    {
        [objServerAPI release];
        objServerAPI = nil;
    }
    
    objServerAPI = [[BarServerAPI alloc] init];
    objServerAPI->m_nServerCall = -1;
    
}

+(void) Uninitialize
{
    objServerAPI->m_nServerCall = -1;
    if(objServerAPI)
    {
        [objServerAPI release];
        objServerAPI = nil;
    }
}

+(void) SetDelegate :(id) delegate
{
    objServerAPI->serverAPIDelegate = delegate;
}

+(void)API_InsertWithFbookId:(NSString *)fbookId withDelegate:(id)delegate withFbookName:(NSString *)fbookName withDate:(NSString *)date withDeviceId:(NSString *)deviceId
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@command=insertFbookID&fbookID=%@&deviceID=%@&fbookName=%@&dateTime=%@",SERVER_ADDRESS,kMainURL,fbookId,deviceId,fbookName,date];
    
    objServerAPI->serverAPIDelegate = delegate;
    
//    NSLog(@"URL: %@", urlString);
    
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    dispatch_async(kBackGroudQueue, ^{
        
        NSData* data = [NSData dataWithContentsOfURL: url];
        
        [self performSelectorOnMainThread:@selector(receiveInsertResponse:)
         
                               withObject:data waitUntilDone:YES];
        
    });
    
    
}

+(void)receiveInsertResponse:(NSData *)responseData
{
    NSError* error;
    @try {
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData: responseData  options: NSJSONReadingMutableLeaves error: &error];
//        NSLog(@"json-->%@",JSON);
        //  NSLog(@"error-->%@",error);
        
        NSArray *argsArray =[JSON objectForKey:@"result"];
        
        
//        NSMutableArray *fbookIdArray = [[NSMutableArray alloc]init];
//        
//        for(int i = 0; i < [argsArray count]; i++)
//        {
//            NSDictionary *argsDict = [[NSDictionary alloc] initWithDictionary:[argsArray objectAtIndex:i]];
//            NSString *fbookIdStr = [argsDict objectForKey:@"fbookID"];
//            [fbookIdArray addObject:fbookIdStr];
//            
//        }
        
        [objServerAPI->serverAPIDelegate API_CALLBACK_InsertWithFB:argsArray];
//        [fbookIdArray release];
        
    }
    @catch (NSException *exception)
    {
//        NSLog(@"Error-%@",exception.description);
        [objServerAPI->serverAPIDelegate API_CALLBACK_ServerError:@"Server is not responding properly. Please try after some time"];
    }
    
}




+(void)API_RegisterWithFbookId:(NSString *)fbookId withDelegate:(id)delegate
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@command=streamFbook&fbookID=%@",SERVER_ADDRESS,kMainURL,fbookId];
    
    objServerAPI->serverAPIDelegate = delegate;
    
//    NSLog(@"URL: %@", urlString);
    
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    dispatch_async(kBackGroudQueue, ^{
        
        NSData* data = [NSData dataWithContentsOfURL: url];
        
        [self performSelectorOnMainThread:@selector(receiveRegisterResponse:)
         
                               withObject:data waitUntilDone:YES];
        
    });
    

}

+(void)receiveRegisterResponse:(NSData *)responseData
{
    NSError* error;
    @try {
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData: responseData  options: NSJSONReadingMutableLeaves error: &error];
//        NSLog(@"json-->%@",JSON);
        //  NSLog(@"error-->%@",error);
        
        NSArray *argsArray =[JSON objectForKey:@"result"];
        
        
        NSMutableArray *fbookIdArray = [[NSMutableArray alloc]init];
        
        for(int i = 0; i < [argsArray count]; i++)
        {
            NSDictionary *argsDict = [[NSDictionary alloc] initWithDictionary:[argsArray objectAtIndex:i]];
            NSString *fbookIdStr = [argsDict objectForKey:@"fbookID"];
            [fbookIdArray addObject:fbookIdStr];
            
        }
            
        [objServerAPI->serverAPIDelegate API_CALLBACK_RegisterWithFB:fbookIdArray];
        [fbookIdArray release];
        
    }
    @catch (NSException *exception)
    {
        NSLog(@"Error-%@",exception.description);
        [objServerAPI->serverAPIDelegate API_CALLBACK_ServerError:@"Server is not responding properly. Please try after some time"];
    }

}


+(void)API_RegisterDeviceId:(NSString *)deviceId withDelegate:(id)delegate
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@command=streamFbook2&deviceID=%@",SERVER_ADDRESS,kMainURL,deviceId];
    
    objServerAPI->serverAPIDelegate = delegate;
    
//    NSLog(@"URL: %@", urlString);
    
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    dispatch_async(kBackGroudQueue, ^{
        
        NSData* data = [NSData dataWithContentsOfURL: url];
        
        [self performSelectorOnMainThread:@selector(receiveRegisterDeviceResponse:)
         
                               withObject:data waitUntilDone:YES];
        
    });

}
+(void)receiveRegisterDeviceResponse:(NSData *)responseData
{
    NSError* error;
    @try {
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData: responseData  options: NSJSONReadingMutableLeaves error: &error];
//        NSLog(@"json-->%@",JSON);
        //  NSLog(@"error-->%@",error);
        
        NSArray *argsArray =[JSON objectForKey:@"result"];
        
        NSDictionary *argsDict = [[NSDictionary alloc] initWithDictionary:[argsArray objectAtIndex:0]];
                   
        
        [objServerAPI->serverAPIDelegate API_CALLBACK_RegisgterDevice:argsDict];
        [argsDict release];
        
    
        
    }
    @catch (NSException *exception)
    {
        NSLog(@"Error-%@",exception.description);
        [objServerAPI->serverAPIDelegate API_CALLBACK_ServerError:@"Server is not responding properly. Please try after some time"];
    }

}

+(void)API_GetAllbarDetails:(id)delegate
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@command=stream2",SERVER_ADDRESS,kMainURL];
    
    objServerAPI->serverAPIDelegate = delegate;
    
//    NSLog(@"URL: %@", urlString);
    
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    dispatch_async(kBackGroudQueue, ^{
        
        NSData* data = [NSData dataWithContentsOfURL: url];
        
        [self performSelectorOnMainThread:@selector(receiveGetAllBarDetails:)
         
                               withObject:data waitUntilDone:YES];
        
    });
    
}
+(void)receiveGetAllBarDetails:(NSData *)responseData
{
    NSError* error;
    @try {
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData: responseData  options: NSJSONReadingMutableLeaves error: &error];
//        NSLog(@"json-->%@",JSON);
        //  NSLog(@"error-->%@",error);
        
        NSArray *argsArray =[JSON objectForKey:@"result"];
        
        NSMutableArray *streamArray = [[NSMutableArray alloc]init];
        
        for(int i = 0 ; i < [argsArray count]; i++)
        {
            NSMutableDictionary *dict = [argsArray objectAtIndex:i];
            StreamEntity *entity = [[StreamEntity alloc]initWithDictionary:dict];
            [streamArray addObject:entity];
            [entity release];
            
            
        }
        
        [objServerAPI->serverAPIDelegate API_CALLBACK_GetAllBars:streamArray];
        [streamArray release];
        
        
        
    }
    @catch (NSException *exception)
    {
        NSLog(@"Error-%@",exception.description);
        [objServerAPI->serverAPIDelegate API_CALLBACK_ServerError:@"Server is not responding properly. Please try after some time"];
    }
    
}


+(void)API_GetAllBarImagesWithDelegate:(id)delegate
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@command=stream",SERVER_ADDRESS,kMainURL];
    
    objServerAPI->serverAPIDelegate = delegate;
    
//    NSLog(@"URL: %@", urlString);
    
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    dispatch_async(kBackGroudQueue, ^{
        
        NSData* data = [NSData dataWithContentsOfURL: url];
        
        [self performSelectorOnMainThread:@selector(receiveAllBarImages:)
         
                               withObject:data waitUntilDone:YES];
        
    });
    
}
+(void)receiveAllBarImages:(NSData *)responseData
{
    NSError* error;
    @try {
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData: responseData  options: NSJSONReadingMutableLeaves error: &error];
//        NSLog(@"json-->%@",JSON);
        //  NSLog(@"error-->%@",error);
        
        NSArray *argsArray =[JSON objectForKey:@"result"];
        
        [objServerAPI->serverAPIDelegate API_CALLBACK_GetAllImages:argsArray];
         
    }
    @catch (NSException *exception)
    {
        NSLog(@"Error-%@",exception.description);
        [objServerAPI->serverAPIDelegate API_CALLBACK_ServerError:@"Server is not responding properly. Please try after some time"];
    }
    
}

+(void)API_GetAllReviews:(id)delegate forBarName:(NSString *)barname
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@command=stream3&barName=%@",SERVER_ADDRESS,kMainURL,barname];
    
    objServerAPI->serverAPIDelegate = delegate;
    
//    NSLog(@"URL: %@", urlString);
    
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    dispatch_async(kBackGroudQueue, ^{
        
        NSData* data = [NSData dataWithContentsOfURL: url];
        
        [self performSelectorOnMainThread:@selector(receiveAllBarReviews:)
         
                               withObject:data waitUntilDone:YES];
        
    });
    
}
+(void)receiveAllBarReviews:(NSData *)responseData
{
    NSError* error;
    @try {
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData: responseData  options: NSJSONReadingMutableLeaves error: &error];
//        NSLog(@"json-->%@",JSON);
        //  NSLog(@"error-->%@",error);
        
        NSArray *argsArray =[JSON objectForKey:@"result"];
        
//        if([objServerAPI-> serverAPIDelegate isKindOfClass:[BarDetailViewController Class]])
            [objServerAPI->serverAPIDelegate API_CALLBACK_ReviewDetails:argsArray];
        
    }
    @catch (NSException *exception)
    {
        NSLog(@"Error-%@",exception.description);
        [objServerAPI->serverAPIDelegate API_CALLBACK_ServerError:@"Server is not responding properly. Please try after some time"];
    }
    
}

+(void)API_PostReviews:(id)delegate forBarName:(NSString *)barname withReview:(NSString *)review WithTime:(NSString *)dateTime withfbName:(NSString *)fbname
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@command=addRatings2&review=%@&barName=%@&dateTime=%@&fbookName=%@",SERVER_ADDRESS,kMainURL,review,barname,dateTime,fbname];
    //p://184.154.233.9/~stthoma8/SocialNightLifeApp.com/BarStar/index.php?command=addRatings2&review=2&barName=snack%20bar&dateTime=123&fbookName=ad
    objServerAPI->serverAPIDelegate = delegate;
//    
//    NSLog(@"URL: %@", urlString);
    
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    dispatch_async(kBackGroudQueue, ^{
        
        NSData* data = [NSData dataWithContentsOfURL: url];
        
        [self performSelectorOnMainThread:@selector(receivePostReviewResponse:)
         
                               withObject:data waitUntilDone:YES];
        
    });
    
}
+(void)receivePostReviewResponse:(NSData *)responseData
{
    NSError* error;
    @try {
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData: responseData  options: NSJSONReadingMutableLeaves error: &error];
//        NSLog(@"json-->%@",JSON);
        //  NSLog(@"error-->%@",error);
        
        NSArray *argsArray =[JSON objectForKey:@"result"];
        
        [objServerAPI->serverAPIDelegate API_CALLBACK_PostReviewResponse:argsArray];
        
    }
    @catch (NSException *exception)
    {
        NSLog(@"Error-%@",exception.description);
        [objServerAPI->serverAPIDelegate API_CALLBACK_ServerError:@"Server is not responding properly. Please try after some time"];
    }
    
}

+(void)API_GetOverAllVotes:(id)delegate forBarName:(NSString *)barname WithFbookId:(NSString *)fbookId
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@command=streamOveralLikes&barName=%@&barName=%@&fbookID=%@",SERVER_ADDRESS,kMainURL,barname,barname,fbookId];
    
    objServerAPI->serverAPIDelegate = delegate;
    
//    NSLog(@"URL: %@", urlString);
    
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    dispatch_async(kBackGroudQueue, ^{
        
        NSData* data = [NSData dataWithContentsOfURL: url];
        
        [self performSelectorOnMainThread:@selector(receiveOverAllVotesResponse:)
         
                               withObject:data waitUntilDone:YES];
        
    });
    
}
+(void)receiveOverAllVotesResponse:(NSData *)responseData
{
    NSError* error;
    @try {
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData: responseData  options: NSJSONReadingMutableLeaves error: &error];
//        NSLog(@"json-->%@",JSON);
        //  NSLog(@"error-->%@",error);
        
        NSArray *argsArray =[JSON objectForKey:@"result"];
        
        [objServerAPI->serverAPIDelegate API_CALLBACK_OerAllVotes:argsArray];
        
    }
    @catch (NSException *exception)
    {
        NSLog(@"Error-%@",exception.description);
        [objServerAPI->serverAPIDelegate API_CALLBACK_ServerError:@"Server is not responding properly. Please try after some time"];
    }
    
}


+(void)API_UpdateVote:(id)delegate forBarName:(NSString *)barname WithFbookName:(NSString *)fbookName withVote:(NSString *)vote
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@command=likenow&barName=%@&vote=%@&fbookID=%@",SERVER_ADDRESS,kMainURL,barname,vote,fbookName];
    
    objServerAPI->serverAPIDelegate = delegate;
    
//    NSLog(@"URL: %@", urlString);
    
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    dispatch_async(kBackGroudQueue, ^{
        
        NSData* data = [NSData dataWithContentsOfURL: url];
        
        [self performSelectorOnMainThread:@selector(receiveUpdateVotesResponse:)
         
                               withObject:data waitUntilDone:YES];
        
    });
    
}
+(void)receiveUpdateVotesResponse:(NSData *)responseData
{
    NSError* error;
    @try {
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData: responseData  options: NSJSONReadingMutableLeaves error: &error];
//        NSLog(@"json-->%@",JSON);
        //  NSLog(@"error-->%@",error);
        
        NSArray *argsArray =[JSON objectForKey:@"result"];
        
        [objServerAPI->serverAPIDelegate API_CALLBACK_UpdateVotes:argsArray];
        
    }
    @catch (NSException *exception)
    {
        NSLog(@"Error-%@",exception.description);
        [objServerAPI->serverAPIDelegate API_CALLBACK_ServerError:@"Server is not responding properly. Please try after some time"];
    }
    
}

+(void)API_UpdatePercentage:(id)delegate forBarName:(NSString *)barname WithFbookId:(NSString *)fbookId withPercentage:(NSString *)percentage

{
    barname =   [barname stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];

    NSString *urlString = [NSString stringWithFormat:@"%@%@command=updateVotes&barName=%@&percentage=%@&fbookID=%@",SERVER_ADDRESS,kMainURL,barname,percentage,fbookId];
    
    objServerAPI->serverAPIDelegate = delegate;
    
//    NSLog(@"URL: %@", urlString);
    
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    dispatch_async(kBackGroudQueue, ^{
        
        NSData* data = [NSData dataWithContentsOfURL: url];
        
        [self performSelectorOnMainThread:@selector(receiveUpdatePercentageResponse:)
         
                               withObject:data waitUntilDone:YES];
        
    });
    
}
+(void)receiveUpdatePercentageResponse:(NSData *)responseData
{
    NSError* error;
    @try {
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData: responseData  options: NSJSONReadingMutableLeaves error: &error];
//        NSLog(@"json-->%@",JSON);
        //  NSLog(@"error-->%@",error);
        
        NSArray *argsArray =[JSON objectForKey:@"result"];
        
        [objServerAPI->serverAPIDelegate API_CALLBACK_UpdatePercentage:argsArray];
        
    }
    @catch (NSException *exception)
    {
        NSLog(@"Error-%@",exception.description);
        [objServerAPI->serverAPIDelegate API_CALLBACK_ServerError:@"Server is not responding properly. Please try after some time"];
    }
    
}

+(void)API_UndoVote:(id)delegate forBarName:(NSString *)barname WithFbookName:(NSString *)fbookName
{

    NSString *urlString = [NSString stringWithFormat:@"%@%@command=undoVote&barName=%@&fbookID=%@",SERVER_ADDRESS,kMainURL,barname,fbookName];
    
    objServerAPI->serverAPIDelegate = delegate;
    
//    NSLog(@"URL: %@", urlString);
    
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    dispatch_async(kBackGroudQueue, ^{
        
        NSData* data = [NSData dataWithContentsOfURL: url];
        
        [self performSelectorOnMainThread:@selector(receiveUndoVotesResponse:)
         
                               withObject:data waitUntilDone:YES];
        
    });
    
}
+(void)receiveUndoVotesResponse:(NSData *)responseData
{
    NSError* error;
    @try {
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData: responseData  options: NSJSONReadingMutableLeaves error: &error];
//        NSLog(@"json-->%@",JSON);
        //  NSLog(@"error-->%@",error);
        
        NSArray *argsArray =[JSON objectForKey:@"result"];
        
        [objServerAPI->serverAPIDelegate API_CALLBACK_UndoVotes:argsArray];
        
    }
    @catch (NSException *exception)
    {
        NSLog(@"Error-%@",exception.description);
        [objServerAPI->serverAPIDelegate API_CALLBACK_ServerError:@"Server is not responding properly. Please try after some time"];
    }
    
    
    
}



+(void)API_GetSelectedBarImagesWithDelegate:(id)delegate withBarName:(NSString *)barName
{
   barName =   [barName stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
    NSString *urlString = [NSString stringWithFormat:@"%@%@command=streamBarProfile&BarName=%@",SERVER_ADDRESS,kMainURL,barName];
   

    objServerAPI->serverAPIDelegate = delegate;
    
//    NSLog(@"URL: %@", urlString);
    
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    
    
    dispatch_async(kBackGroudQueue, ^{
        
        NSData* data = [NSData dataWithContentsOfURL: url];
        
        [self performSelectorOnMainThread:@selector(receiveBarImagesResponse:)
         
                               withObject:data waitUntilDone:YES];
        
    });
    
}
+(void)receiveBarImagesResponse:(NSData *)responseData
{
    NSError* error;
    @try {
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData: responseData  options: NSJSONReadingMutableLeaves error: &error];
//        NSLog(@"json-->%@",JSON);
        //  NSLog(@"error-->%@",error);
        
        NSArray *argsArray =[JSON objectForKey:@"result"];
        
        [objServerAPI->serverAPIDelegate API_CALLBACK_BarImages:argsArray];
        
    }
    @catch (NSException *exception)
    {
        NSLog(@"Error-%@",exception.description);
        [objServerAPI->serverAPIDelegate API_CALLBACK_ServerError:@"Server is not responding properly. Please try after some time"];
    }
    
    
    
}




+(NSURL*)urlForImageWithId:(NSNumber*)IdPhoto isThumb:(BOOL)isThumb
{
    NSString* urlString = [NSString stringWithFormat:@"%@/%@%@.jpg",
                           kImagePathUrl, IdPhoto, (isThumb)?@"-thumb":@""
                           ];
//    NSLog(@"image url  %@",urlString);
    return [NSURL URLWithString:urlString];
}







@end
@implementation StreamEntity

@synthesize address,barTitle,datetime,latitude,longitude,percentage,photoId,cityName;


-(id)initWithDictionary:(NSMutableDictionary *)dict
{
    self = [super init];
    
    if(self)
    {
    self.barTitle = [dict objectForKey:@"BarName"];
    self.address =[dict objectForKey: @"Address"];
    self.percentage = [dict objectForKey:@"percentage"];
    self.latitude = [dict objectForKey:@"postLat"];
    self.longitude = [dict objectForKey:@"postLon"];
    self.datetime = [dict objectForKey:@"dataLabel"];
        self.datetime = [dict objectForKey:@"city"];

    }
    return self;
    
    
}

@end

