//
//  PlistSettingViewController.m
//  
//
//  Created by Catherine Zhao on 2016-03-06.
//
//

#import "PlistSettingViewController.h"

@interface PlistSettingViewController ()

@end

@implementation PlistSettingViewController

NSURL *fileURL;
NSString *plistName;
NSMutableDictionary *videoIds;

UIAlertController *emptyGroupName;
UIAlertController *emptyPlaylistFolder;
UIAlertController *uploadSuccess;
UIAlertController *downloadSuccess;
UIAlertController *deleteSuccess;
UIAlertController *deleteError;
UIAlertController *uploadError;
UIAlertController *downloadError;
UIAlertAction *okAction;

UIAlertController *groupUpload;
UIAlertController *groupDownload;
UIAlertController *groupDelete;
UIAlertAction *uploadGroupAction;
UIAlertAction *downloadGroupAction;
UIAlertAction *deleteGroupAction;

UIAlertController *missingFileName;
UIAlertController *missingFileURL;
UIAlertController *invalidYoutubeURL;
UIAlertAction *cancelAction;
UIAlertAction *createAction;

UIAlertController *createGroup;
UIAlertController *passwordMismatchError;
UIAlertController *createGroupSuccess;
UIAlertController *createGroupError;
UIAlertAction *submitCreateAction;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setPlist];
    emptyGroupName = [UIAlertController alertControllerWithTitle: @"GroupName cannot be Empty" message:@"Please enter in a GroupName" preferredStyle:UIAlertControllerStyleAlert];
    emptyPlaylistFolder = [UIAlertController alertControllerWithTitle:@"Cannot Upload Playlist" message:@"Cannot upload an empty playlist" preferredStyle:UIAlertControllerStyleAlert];
    uploadError = [UIAlertController alertControllerWithTitle:@"Upload Error" message:@"Upload Playlist encounters an error. Please make sure you have internet connection" preferredStyle:UIAlertControllerStyleAlert];
    downloadError = [UIAlertController alertControllerWithTitle:@"Download Error" message:@"Download Playlist encounters an error. Please make sure you have internet connection" preferredStyle:UIAlertControllerStyleAlert];
    missingFileName = [UIAlertController alertControllerWithTitle:@"File Name cannot be Empty" message:@"Please enter in a File Name" preferredStyle:UIAlertControllerStyleAlert];
    missingFileURL = [UIAlertController alertControllerWithTitle:@"File URL cannot be Empty" message:@"Please enter in a File URL" preferredStyle:UIAlertControllerStyleAlert];
    invalidYoutubeURL = [UIAlertController alertControllerWithTitle:@"Invalid URL" message:@"The input URL doesn't seem like a valid Youtube Video. Try Adding as a type Other instead" preferredStyle:UIAlertControllerStyleAlert];
    uploadSuccess = [UIAlertController alertControllerWithTitle:@"Upload Successful" message:@"PlayList successfully Uploaded" preferredStyle:UIAlertControllerStyleAlert];
    downloadSuccess = [UIAlertController alertControllerWithTitle:@"Download Successful" message:@"PlayList successfully Downloaded" preferredStyle:UIAlertControllerStyleAlert];
    deleteSuccess = [UIAlertController alertControllerWithTitle:@"Delete Successful" message:@"Playlist successfully Deleted" preferredStyle:UIAlertControllerStyleAlert];
    passwordMismatchError = [UIAlertController alertControllerWithTitle:@"Password Mismatch" message:@"Password does not match" preferredStyle:UIAlertControllerStyleAlert];
    createGroupError = [UIAlertController alertControllerWithTitle:@"Create Group Error" message:@"Create Group encounters an error. Please make sure you have internet connection" preferredStyle:UIAlertControllerStyleAlert];
    createGroupSuccess = [UIAlertController alertControllerWithTitle:@"Create Group Success" message:@"New Group successfully Created" preferredStyle:UIAlertControllerStyleAlert];
    deleteError = [UIAlertController alertControllerWithTitle:@"Delete Error" message:@"Delete Playlist encounters an error. Please make sure you have internet connection" preferredStyle:UIAlertControllerStyleAlert];
    okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [emptyGroupName addAction:okAction];
    [emptyPlaylistFolder addAction:okAction];
    [uploadError addAction:okAction];
    [downloadError addAction:okAction];
    [missingFileName addAction:okAction];
    [missingFileURL addAction:okAction];
    [invalidYoutubeURL addAction:okAction];
    [uploadSuccess addAction:okAction];
    [downloadSuccess addAction:okAction];
    [passwordMismatchError addAction:okAction];
    [createGroupError addAction:okAction];
    [createGroupSuccess addAction:okAction];
    [deleteError addAction:okAction];
    [deleteSuccess addAction:okAction];
    
    createGroup = [UIAlertController alertControllerWithTitle:@"Create New Group" message:@"Create New Group" preferredStyle:UIAlertControllerStyleAlert];
    [createGroup addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Group Name";
        textField.clearsOnBeginEditing = YES;
    }];
    [createGroup addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Password";
        textField.secureTextEntry = YES;
        textField.clearsOnBeginEditing = YES;
    }];
    [createGroup addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Conform Password";
        textField.secureTextEntry = YES;
        textField.clearsOnBeginEditing = YES;
    }];
    submitCreateAction = [UIAlertAction actionWithTitle:@"Submit" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSString *groupName = createGroup.textFields.firstObject.text;
        NSString *password = createGroup.textFields[1].text;
        NSString *passwordConform = createGroup.textFields.lastObject.text;
        if ([password isEqualToString:passwordConform]) {
            [self.database createGroup:groupName password:password];
        }else{
            [self presentAlertView:passwordMismatchError];
        }
    }];
    cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [createGroup addAction:submitCreateAction];
    [createGroup addAction:cancelAction];
    
    groupUpload = [UIAlertController alertControllerWithTitle:@"Upload" message:@"Upload to Group" preferredStyle:UIAlertControllerStyleAlert];
    [groupUpload addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Group Name";
        textField.clearsOnBeginEditing = YES;
    }];
    [groupUpload addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Password";
        textField.secureTextEntry = YES;
        textField.clearsOnBeginEditing = YES;
    }];
    uploadGroupAction = [UIAlertAction actionWithTitle:@"Upload" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSString *groupName = groupUpload.textFields.firstObject.text;
        NSString *password = groupUpload.textFields.lastObject.text;
        [self.database uploadPlist:videoIds name:plistName group:groupName password:password];
    }];
    [groupUpload addAction:uploadGroupAction];
    [groupUpload addAction:cancelAction];
    
    groupDownload = [UIAlertController alertControllerWithTitle:@"Download" message:@"Download from Group" preferredStyle:UIAlertControllerStyleAlert];
    [groupDownload addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Group Name";
        textField.clearsOnBeginEditing = YES;
    }];
    [groupDownload addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Password";
        textField.secureTextEntry = YES;
        textField.clearsOnBeginEditing = YES;
    }];
    downloadGroupAction = [UIAlertAction actionWithTitle:@"Download" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSString *groupName = groupDownload.textFields.firstObject.text;
        NSString *password = groupDownload.textFields.lastObject.text;
        [self.database downloadPlist:plistName group:groupName password:password];
    }];
    [groupDownload addAction:downloadGroupAction];
    [groupDownload addAction:cancelAction];
    
    groupDelete = [UIAlertController alertControllerWithTitle:@"Delete" message:@"Delete form Group" preferredStyle:UIAlertControllerStyleAlert];
    [groupDelete addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Group Name";
        textField.clearsOnBeginEditing = YES;
    }];
    [groupDelete addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Password";
        textField.secureTextEntry = YES;
        textField.clearsOnBeginEditing = YES;
    }];
    deleteGroupAction = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSString *groupName = groupDelete.textFields.firstObject.text;
        NSString *password = groupDelete.textFields.lastObject.text;
        [self.database delete:plistName group:groupName password:password];

    }];
    [groupDelete addAction:deleteGroupAction];
    [groupDelete addAction:cancelAction];


    self.fileURLField.delegate = self;
    
    self.database = [[Database alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadCompleted:) name:@"PlistUploaded" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadCompleted:) name: @"PlistDownloaded"object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GroupCreatedCompleted:) name:@"GroupCreated" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PlaylistDeletedComplete:) name:@"PlaylistDeleted" object:nil];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.groupNameField.text = plistName;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)createGroup:(id)sender {
    [self presentAlertView:createGroup];
}

