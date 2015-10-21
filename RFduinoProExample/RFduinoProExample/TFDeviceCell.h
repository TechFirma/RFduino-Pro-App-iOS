//
//  TFDeviceCell.h
//  Shooter Ready
//
//  Created by Michael Bac on 8/2/14.
//  Copyright (c) 2014 Tech Firma, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TFDeviceCell;

@protocol TFDeviceCellDelegate <NSObject>
- (void)nameChanged:(TFDeviceCell *)cell
		   newName:(NSString *) name;
@end


@interface TFDeviceCell : UITableViewCell <UIAlertViewDelegate>

@property (nonatomic, assign) UIViewController *viewController;
@property (nonatomic, weak) id <TFDeviceCellDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIImageView *rfduinoImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *uuidLabel;
@property (strong, nonatomic) IBOutlet UIButton *renameButton;

@end
