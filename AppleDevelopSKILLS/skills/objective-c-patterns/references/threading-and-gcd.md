# Threading and GCD

## When to Use

Use these patterns when coordinating Objective-C code across queues, protecting shared mutable state, or maintaining old callback-based async flows.

## Preferred Choices

- UI work belongs on the main thread.
- Use a serial queue to protect mutable state before reaching for locks.
- Keep queue ownership explicit. Name queues by the resource they protect.
- For legacy callback code, centralize completion delivery rules so callers know which queue receives results.

## Main-Thread UI Rules

Any UIKit or AppKit state update should be dispatched to the main queue.

```objective-c
[service fetchProfileWithCompletion:^(ZDProfile *profile, NSError *error) {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self renderProfile:profile error:error];
    });
}];
```

## Serial vs Concurrent Queues

- Serial queues are the default for ordering and state protection.
- Concurrent queues fit independent work items, especially with barrier writes.
- Avoid `dispatch_sync` back onto the same serial queue.

```objective-c
@interface ZDCache : NSObject
@property (nonatomic, strong) dispatch_queue_t queue;
@property (nonatomic, strong) NSMutableDictionary<NSString *, id> *storage;
@end

self.queue = dispatch_queue_create("com.example.cache", DISPATCH_QUEUE_SERIAL);

dispatch_async(self.queue, ^{
    self.storage[key] = object;
});
```

## Legacy Callback Coordination

For grouped async work, `dispatch_group_t` is often the simplest retrofit.

```objective-c
dispatch_group_t group = dispatch_group_create();

dispatch_group_enter(group);
[serviceA loadWithCompletion:^{
    dispatch_group_leave(group);
}];

dispatch_group_enter(group);
[serviceB loadWithCompletion:^{
    dispatch_group_leave(group);
}];

dispatch_group_notify(group, dispatch_get_main_queue(), ^{
    [self refreshUI];
});
```

## Autorelease Pools in Background Work

Long-running background loops can accumulate autoreleased objects. Add a local autorelease pool around each iteration or chunk of work.

```objective-c
dispatch_async(self.workerQueue, ^{
    for (NSURL *url in urls) {
        @autoreleasepool {
            NSData *data = [NSData dataWithContentsOfURL:url];
            [self consumeData:data];
        }
    }
});
```

## Common Traps

- Touching UI from a background queue because the callback "usually" arrives on main.
- Sharing mutable collections across queues without one clear owner.
- Deadlocking by synchronously dispatching to the current queue.
- Flooding global concurrent queues with work that needs backpressure or cancellation.
