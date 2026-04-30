# Message Forwarding

## When to Use

Use forwarding when an object must answer selectors dynamically, proxy behavior to another object, or adapt an old surface to a new implementation without exposing every method manually.

## Preferred Choices

- Prefer explicit methods when the API is stable and small.
- Use `forwardingTargetForSelector:` for simple redirection.
- Use full invocation forwarding only when you need to inspect or transform the invocation.
- Keep the selector surface narrow and documented.

## Resolution and Forwarding Stages

### `resolveInstanceMethod:`

Add an implementation dynamically when the selector is known ahead of time.

```objective-c
+ (BOOL)resolveInstanceMethod:(SEL)sel {
    if (sel == @selector(dynamicTitle)) {
        class_addMethod(self, sel, (IMP)ZDGetDynamicTitle, "@@:");
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}
```

### `forwardingTargetForSelector:`

Use this for cheap handoff to a helper or composed collaborator.

```objective-c
- (id)forwardingTargetForSelector:(SEL)aSelector {
    if (aSelector == @selector(reloadData)) {
        return self.adapter;
    }
    return [super forwardingTargetForSelector:aSelector];
}
```

### `methodSignatureForSelector:`

Return a method signature when you cannot resolve the selector directly and need full forwarding.

```objective-c
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *signature = [super methodSignatureForSelector:aSelector];
    if (!signature && [self.invocationTarget respondsToSelector:aSelector]) {
        signature = [self.invocationTarget methodSignatureForSelector:aSelector];
    }
    return signature;
}
```

### `forwardInvocation:`

Inspect or reroute the invocation once a signature exists.

```objective-c
- (void)forwardInvocation:(NSInvocation *)invocation {
    if ([self.invocationTarget respondsToSelector:invocation.selector]) {
        [invocation invokeWithTarget:self.invocationTarget];
        return;
    }
    [super forwardInvocation:invocation];
}
```

## Concrete Use Cases

- Lightweight proxy that forwards a subset of selectors to a composed helper
- Compatibility shim while migrating from one service object to another
- Test double or recorder that intercepts a known small selector set

## Anti-Patterns

- Using forwarding to hide missing architecture boundaries
- Forwarding large portions of an API surface that should be exposed explicitly
- Returning a broad fallback target for unrelated selectors and masking typos
- Forgetting that `respondsToSelector:` and `conformsToProtocol:` may also need proxy-aware behavior

## Common Traps

- Returning `nil` method signatures and causing an unrecognized selector crash later than expected
- Forwarding to an object with a mismatched method signature
- Debugging tools showing the proxy object while the real behavior happens elsewhere
