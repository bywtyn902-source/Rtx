#import <UIKit/UIKit.h>

@interface FloatingButtonManager : NSObject
+ (instancetype)sharedInstance;
- (void)showFloatingButtonOnWindow:(UIWindow *)window;
@end

@implementation FloatingButtonManager {
    UIButton *floatingBtn;
    NSTimer *clickTimer;
    BOOL isClicking;
}

+ (instancetype)sharedInstance {
    static FloatingButtonManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[FloatingButtonManager alloc] init];
    });
    return sharedInstance;
}

- (void)showFloatingButtonOnWindow:(UIWindow *)window {
    if (floatingBtn) return;
    
    // إنشاء الزر العائم
    floatingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [floatingBtn setTitle:@"⚡ تكبيس" forState:UIControlStateNormal];
    [floatingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    floatingBtn.backgroundColor = [UIColor colorWithRed:254/255.0 green:44/255.0 blue:85/255.0 alpha:1.0]; // لون تيك توك
    floatingBtn.layer.cornerRadius = 30;
    floatingBtn.frame = CGRectMake(window.bounds.size.width - 90, window.bounds.size.height - 180, 70, 70);
    
    // جعل الزر قابلاً للتحريك بالسحب (Dragging)
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [floatingBtn addGestureRecognizer:pan];
    
    // حدث الضغط لتشغيل وإيقاف التكبيس
    [floatingBtn addTarget:self action:@selector(toggleAutoClick) forControlEvents:UIControlEventTouchUpInside];
    
    [window addSubview:floatingBtn];
}

- (void)handlePan:(UIPanGestureRecognizer * _Nonnull)gesture {
    CGPoint translation = [gesture translationInView:floatingBtn.superview];
    CGPoint newCenter = CGPointMake(floatingBtn.center.x + translation.x, floatingBtn.center.y + translation.y);
    floatingBtn.center = newCenter;
    [gesture setTranslation:CGPointZero inView:floatingBtn.superview];
}

- (void)toggleAutoClick {
    isClicking = !isClicking;
    
    if (isClicking) {
        [floatingBtn setTitle:@"⏹️ إيقاف" forState:UIControlStateNormal];
        floatingBtn.backgroundColor = [UIColor colorWithRed:37/255.0 green:244/255.0 blue:238/255.0 alpha:1.0];
        
        // التكبيس التلقائي كل 0.05 ثانية
        clickTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(performTap) userInfo:nil repeats:YES];
    } else {
        [floatingBtn setTitle:@"⚡ تكبيس" forState:UIControlStateNormal];
        floatingBtn.backgroundColor = [UIColor colorWithRed:254/255.0 green:44/255.0 blue:85/255.0 alpha:1.0];
        [clickTimer invalidate];
        clickTimer = nil;
    }
}

- (void)performTap {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (!window) return;
    
    // احداثيات منتصف الشاشة
    CGFloat centerX = window.bounds.size.width / 2;
    CGFloat centerY = window.bounds.size.height / 2;
    CGPoint centerPoint = CGPointMake(centerX, centerY);
    
    // محاكاة اللمس (للأزرار والعناصر التفاعلية داخل التطبيق)
    UIView *hitView = [window hitTest:centerPoint withEvent:nil];
    if (hitView) {
        // إرسال أحداث اللمس
        [hitView touchesBegan:[NSSet setWithObject:[[UITouch alloc] init]] withEvent:nil];
        [hitView touchesEnded:[NSSet setWithObject:[[UITouch alloc] init]] withEvent:nil];
    }
}

@end
