//
//  MineInfoViewController.m
//  cc
//
//  Created by yanghuan on 2018/4/20.
//  Copyright © 2018年 wyChirs. All rights reserved.
//

#import "MineInfoViewController.h"
#import "XLPhotoBrowser.h"
#import "UserInfoModel.h"
#import <Photos/PHPhotoLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import "UploadPic.h"
@interface MineInfoViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (weak, nonatomic) IBOutlet UITextField *nickTextField;

@property (weak, nonatomic) IBOutlet UIView *bgView1;
@property (weak, nonatomic) IBOutlet UIView *bgView2;
@property(nonatomic,strong) UIImagePickerController *imagePicker;
@property(nonatomic,strong) UIImage *originalImage;
@property(nonatomic,copy) NSString *url;
@end

@implementation MineInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	self.navigationItem.title = @"个人信息";
	[self setup];
	[self addNavBtn];
	[self addTapAction];
}
- (void)setup {
	UserInfoModel *model = [[BeanManager shareInstace] getBeanfromPath:UserModelPath];
	_nickTextField.text = model.NICK_NAME;
	[_headImgView sd_setImageWithURL:[NSURL URLWithString:model.HEAD_URL] placeholderImage:[UIImage imageNamed:@"logo"]];
	_url = model.HEAD_URL;
}

- (void)addNavBtn {
	UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
	btn.frame = CGRectMake(0, 0, 40, 30);
	[btn setTitle:@"完成" forState:UIControlStateNormal];
	[btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	btn.titleLabel.font = Font_15;
	
	[btn addTapBlock:^(UIButton *btn) {
		// 修改个人信息
		if (_nickTextField.text == 0) {
			[SVProgressHUD showInfoWithStatus:@"请输入昵称"];
			return ;
		}
		
		RequestParams *params = [[RequestParams alloc] initWithParams:API_CGPERSONMSG];
		[params addParameter:@"USER_NAME" value:[SPUtil objectForKey:k_app_userNumber]];
		[params addParameter:@"HEAD_URL" value:_url];
		[params addParameter:@"NICK_NAME" value:_nickTextField.text];
		
		
		[[NetworkSingleton shareInstace] httpPost:params withTitle:@"" successBlock:^(id data) {
			NSString *code = data[@"code"];
			if (![code isEqualToString:@"1000"]) {
				[SVProgressHUD showErrorWithStatus:data[@"message"]];
				return ;
			}
			[SVProgressHUD showSuccessWithStatus:@"修改成功"];
			UserInfoModel *model = [[BeanManager shareInstace] getBeanfromPath:UserModelPath];
			model.HEAD_URL = _url;
			model.NICK_NAME = _nickTextField.text;
			[[BeanManager shareInstace] setBean:model path:UserModelPath];
			
		} failureBlock:^(NSError *error) {
			[SVProgressHUD showErrorWithStatus:@"服务器异常，请联系管理员"];
		}];
		
	}];
	
	UIBarButtonItem *anotherButton2 = [[UIBarButtonItem alloc] initWithCustomView:btn];
	[self.navigationItem setRightBarButtonItem:anotherButton2];
	
}

- (void)addTapAction {
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
	[_headImgView addGestureRecognizer:tap];
	
	UITapGestureRecognizer *imgtap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headImageChangeAction)];
	[_bgView1 addGestureRecognizer:imgtap];
	
	UITapGestureRecognizer *nametap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nickNameChangeAction)];
	[_bgView2 addGestureRecognizer:nametap];
}

- (void)tapAction {
	[XLPhotoBrowser showPhotoBrowserWithImages:@[_headImgView.image] currentImageIndex:0];
}

- (void)headImageChangeAction {
	
	////这里是摄像头可以使用的处理逻辑
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从手机选择照片", @"拍照片", nil];
	[actionSheet showInView:self.view];
}

- (void)nickNameChangeAction {
	
}



#pragma mark - UIActionSheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	_imagePicker = [[UIImagePickerController alloc] init];
	_imagePicker.delegate = self;
	if (buttonIndex == 0) {/**<相册库选取照片*/
		PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
		if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied)
		{
			UIAlertController * alertC = [UIAlertController alertControllerWithTitle:@"相册访问受限" message:nil preferredStyle:UIAlertControllerStyleAlert];
			[self presentViewController:alertC animated:YES completion:nil];
			UIAlertAction * action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
				[self dismissViewControllerAnimated:YES completion:nil];
			}];
			[alertC addAction:action];
			return;
		}else {
			_imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
		}
	}else if (buttonIndex == 1){/**<拍照选取照片*/
		/// 用户是否允许摄像头使用
		NSString * mediaType = AVMediaTypeVideo;
		AVAuthorizationStatus  authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
		/// 不允许弹出提示框
		if (authorizationStatus == AVAuthorizationStatusRestricted|| authorizationStatus == AVAuthorizationStatusDenied) {
			
			UIAlertController * alertC = [UIAlertController alertControllerWithTitle:@"摄像头访问受限" message:nil preferredStyle:UIAlertControllerStyleAlert];
			[self presentViewController:alertC animated:YES completion:nil];
			UIAlertAction * action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
				[self dismissViewControllerAnimated:YES completion:nil];
			}];
			[alertC addAction:action];
			return ;
		}else {
			_imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
		}
	}else if (buttonIndex == 2){
		
		return ;
	}
	_imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
	_imagePicker.allowsEditing = YES;
	[self presentViewController:_imagePicker animated:YES completion:nil];
}

#pragma mark - UIImagePickerController delegate
//相册处理，获取图片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {/**<选中照片回调*/
	_originalImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
	if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
	{
		UIImageWriteToSavedPhotosAlbum(
									   _originalImage, nil, nil, nil);
	}
	_headImgView.image = _originalImage;
	[self dismissViewControllerAnimated:YES completion:nil];
    // 上传照片
    NSString *photoPath = [[UploadPic sharedInstance] photoSavePathForURL:info[UIImagePickerControllerReferenceURL]];
    NSData *imageData = UIImageJPEGRepresentation(info[UIImagePickerControllerEditedImage],1.0);
    if ((float)imageData.length/1024 > 100) {//需要测试
        imageData = UIImageJPEGRepresentation(info[UIImagePickerControllerEditedImage], 1024*100.0/(float)imageData.length);
    }
    [imageData writeToFile:photoPath atomically:YES];
    NSString *fileName = [NSString stringWithFormat:@"%f_%d.jpg", [[NSDate date] timeIntervalSince1970], arc4random()%1000];
    [[UploadPic sharedInstance] uploadFileMultipartWithPath:photoPath fileName:fileName callback:^(NSString *url) {
        NSLog(@"%@",url);
		_url = url;
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {/**<不选照片点击取消回调*/
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
