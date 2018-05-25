//
//  ContactMgr.m
//  Cashnice
//
//  Created by apple on 16/8/1.
//  Copyright © 2016年 l. All rights reserved.
//

#import "ContactMgr.h"
#import <AddressBook/AddressBook.h>
#import "PersonObject.h"
#import "ContactsUploadEngine.h"
#import "Base64EncoderDecoder.h"

static NSString *const CN_UPLOADCONTACTS_KEY = @"CN_UPLOADCONTACTS_KEY";
static NSString *const CONTACTSUPLOAD_USERID_KEY = @"CONTACTSUPLOAD_USERID_KEY";


@implementation ContactEntity {
}
@end


@interface ContactMgr () {
    NSMutableArray *_macthedPhoneNumber;
}
@property (strong,nonatomic) ContactsUploadEngine *engine;
@end

@implementation ContactMgr

#pragma mark - getter

-(ContactsUploadEngine *)engine{
    
    if(!_engine){
        _engine = [[ContactsUploadEngine alloc]init];
    }
    return _engine;
}

-(NSArray *)contactsContainingString:(NSString *)string {
    NSArray *fromName = [self  contactsContainingName:string];
    NSArray *fromNumber = [self  contactsContainingPhoneNumber:string];
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    if (fromName.count > 0) {
        [result addObjectsFromArray:fromName];
    }
    if (fromNumber > 0) {
        [result addObjectsFromArray:fromNumber];
    }
    return result;
}

+(void)requestAuthen:(void (^)(BOOL authened))complete{
    
    if ([[ZAPP.zlogin getSavedPhone] isEqualToString:@"18264153825"]) {
        return;
    }
    NSLog(@"phone=%@", [ZAPP.zlogin getSavedPhone]);
    
    
        
    ABAddressBookRef addressBook = ABAddressBookCreate();
    
    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
        
        if (granted) {
            complete(YES);
        }
        
    });
    
}


+(BOOL)addressBookAuthened{
    
    ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
    return status == kABAuthorizationStatusAuthorized;
}

-(void)readContacts:(void (^)(NSString *))complete{
    
    if ([[ZAPP.zlogin getSavedPhone] isEqualToString:@"18264153825"]) {
        return;
    }
    NSLog(@"phone=%@", [ZAPP.zlogin getSavedPhone]);
    
    
    ABAddressBookRef addressBook = ABAddressBookCreate();
    
    CFArrayRef results = ABAddressBookCopyArrayOfAllPeople(addressBook);
    
    NSArray *ab_contactArray = [(__bridge NSArray *)results copy];
    
    //cvard
    NSError *err;
    NSData *vcardData = [[self class] vCardDataWithAddressBookRecords:ab_contactArray error:&err];
    
    NSString *bs = [[NSString alloc] initWithString:[Base64EncoderDecoder base64Encode:vcardData]];
    
    complete(bs);
    
    if (results) {
        CFRelease(results);
    }
    
}