-(void)GroupCreatedCompleted:(NSNotification *)notification {
    NSDictionary *userInfoDict = [notification userInfo];
    if ([userInfoDict objectForKey:@"data"]) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^(void) {
            createGroupSuccess.message = [userInfoDict objectForKey:@"data"];
            [self presentAlertView:createGroupSuccess];
        }];
    }else if ([userInfoDict objectForKey:@"error"]) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^(void) {
            createGroupError.message = [userInfoDict objectForKey:@"error"];
            [self presentAlertView:createGroupError];
        }];
    }
}

- (IBAction)deletePlaylist:(id)sender {
    [self changePlistName:nil];
    if (!plistName) {
        return;
    }
    if ([self.typePlistSegment selectedSegmentIndex] == 0) {
        [self.database delete:plistName];
    }else {
        [self presentAlertView:groupDelete];
    }
}

-(void)PlaylistDeletedComplete:(NSNotification *)notification {
    NSDictionary *userInfoDict = [notification userInfo];
    if ([userInfoDict objectForKey:@"data"]) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^(void) {
            deleteSuccess.message = [userInfoDict objectForKey:@"data"];
            [self presentAlertView:deleteSuccess];
        }];
        [self writeToFile];
    }else if ([userInfoDict objectForKey:@"error"]) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^(void) {
            deleteError.message = [userInfoDict objectForKey:@"error"];
            [self presentAlertView:deleteError];
        }];
    }
}

