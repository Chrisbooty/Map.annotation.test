//
//  CustomView.m
//  CJMap
//
//  Created by mac on 16/6/2.
//  Copyright © 2016年 Cijian.Wu. All rights reserved.
//

#import "CustomView.h"

@implementation CustomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        self.image = [UIImage imageNamed:@"map"];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
        view.backgroundColor = [UIColor redColor];
        
        self.leftCalloutAccessoryView = view;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
        
        btn.frame = CGRectMake(0, 0, 40, 30);
        
        self.rightCalloutAccessoryView = btn;
        
        
    }
    return self;
}



@end
