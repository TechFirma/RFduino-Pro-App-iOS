//
//  TFDeviceCell.m
//  Shooter Ready
//
//  Created by Michael Bac on 8/2/14.
//  Copyright (c) 2014 Tech Firma, LLC. All rights reserved.
//

#import "TFDeviceCell.h"

@implementation TFDeviceCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)OnRename:(UIButton *)sender {
	UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Enter New Name"
																   message:nil
															preferredStyle:UIAlertControllerStyleAlert];
 
	[alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
		textField.text = _nameLabel.text;
	}];
	 
	UIAlertAction* action = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil];
	[alert addAction:action];

	action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
														  handler:^(UIAlertAction * action) {
															  UITextField *textfield = [[alert textFields] objectAtIndex:0];
															  
															  _nameLabel.text = textfield.text;
															  
															  [self.delegate nameChanged:self newName:_nameLabel.text];
															  
															  [alert dismissViewControllerAnimated:YES completion:nil];
														  }];
	[alert addAction:action];
	
	[self.viewController presentViewController:alert animated:YES completion:nil];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if (alertView.tag == 1) {
		if (buttonIndex == 1) {
			UITextField *textfield = [alertView textFieldAtIndex:0];
			
			_nameLabel.text = textfield.text;
			
   			[self.delegate nameChanged:self newName:_nameLabel.text];			
		}
	}
}

@end
