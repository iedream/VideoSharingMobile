//
//  PlistSettingViewController.h
//  
//
//  Created by Catherine Zhao on 2016-03-06.
//
//

#import <UIKit/UIKit.h>
#import "Database.h"

typedef enum fileTypes
{
    FILE_YOUTUBE,
    FILE_OTHER
} FileType;

@interface PlistSettingViewController : UIViewController<UITextFieldDelegate>
//@property (nonatomic, strong) DBRestClient *restClient;
@property (strong, nonatomic) Database *database;
@property (weak, nonatomic) IBOutlet UITextField *groupNameField;
@property (weak, nonatomic) IBOutlet UITextField *fileNameField;
@property (weak, nonatomic) IBOutlet UITextField *fileURLField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *fileTypeSelector;
@property (weak, nonatomic) IBOutlet UISegmentedControl *typePlistSegment;

-(void)setRestClient;
+ (instancetype)sharedInstance;
+(NSDictionary *)getVideoPlaylist:(FileType)fileType;
+(void)populateLocalDictionary;
@end