-(void)allContacts:(void (^)(NSString *))complete{
    
    ABAddressBookRef addressBook = ABAddressBookCreate();
    
    if([[self class] addressBookAuthened]){
        [self readContacts:complete];
    }else{
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            if (granted) {
                [self readContacts:complete];
            }else{
                complete(@"not authened");
            }});
    }

    
    
    
    
    
    /*
     NSMutableString *reformedString = [NSMutableString string];
     
     for (NSInteger index = 0; index<ab_contactArray.count; index++) {
     
     ABRecordRef person = (__bridge ABRecordRef)(ab_contactArray[index]);
     
     //封装姓名
     NSString *personName = (__bridge NSString*)ABRecordCopyValue(person, kABPersonFirstNameProperty);
     NSString *lastname = (__bridge NSString*)ABRecordCopyValue(person, kABPersonLastNameProperty);
     NSMutableString *fullName = [[NSMutableString alloc] init];
     if (lastname) {
     [fullName appendString:lastname];
     }
     if (personName) {
     [fullName appendString:personName];
     }
     
     NSString *address = [self trimSpecialCharacter: EMPTYSTRING_HANDLE( (__bridge NSString*)ABRecordCopyValue(person, kABPersonAddressProperty))];
     NSString *jobtitle =[self trimSpecialCharacter:  EMPTYSTRING_HANDLE( (__bridge NSString*)ABRecordCopyValue(person, kABPersonJobTitleProperty))];
     NSString *org = [self trimSpecialCharacter: EMPTYSTRING_HANDLE((__bridge NSString*)ABRecordCopyValue(person, kABPersonOrganizationProperty))];
     
     if (index != 0) {
     [reformedString appendString:@"$~$"];
     }
     
     ///////处理多个号码
     ABMultiValueRef phoneNumbers = ABRecordCopyValue(person, kABPersonPhoneProperty);
     for (CFIndex i = 0; i < ABMultiValueGetCount(phoneNumbers); i++) {
     NSString *contactPhoneNumber = (__bridge_transfer NSString *) ABMultiValueCopyValueAtIndex(phoneNumbers, i);
     contactPhoneNumber = [[contactPhoneNumber componentsSeparatedByCharactersInSet:[[NSCharacterSet alphanumericCharacterSet] invertedSet]] componentsJoinedByString:@""];
     
     if (i != 0) {
     [reformedString appendString:@"$~$"];
     }
     
     [reformedString appendString:fullName];
     [reformedString appendString:@"^"];
     [reformedString appendString:contactPhoneNumber];
     [reformedString appendString:@"^"];
     [reformedString appendString:address];
     [reformedString appendString:@"^"];
     [reformedString appendString:jobtitle];
     [reformedString appendString:@"^"];
     [reformedString appendString:org];
     
     
     }
     
     
     lastname = nil;
     personName = nil;
     address = nil;
     jobtitle = nil;
     org = nil;
     }
     
     ab_contactArray = nil;
     complete(reformedString);
     
     */
    
}

-(NSArray *)contactsContainingName:(NSString *)name{
    
    ABAddressBookRef addressBook = ABAddressBookCreate();
    
    
    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {});
    
    CFArrayRef results = ABAddressBookCopyPeopleWithName(addressBook, (__bridge CFStringRef)name);
    
    NSArray *contactArray = [(__bridge NSArray *)results copy];
    
    //    return [self extractEntitiesFromArray:array];
    
    NSMutableArray *entities = [[NSMutableArray alloc] initWithCapacity:contactArray.count];
    
    for(int i = 0; i < contactArray.count; i++){
        ABRecordRef person = (__bridge ABRecordRef)(contactArray[i]);
        
        
        ///////处理多个号码
        ABMultiValueRef phoneNumbers = ABRecordCopyValue(person, kABPersonPhoneProperty);
        for (CFIndex i = 0; i < ABMultiValueGetCount(phoneNumbers); i++) {
            NSString *contactPhoneNumber = (__bridge_transfer NSString *) ABMultiValueCopyValueAtIndex(phoneNumbers, i);
            contactPhoneNumber = [[contactPhoneNumber componentsSeparatedByCharactersInSet:[[NSCharacterSet alphanumericCharacterSet] invertedSet]] componentsJoinedByString:@""];
            
            NSString *personName = (__bridge NSString*)ABRecordCopyValue(person, kABPersonFirstNameProperty);
            NSString *lastname = (__bridge NSString*)ABRecordCopyValue(person, kABPersonLastNameProperty);
            
            NSData *imageData = (__bridge NSData *)ABPersonCopyImageData(person);
            UIImage *headImage = [UIImage imageWithData:imageData];
            
            NSMutableString *fullName = [[NSMutableString alloc] init];
            if (lastname) {
                [fullName appendString:lastname];
            }
            if (personName) {
                [fullName appendString:personName];
            }
            
            PersonObject *entity = [[PersonObject alloc] init];
            entity.userrealname = fullName;
            entity.phone = contactPhoneNumber;
            entity.isContact = YES;
            if (headImage) {
                entity.headImage = headImage;
            }
            
            [entities addObject:entity];
            
            
        }
        CFRelease(phoneNumbers);
        
        
    }
    return entities;
    
    
    //    for(int i = 0; i < CFArrayGetCount(results); i++)
    //    {
    //        ABRecordRef person = CFArrayGetValueAtIndex(results, i);
    //        NSString *personName = (__bridge NSString*)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    //        NSString *lastname = (__bridge NSString*)ABRecordCopyValue(person, kABPersonLastNameProperty);
    //        NSLog(@"-----%@ %@", lastname, personName);
    //
    //
    //        //读取电话多值
    //        ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
    //        for (int k = 0; k<ABMultiValueGetCount(phone); k++)
    //        {
    //            //获取电话Label
    //            NSString * personPhoneLabel = (__bridge NSString*)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(phone, k));
    //            //获取該Label下的电话值
    //            NSString * personPhone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phone, k);
    //            NSLog(@"-----%@ %@", personPhoneLabel, personPhone);
    //
    //        }
    //
    //    }
}


