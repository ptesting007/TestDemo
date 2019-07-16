
#import "ALForm.h"

typedef enum EyesState : NSInteger {
    EyesStateOpened,
    EyesStateClosed
} EyesState;

typedef enum EyesPositioningMode : NSInteger {
    EyesPositioningModeStraight,
    EyesPositioningModeDown,
    EyesPositioningModeTrack
} EyesPositioningMode;

@interface ALForm ()

@property (weak, nonatomic) IBOutlet UIImageView* owl;
@property (weak, nonatomic) IBOutlet UIImageView* owlLeftEye;
@property (weak, nonatomic) IBOutlet UIImageView* owlRightEye;
@property (weak, nonatomic) IBOutlet UIImageView* owlLeftWing;
@property (weak, nonatomic) IBOutlet UIImageView* owlRightWing;

@end

@implementation ALForm {
    EyesPositioningMode eyesPositioningMode;
    EyesState eyesState;
}


- (void) setupWithType:(ALFormType)type {
    
}

- (void) drawRect:(CGRect)rect {
    [self initForm];
    [self setElements];
    
    eyesState = EyesStateOpened;
    eyesPositioningMode = EyesPositioningModeStraight;
    [self animateEyesWithHorizontalPosition:0];
}

- (void) initForm {
    UIView* initiatedView = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"ALFormView" owner:self options:nil] firstObject];
    
    if (initiatedView) {
        [self addSubview:initiatedView];
        
        initiatedView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [initiatedView.leftAnchor constraintEqualToAnchor:self.leftAnchor].active = YES;
        [initiatedView.rightAnchor constraintEqualToAnchor:self.rightAnchor].active = YES;
        [initiatedView.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
        [initiatedView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
    }
}

- (void) setElements {
    
    self.formView.layer.cornerRadius = 15.0;
    self.loginField.layer.cornerRadius = 10.0;
    self.passwordField.layer.cornerRadius = 10.0;
    self.submitButton.layer.cornerRadius = 10.0;
    
    self.loginField.delegate = self;
    self.passwordField.delegate = self;
    
    self.loginField.layer.borderWidth = 1.0;
    self.passwordField.layer.borderWidth = 1.0;
    self.loginField.layer.borderColor = self.passwordField.backgroundColor.CGColor;
    self.passwordField.layer.borderColor = self.passwordField.backgroundColor.CGColor;
    
    self.loginField.backgroundColor = [UIColor clearColor];
    self.passwordField.backgroundColor = [UIColor clearColor];
    
    self.loginField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
    self.passwordField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
    
    [self.loginField addTarget:self action:@selector(textFieldChangedText:) forControlEvents:UIControlEventEditingChanged];
    [self.submitButton addTarget:self action:@selector(submitButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
#warning Remove This line
    self.loginField.text = @"eve.holt@reqres.in";
    self.passwordField.text = @"Testing";
}

- (void) animateEyesWithHorizontalPosition:(float)horizontalPos {
    float horizontalPosition, verticalPosition;
    
    switch (eyesPositioningMode) {
        case EyesPositioningModeStraight:
            horizontalPosition = 0;
            verticalPosition = 0;
            break;
        case EyesPositioningModeDown:
            horizontalPosition = 0;
            verticalPosition = 6;
            break;
        case EyesPositioningModeTrack:
            horizontalPosition = horizontalPos;
            verticalPosition = 5;
            break;
        default:
            break;
    }
    
    [UIView animateWithDuration:1.2 animations:^{
        self.owlLeftEye.transform = CGAffineTransformTranslate(self.owlLeftEye.transform, horizontalPosition-self.owlLeftEye.transform.tx, verticalPosition - self.owlLeftEye.transform.ty);
        self.owlRightEye.transform = CGAffineTransformTranslate(self.owlRightEye.transform, horizontalPosition-self.owlRightEye.transform.tx, verticalPosition - self.owlRightEye.transform.ty);
    }];
    
}

- (void) openEyes {
    if (eyesState == EyesStateOpened) return;
    [UIView animateWithDuration:0.8 animations:^{
        
        self.owlLeftWing.transform = CGAffineTransformTranslate(self.owlLeftWing.transform, 0, 55);
        self.owlRightWing.transform = CGAffineTransformTranslate(self.owlRightWing.transform, 0, 55);
    }];
    eyesState = EyesStateOpened;
}

- (void) closeEyes {
    if (eyesState == EyesStateClosed) return;
    [UIView animateWithDuration:0.8 animations:^{
        self.owlLeftWing.transform = CGAffineTransformTranslate(self.owlLeftWing.transform, 0, -55);
        self.owlRightWing.transform = CGAffineTransformTranslate(self.owlRightWing.transform, 0, -55);
    }];
    eyesState = EyesStateClosed;
}

#pragma mark Text Field

- (void) textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == self.loginField) {
        [self openEyes];
        eyesPositioningMode = EyesPositioningModeDown;
        [self animateEyesWithHorizontalPosition:0];
    } else {
        [self closeEyes];
    }
    
    if (self.delegate) [self.delegate alFormDidBeginEditing];
}

- (void) textFieldDidEndEditing:(UITextField *)textField {
    [self openEyes];
    if (self.delegate) [self.delegate alFormDidEndEditing];
}

- (void) textFieldChangedText:(UITextField*)textField {
    if (textField.text.length == 0) {
        eyesPositioningMode = EyesPositioningModeStraight;
        [self animateEyesWithHorizontalPosition:0];
        return;
    }
    
    if (eyesState == EyesStateClosed) [self openEyes];
    
    eyesPositioningMode = EyesPositioningModeTrack;
    float desiredPosition = (int)(textField.text.length/3.5) - 5;
    if (desiredPosition < 3) [self animateEyesWithHorizontalPosition:desiredPosition];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    eyesPositioningMode = EyesPositioningModeStraight;
    [self animateEyesWithHorizontalPosition:0];
    if (self.delegate) {
        [self.delegate alFormShouldReturn];
    }
    return YES;
}
#pragma mark Submit button

- (void) submitButtonTapped {
    [self endEditing:YES];
    if (self.delegate) [self.delegate alFormSubmitButtonTapped];
}

- (void) cleatTextFieldValue {
    self.loginField.text = @"";
    self.passwordField.text = @"";
}
@end
