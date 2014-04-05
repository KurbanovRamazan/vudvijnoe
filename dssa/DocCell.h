//
//  DocCell.h
//  dssa
//
//  Created by Kurbanov Ramazan on 03.12.13.
//  Copyright (c) 2013 1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DocCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *mainLbl;
@property (weak, nonatomic) IBOutlet UILabel *subLbl;
@property (weak, nonatomic) IBOutlet UILabel *courceLbl;
@property (weak, nonatomic) IBOutlet UILabel *fakyltet;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