-(NSArray *)contactsContainingPhoneNumber:(NSString *)phoneNumber {
    _macthedPhoneNumber = [[NSMutableArray alloc] init];
    
    /*
     
     Returns an array of contacts that contain the phone number
     
     */
    
    // Remove non numeric characters from the phone number
    phoneNumber = [[phoneNumber componentsSeparatedByCharactersInSet:[[NSCharacterSet alphanumericCharacterSet] invertedSet]] componentsJoinedByString:@""];
    
    if (phoneNumber.length < 1) {
        return [NSArray array];
    }
    
    // Create a new address book object with data from the Address Book database
    CFErrorRef error = nil;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    if (!addressBook) {
        return [NSArray array];
    } else if (error) {
        CFRelease(addressBook);
        return [NSArray array];
    }
    
    // Requests access to address book data from the user
    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {});
    
    // Build a predicate that searches for contacts that contain the phone number
    NSPredicate *predicate = [NSPredicate predicateWithBlock: ^(id record, NSDictionary *bindings) {
        ABMultiValueRef phoneNumbers = ABRecordCopyValue( (__bridge ABRecordRef)record, kABPersonPhoneProperty);
        BOOL result = NO;
        for (CFIndex i = 0; i < ABMultiValueGetCount(phoneNumbers); i++) {
            NSString *contactPhoneNumber = (__bridge_transfer NSString *) ABMultiValueCopyValueAtIndex(phoneNumbers, i);
            contactPhoneNumber = [[contactPhoneNumber componentsSeparatedByCharactersInSet:[[NSCharacterSet alphanumericCharacterSet] invertedSet]] componentsJoinedByString:@""];
            if ([contactPhoneNumber rangeOfString:phoneNumber].location != NSNotFound) {
                [_macthedPhoneNumber addObject:contactPhoneNumber];
                result = YES;
                break;
            }
        }
        CFRelease(phoneNumbers);
        return result;
    }];
    
    // Search the users contacts for contacts that contain the phone number
    NSArray *allPeople = (NSArray *)CFBridgingRelease(ABAddressBookCopyArrayOfAllPeople(addressBook));
    NSArray *filteredContacts = [allPeople filteredArrayUsingPredicate:predicate];
    CFRelease(addressBook);
    
    return [self extractEntitiesFromArray:filteredContacts];
}


