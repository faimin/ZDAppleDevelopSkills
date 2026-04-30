# Blocks and Memory

## When to Use

Use these patterns when passing callbacks, storing completion handlers, or deciding whether a relationship should be a block or a delegate.

## Preferred Choices

- Use blocks for one-shot completion and short-lived configuration hooks.
- Use delegates or explicit collaborators for repeated events and long-lived relationships.
- Treat a stored block as an owning object. If the block captures `self`, assume a retain cycle until proven otherwise.
- Prefer explicit capture strategy over cleanup code in `dealloc`.
- Nil-check optional blocks before invoking them.

## Block Syntax Patterns

```objective-c
typedef void (^ZDCompletionBlock)(BOOL success, NSError * _Nullable error);

@interface ZDDownloader : NSObject
- (void)fetchURL:(NSURL *)url completion:(ZDCompletionBlock)completion;
@end

[downloader fetchURL:url completion:^(BOOL success, NSError *error) {
    if (!success) {
        NSLog(@"Download failed: %@", error);
    }
}];
```

## Stack vs Heap Capture Context

Blocks begin on the stack and move to the heap when copied or stored strongly. Under ARC, assigning a block to a strong property copies it for you.

```objective-c
@interface ZDWorker : NSObject
@property (nonatomic, copy) dispatch_block_t completion;
@end
```

Use `copy` for block properties. A `strong` block property often works under ARC, but `copy` states the intent and remains the correct rule.

## Weak/Strong Dance

Use weak capture when the owner stores the block or when async work might outlive the owner.

```objective-c
__weak typeof(self) weakSelf = self;
self.completion = ^{
    __strong typeof(weakSelf) strongSelf = weakSelf;
    if (!strongSelf) { return; }
    [strongSelf refreshUI];
};
```

For one-shot work where the callee does not retain the block beyond execution, strong capture may be fine and often simpler:

```objective-c
[database performSynchronousRead:^(NSArray *rows) {
    [self consumeRows:rows];
}];
```

## Delegate vs Block Tradeoffs

- Prefer a delegate when the callback is long-lived, stateful, or has multiple event methods.
- Prefer a block when the caller needs one completion result close to the call site.
- If you need both progress and completion, a delegate plus a final completion block is often clearer than many stored blocks.

## Safe Invocation Pattern

Guard the preconditions first, then invoke the block only if it exists.

```objective-c
- (void)finishWithResult:(id _Nullable)result
                   error:(NSError * _Nullable)error
              completion:(ZDCompletionBlock)completion {
    if (!result && !error) { return; }
    if (completion) {
        completion(result != nil, error);
    }
}
```

## Common Traps

- Capturing `self` strongly in a block stored by `self`.
- Calling a nullable block directly and assuming the caller always passed one.
- Using blocks as an all-purpose replacement for protocol boundaries.
- Forgetting that timers, animations, and dispatch sources may retain the block for much longer than expected.
- Adding weak capture everywhere, then silently dropping required work because `self` vanished mid-flow.