#pragma mark - Upload Plist Methods
- (IBAction)uploadPlist:(id)sender {
    [self changePlistName:nil];
    if (!plistName) {
        return;
    }
    if ([videoIds count] <= 0) {
        [self presentAlertView:emptyPlaylistFolder];
        return;
    }
    [self writeToFile];
    
    if ([self.typePlistSegment selectedSegmentIndex] == 0) {
        [self.database uploadPlist:videoIds name:plistName];
    }else {
        [self presentAlertView:groupUpload];
    }
}

-(void)uploadCompleted:(NSNotification *)notification {
    NSDictionary *userInfoDict = [notification userInfo];
    if ([userInfoDict objectForKey:@"data"]) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^(void) {
            uploadSuccess.message = [userInfoDict objectForKey:@"data"];
            [self presentAlertView:uploadSuccess];
        }];
    }else if ([userInfoDict objectForKey:@"error"]) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^(void) {
            uploadError.message = [userInfoDict objectForKey:@"error"];
            [self presentAlertView:uploadError];
        }];
    }
}

#pragma mark - Download Plist Methods

- (IBAction)downloadPlist:(id)sender {
    [self changePlistName:nil];
    if (!plistName) {
        return;
    }
    if ([self.typePlistSegment selectedSegmentIndex] == 0) {
        [self.database downloadPlist:plistName];
    }else {
        [self presentAlertView:groupDownload];
    }
}

-(void)downloadCompleted:(NSNotification *)notification {
    NSDictionary *userInfoDict = [notification userInfo];
    if ([userInfoDict objectForKey:@"data"]) {
        videoIds = [[NSMutableDictionary alloc]initWithDictionary:[userInfoDict objectForKey:@"data"] copyItems:true];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^(void) {
            [self presentAlertView:downloadSuccess];
        }];
        [self writeToFile];
    }else if ([userInfoDict objectForKey:@"error"]) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^(void) {
            downloadError.message = [userInfoDict objectForKey:@"error"];
            [self presentAlertView:downloadError];
        }];
    }
}

#pragma mark - WriteTo Plist Methods
-(void)writeToFile {
    [videoIds writeToFile:fileURL.path atomically:false];
}


