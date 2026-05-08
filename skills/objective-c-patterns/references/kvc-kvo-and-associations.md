# KVC, KVO, and Associations

## When to Use

Use these tools when you need key-based access, observation of Objective-C properties, or small attached metadata on objects you cannot modify directly.

## Preferred Choices

- Prefer normal property access over KVC when the property is known at compile time.
- Prefer explicit callbacks, delegates, or modern observation wrappers before raw KVO for new design work.
- Use associated objects for narrow metadata, not as a substitute for full object structure.

## KVC and Compliant Key Paths

KVC works best with `@property` declarations and standard accessor naming.

```objective-c
NSString *name = [person valueForKey:@"name"];
[person setValue:@"Ava" forKey:@"name"];
NSNumber *count = [order valueForKeyPath:@"items.@count"];
```

Safe rules:

- Use real property names.
- Handle `setValue:forUndefinedKey:` only when you intentionally accept dynamic input.
- Avoid direct ivar assumptions across refactors.

## KVO Lifecycle Hazards

KVO is sensitive to registration and teardown timing. Observation bugs are often crashes, not warnings.

```objective-c
[self.document addObserver:self
                forKeyPath:@"state"
                   options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                   context:ZDDocumentStateContext];

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey, id> *)change
                       context:(void *)context {
    if (context == ZDDocumentStateContext) {
        [self updateForState:self.document.state];
        return;
    }
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}
```

Rules:

- Add and remove observers in symmetric lifecycle points.
- Use unique context pointers, not string comparison alone.
- Do not mutate observed state from multiple threads without a stronger synchronization plan.

## Associated Object Policies

Choose the lightest correct policy:

- `OBJC_ASSOCIATION_RETAIN_NONATOMIC` for most UI-bound attached objects
- `OBJC_ASSOCIATION_COPY_NONATOMIC` for blocks and copied values

Do not treat `OBJC_ASSOCIATION_ASSIGN` as a normal choice for object references. It is not zeroing weak storage, so it can leave a dangling pointer after deallocation. If you need non-owning behavior, prefer a weak wrapper object, `NSMapTable`, or a redesign that gives the lifetime a real owner.

```objective-c
objc_setAssociatedObject(self, @selector(zd_handler), handler, OBJC_ASSOCIATION_COPY_NONATOMIC);
```

```objective-c
@interface ZDWeakBox<ObjectType> : NSObject
@property (nonatomic, weak, nullable) ObjectType object;
@end
```

## When Subclassing Is Cleaner

Subclassing or a wrapper object is cleaner than association when:

- The extra state has its own lifecycle rules
- Multiple methods depend on the state
- The behavior needs setup and teardown hooks
- The attached object starts looking like a hidden controller

## ReactiveObjC (RAC) as a KVO Alternative

When the project depends on `ReactiveObjC`, prefer `RACObserve` over raw KVO registration. RAC manages observer lifetime automatically and eliminates the `-observeValueForKeyPath:ofObject:change:context:` boilerplate.

See `references/coding-conventions.md` for the full usage pattern and a comparison with raw KVO.

Use raw KVO only when:
- `ReactiveObjC` is not available
- the observed property is on an object you do not own and RAC cannot be applied
- the observation must survive beyond the subscriber's lifecycle (unusual)

When raw KVO is unavoidable, always pair `-addObserver:forKeyPath:options:context:` and `-removeObserver:forKeyPath:context:` at symmetric lifecycle points and use a unique context pointer rather than string comparison alone.

## Common Traps

- Using KVC strings that drift out of sync during refactors
- Observing in one lifecycle method and forgetting to stop observing on all exit paths
- Using associated objects to hide complex behavior in a category
- Assuming `OBJC_ASSOCIATION_ASSIGN` behaves like zeroing weak storage
