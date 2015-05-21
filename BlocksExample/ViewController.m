//
//  ViewController.m
//  BlocksExample
//
//  Created by Nicolas Ameghino on 5/20/15.
//
//

#import "ViewController.h"
#import "MonchoXKCDService.h"
#import "XKCDService.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UIImageView *comicImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *altTextLabel;
@property (weak, nonatomic) IBOutlet UITextView *transcriptTextView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UISwitch *serviceSwitch;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self.searchButton addTarget:self action:@selector(fireSearch:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void) fireSearch:(id) sender {
    [self.searchTextField resignFirstResponder];
    if (self.serviceSwitch.isOn) {
        // use real service
        [self fetchUsingXKCDService:self.searchTextField.text];
    } else {
        [self fetchUsingMonchoXKCDService:self.searchTextField.text];
    }
}

-(void) setComicData:(NSDictionary *)comic {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.comicImageView.image = [UIImage imageWithData:comic[@"imageBytes"]];
        self.titleLabel.text = comic[@"title"];
        self.altTextLabel.text = comic[@"alt"];
        self.transcriptTextView.text = comic[@"transcript"];
        self.dateLabel.text = [NSString stringWithFormat:@"Published on %@/%@/%@",
                               comic[@"day"], comic[@"month"], comic[@"year"]];

    });
}

-(void) showAlertForError:(NSError *)error {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error"
                                                                             message:[error localizedDescription]
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alertController animated:YES completion:NULL];
}

-(void) fetchUsingXKCDService:(NSString *)comicId {
    __weak typeof(self) welf = self;
    [XKCDService fetchComic:comicId
               successBlock:^(NSDictionary *d) {
                   [welf setComicData:d];
               }
               failureBlock:^(NSError *error) {
                   [welf showAlertForError:error];
               }];
}

-(void) fetchUsingMonchoXKCDService:(NSString *)comicId {
    id r = [MonchoXKCDService fetchComic:comicId];
    if ([r isKindOfClass:[NSError class]]) {
        [self showAlertForError:r];
    } else {
        [self setComicData:r];
    }
}

@end
