# Runtime APIs and Swizzling

## When to Use

Use runtime APIs when reflection, dynamic inspection, or narrowly-scoped method replacement is the only practical integration point.

## Preferred Choices

- Prefer subclassing, composition, delegates, wrappers, or explicit callbacks before runtime mutation.
- Prefer inheritance over hook-style interception whenever a concrete superclass boundary is available.
- Keep swizzles isolated to one file, one class, and one reason.
- Fail closed: if the original method does not exist or the class is wrong, do not continue.
- Keep category helpers small, prefix them with the project's category prefix, and avoid turning categories into hidden feature modules.

## Method Lookup Basics

Objective-C sends a selector to the receiver's class, then walks the superclass chain until it finds an implementation. Swizzling changes which implementation is associated with a selector at runtime.

```objective-c
Method originalMethod = class_getInstanceMethod(self, @selector(viewDidAppear:));
Method replacementMethod = class_getInstanceMethod(self, @selector(xx_viewDidAppear:));
```

## Safe Swizzle Checklist

- Swizzle once with `dispatch_once`.
- Swizzle in `+load` only when early process-wide installation is required.
- Verify both methods exist.
- Install the replacement on the concrete class first when the original selector may be inherited.
- Preserve the original implementation path.
- Avoid swizzling methods owned by classes you do not control unless there is no safer hook.
- Document the reason, scope, and expected ordering assumptions.

```objective-c
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class cls = [self class];
        SEL originalSelector = @selector(viewDidAppear:);
        SEL swizzledSelector = @selector(xx_viewDidAppear:);

        Method originalMethod = class_getInstanceMethod(cls, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(cls, swizzledSelector);
        if (!originalMethod || !swizzledMethod) { return; }

        BOOL didAddMethod = class_addMethod(cls,
                                            originalSelector,
                                            method_getImplementation(swizzledMethod),
                                            method_getTypeEncoding(swizzledMethod));

        if (didAddMethod) {
            class_replaceMethod(cls,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (void)xx_viewDidAppear:(BOOL)animated {
    [self xx_viewDidAppear:animated];
    [self xx_trackAppearance];
}
```

This pattern is safer when the original method comes from a superclass because it installs the replacement on the current class instead of mutating an inherited slot blindly.

## `+load` vs `+initialize` Cautions

- `+load` runs eagerly and very early. Keep it tiny and deterministic.
- `+initialize` is lazy and message-driven. It is not a safe place for swizzle ordering assumptions across frameworks.
- Do not rely on category `+load` ordering between unrelated modules.

## Associations and UIKit Lifecycle Risks

Associated objects are best for small, local metadata where subclassing is not possible. They become risky when used to bolt lifecycle-sensitive state onto UIKit objects you do not own.

```objective-c
static const void *XXStateKey = &XXStateKey;

objc_setAssociatedObject(viewController, XXStateKey, tracker, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
```

Risks to call out:

- Hidden ownership that keeps controllers or views alive.
- State that is set in one lifecycle method and read in another without clear initialization guarantees.
- Category APIs that look like real stored properties but have no compile-time visibility into teardown.

## Common Traps

- Swizzling the same selector from multiple modules and assuming a stable call order.
- Forgetting that class methods must be swizzled on the metaclass.
- Exchanging implementations on an inherited method without first making the concrete class own the selector.
- Using associations to simulate full object state when a small helper object or subclass would be clearer.
- Building a category-based hook layer when a small subclass or wrapper would have been easier to reason about.
- Performing heavyweight work in `+load`.
