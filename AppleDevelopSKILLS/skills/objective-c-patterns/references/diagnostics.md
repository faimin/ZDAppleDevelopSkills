# Diagnostics

## When to Use

Use this reference when triaging crashes, leaks, retain cycles, or behavior regressions that might come from ownership, threading, or runtime mutation.

## Preferred Choices

- Reproduce the symptom first.
- Classify the failure before editing code: bad access, lifetime mismatch, cycle, queue violation, or swizzle interaction.
- Prefer the simplest explanation that matches the evidence.

## EXC_BAD_ACCESS Triage

`EXC_BAD_ACCESS` usually means an object or pointer was used after deallocation, memory was corrupted, or a selector was sent through the wrong object.

```objective-c
- (void)handleCompletion {
    NSAssert(self.client != nil, @"client should still exist here");
    [self.client finishRequest];
}
```

Checklist:

- Enable Zombies when possible to confirm messaging a deallocated object.
- Check recent async callbacks, delegate lifetimes, and raw pointer storage.
- Inspect whether a swizzle or forwarding path changed the receiver unexpectedly.

## Over-Released or Unexpectedly Deallocated Objects

Focus on the owner that should have kept the object alive.

```objective-c
@property (nonatomic, weak) id<ZDWorkerDelegate> delegate;
@property (nonatomic, strong) ZDSession *session;
```

Ask:

- Should this property be strong, weak, assign, or copy?
- Did a temporary object fall out of scope before the callback fired?
- Did a captured weak reference disappear because nothing actually owned the object?

## Retain-Cycle Checklist

- Does `self` store a block that captures `self`?
- Does a timer, display link, or notification token indirectly retain the owner?
- Is a delegate declared strong when the relationship is bidirectional?
- Did an associated object add another owning edge?

## Swizzle Collision Symptoms

Look for these signals:

- Hooks run twice or not at all
- The original implementation stops executing
- Behavior changes only when another library is linked
- Crashes happen during app startup or first message send

If swizzle collision is plausible, inspect all categories touching the same selector and verify each one still calls through correctly.

## Common Traps

- Treating all `EXC_BAD_ACCESS` crashes as over-release without checking threading and pointer misuse
- Fixing leaks by manually niling random references instead of removing the ownership loop
- Assuming the most recent code change is the true lifetime owner
- Ignoring swizzles and forwarding layers during crash triage because they are "infrastructure"