- (IBAction)addVideo:(id)sender {
    if ([plistName length] == 0) {
        [self presentAlertView:emptyGroupName];
        return;
    }
    if ([self.fileNameField.text length] == 0) {
        [self presentAlertView:missingFileName];
        return;
        
    }
    if ([self.fileURLField.text length] == 0) {
        [self presentAlertView:missingFileURL];
        return;
    }
    
    NSString *fileName = [self.fileNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSNumber *fileType;
    NSString *fileURL;
    if(self.fileTypeSelector.selectedSegmentIndex == 0){
        fileType = [NSNumber numberWithInt:FILE_YOUTUBE];
        NSArray *urlArray = [self.fileURLField.text componentsSeparatedByString:@"v="];
        if (urlArray.count < 2){
            [self presentAlertView:invalidYoutubeURL];
            return;
        }
        NSArray *videoIdArray = [urlArray[1] componentsSeparatedByString:@"&"];
        if (videoIdArray.count < 1) {
            [self presentAlertView:invalidYoutubeURL];
            return;
        }
        fileURL = videoIdArray[0];
    }else{
        fileType = [NSNumber numberWithInt:FILE_OTHER];
        fileURL = self.fileURLField.text;
    }
    videoIds[fileName] = @[fileType,fileURL];
    [self writeToFile];
}

-(void)presentAlertView:(UIAlertController*)alertView {
    if(self.presentedViewController != nil){
        [self.presentedViewController dismissViewControllerAnimated:true completion:^(void){
            [self presentViewController:alertView animated:true completion:nil];
        }];
    }else{
        [self presentViewController:alertView animated:true completion:nil];
    }
}
- (IBAction)changePlistName:(id)sender {
    if([self.groupNameField.text length] == 0){
        [self presentAlertView:emptyGroupName];
        return;
    }
    if ([self.groupNameField.text isEqualToString:plistName]) {
        return;
    }
    plistName = self.groupNameField.text;
    NSURL *documentsURL = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask][0];
    fileURL = [documentsURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",plistName]];
    NSString *filename = @"plistName.txt";
    NSString *localDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *localPath = [localDir stringByAppendingPathComponent:filename];
    [plistName writeToFile:localPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    NSFileManager *fileManage = [NSFileManager defaultManager];
    if([fileManage fileExistsAtPath:fileURL.path]){
        videoIds= [[NSMutableDictionary alloc] initWithContentsOfFile:fileURL.path];
    }else{
        videoIds = [[NSMutableDictionary alloc]init];
    }
}

- (void)setPlist {
    NSString *filename = @"plistName.txt";
    NSString *localDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *localPath = [localDir stringByAppendingPathComponent:filename];
    NSFileManager *fileManage = [NSFileManager defaultManager];
    if([fileManage fileExistsAtPath:localPath]){
        plistName = [[NSString alloc]initWithContentsOfFile:localPath encoding:NSUTF8StringEncoding error:NULL];
        self.groupNameField.text = plistName;
        return;
    }
}

+(NSDictionary *)getVideoPlaylist:(FileType)fileType {
    NSMutableDictionary *returnDic = [[NSMutableDictionary alloc]init];
    for (NSString *key in videoIds) {
        NSLog(@"%i", FILE_YOUTUBE);
        if([videoIds[key][0] intValue] == fileType){
            returnDic[key] = videoIds[key][1];
        }
    }
    return [returnDic copy];
}

- (IBAction)clearWebList:(id)sender {
    for (NSString *key in videoIds.copy) {
        if([videoIds[key][0] intValue] == FILE_OTHER){
            [videoIds removeObjectForKey:key];
        }
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:@"WebClear" object:nil];
}

- (IBAction)clearYoutubeList:(id)sender {
    for (NSString *key in videoIds.copy) {
        if([videoIds[key][0] intValue] == FILE_YOUTUBE){
            [videoIds removeObjectForKey:key];
        }
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:@"YoutubeClear" object:nil];
}

+(void)populateLocalDictionary {
    NSString *filename = @"plistName.txt";
    NSString *localDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *localPath = [localDir stringByAppendingPathComponent:filename];
    NSFileManager *fileManage = [NSFileManager defaultManager];
    if(![fileManage fileExistsAtPath:localPath]){
        return;
    }
    plistName = [[NSString alloc]initWithContentsOfFile:localPath encoding:NSUTF8StringEncoding error:NULL];

    
    NSURL *documentsURL = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask][0];
    fileURL = [documentsURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",plistName]];
    if(![fileManage fileExistsAtPath:fileURL.path]){
        videoIds = [[NSMutableDictionary alloc]init];
        return;
    }
    videoIds= [[NSMutableDictionary alloc] initWithContentsOfFile:fileURL.path];
}

-(void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:true];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField setText:@""];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