-(NSArray *)extractEntitiesFromArray:(NSArray *)contactArray {
    
    NSMutableArray *entities = [[NSMutableArray alloc] initWithCapacity:contactArray.count];
    
    for(int i = 0; i < contactArray.count; i++){
        ABRecordRef person = (__bridge ABRecordRef)(contactArray[i]);
        
        NSString *personName = (__bridge NSString*)ABRecordCopyValue(person, kABPersonFirstNameProperty);
        NSString *lastname = (__bridge NSString*)ABRecordCopyValue(person, kABPersonLastNameProperty);
        
        //kABPersonImageFormatThumbnail
        //ABPersonCopyImageData
        //NSData *imageData = (__bridge NSData *)ABRecordCopyValue(person, kABPersonImageFormatThumbnail);
        
        NSData *imageData = (__bridge NSData *)ABPersonCopyImageData(person);
        UIImage *headImage = [UIImage imageWithData:imageData];
        
        NSMutableString *fullName = [[NSMutableString alloc] init];
        if (lastname) {
            [fullName appendString:lastname];
        }
        if (personName) {
            [fullName appendString:personName];
        }
        
        //        ContactEntity *entity = [[ContactEntity alloc] init];
        //        entity.name = fullName;
        //        entity.headImage = headImage;
        
        PersonObject *entity = [[PersonObject alloc] init];
        entity.userrealname = fullName;
        entity.isContact = YES;
        if (_macthedPhoneNumber.count > i) {
            entity.phone = _macthedPhoneNumber[i];
        }
        if (headImage) {
            entity.headImage = headImage;
        }
        
        [entities addObject:entity];
        
        ///NSLog(@"-----%@ ", fullName);
        
    }
    return entities;
}

#pragma mark - upload

-(BOOL)needUploadContacts{
    
    if ([[ZAPP.zlogin getSavedPhone] isEqualToString:@"18264153825"]) {
        return NO;
    }
    
    //是否开启通讯录上传
    if (![ZAPP.myuser allowedContactsUpload]) {
        return NO;
    }
    
    NSInteger interval = [ZAPP.myuser getContactsUploadInterval];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:CN_UPLOADCONTACTS_KEY]) {
        //最后记录的日期
        NSDate *lastRecordDate = [[NSUserDefaults standardUserDefaults] objectForKey:CN_UPLOADCONTACTS_KEY];
        
        //处理以前的老数据
        if(lastRecordDate && ![lastRecordDate isKindOfClass:[NSDate class]]){
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:CN_UPLOADCONTACTS_KEY];
            return YES;
        }
        
        //还是同一个人
        if ([[NSUserDefaults standardUserDefaults] objectForKey:CONTACTSUPLOAD_USERID_KEY] && [[[NSUserDefaults standardUserDefaults] objectForKey:CONTACTSUPLOAD_USERID_KEY] integerValue] == [[ZAPP.myuser getUserID] integerValue]) {
            
            //没超过7天，就不在重复上传了
            if([[lastRecordDate dateByAddingTimeInterval:interval*24*3600] compare:[NSDate date]] != NSOrderedAscending){
                return NO;
            }
            
            
        }
        
        
    }
    return YES;
}

-(void)uploadContacts:(void (^)(NSString *error))completeBlock{
    
    if ([self needUploadContacts]) {
        DLog();
        
        [self allContacts:^(NSString *contactsString) {
            [self.engine uploadContacts:contactsString
                                 userid:[[ZAPP.myuser getUserID] integerValue]
                                success:^() {
                                    DLog(@"上传成功");
                                    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:CN_UPLOADCONTACTS_KEY];
                                    [[NSUserDefaults standardUserDefaults] setObject:@([[ZAPP.myuser getUserID] integerValue]) forKey:CONTACTSUPLOAD_USERID_KEY];
                                    
                                    if(completeBlock){
                                        completeBlock(nil);
                                    }
                                    
                                } failure:^(NSString *error) {
                                    DDLogError(@"error=%@",error);
                                    
                                    if(completeBlock){
                                        completeBlock(error);
                                    }
                                    
                                    
                                }];
            
        }];
    }else{
        if(completeBlock){
            completeBlock(nil);
        }
    }
    
}

-(NSString *)trimSpecialCharacter:(NSString *)originalString{
    
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"^$"];
    
    NSString *trimStr = [originalString stringByTrimmingCharactersInSet:set];
    
    NSLog(@"trimStr = %@", trimStr);
    return  trimStr;
}

+ (NSData *)vCardDataWithAddressBookRecords:(NSArray *)records
                                      error:(NSError * __autoreleasing *)error
{
    CFDataRef data = ABPersonCreateVCardRepresentationWithPeople((__bridge CFArrayRef)records);
    
    return (__bridge_transfer NSData *)data;
}

@end


