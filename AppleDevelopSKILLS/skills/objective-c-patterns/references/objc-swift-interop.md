# Objective-C and Swift Interop

## When to Use

Use this reference before designing APIs that cross the Objective-C and Swift boundary in either direction.

## Preferred Choices

- Add nullability everywhere on Objective-C surfaces intended for Swift.
- Prefer Objective-C APIs with simple class types, enums, option sets, and completion blocks.
- Expose narrow Swift adapter APIs to Objective-C instead of leaking Swift-only language features.
- Review naming from the caller's side, not just the declaration side.

## Nullability

Objective-C without nullability imports poorly into Swift. Mark pointer types as nullable or nonnull so Swift sees the right optionality.

```objective-c
NS_ASSUME_NONNULL_BEGIN

- (void)loadUserWithID:(NSString *)userID
            completion:(void (^ _Nonnull)(ZDUser * _Nullable user, NSError * _Nullable error))completion;

@property (nullable, nonatomic, copy) NSString *cachedDisplayName;

NS_ASSUME_NONNULL_END
```

Inside `NS_ASSUME_NONNULL`, explicitly mark the exceptions. In this example, `userID` and the completion block are required, while the returned `ZDUser`, `NSError`, and cached display name may be absent.

## Naming Translation

Swift drops Objective-C boilerplate when names are shaped correctly.

```objective-c
- (void)presentProfileForUserID:(NSString *)userID animated:(BOOL)animated;
```

Swift imports this as:

```swift
presentProfile(forUserID: userID, animated: true)
```

Use clear first arguments and avoid redundant class-name prefixes inside method names.

## Enum and Option Set Bridging

Prefer `NS_ENUM` and `NS_OPTIONS` so Swift sees strong types.

```objective-c
typedef NS_ENUM(NSInteger, ZDSyncState) {
    ZDSyncStateIdle,
    ZDSyncStateRunning,
    ZDSyncStateFailed,
};

typedef NS_OPTIONS(NSUInteger, ZDDisplayOptions) {
    ZDDisplayOptionsShowsAvatar = 1 << 0,
    ZDDisplayOptionsShowsBadge = 1 << 1,
};
```

## Exposing Swift APIs Safely to Objective-C

Objective-C can only see Swift APIs that are `@objc` compatible.

```swift
struct UserViewModel {
    let title: String
}

final class UserPresenter: NSObject {
    @objc(presentUserWithID:animated:)
    func present(userID: String, animated: Bool) {
        // Bridge-friendly surface
    }

    func makeViewModel() -> UserViewModel {
        UserViewModel(title: "Profile")
    }
}
```

Rules:

- Inherit from `NSObject` when the API must be visible to Objective-C.
- Expose only the bridge-facing API with targeted `@objc` annotations instead of broad `@objcMembers`.
- Avoid exposing Swift generics, structs without wrappers, tuples, async-only methods, and Swift enums without Objective-C representation.
- Prefer Objective-C facing wrapper methods for async Swift code.

## Common Traps

- Leaving Objective-C headers unannotated and forcing Swift into implicitly unwrapped optionals.
- Exposing Swift methods that compile but produce awkward or unstable Objective-C names.
- Returning Swift-only types to Objective-C callers.
- Designing mixed-language APIs before checking what the other side can actually import.
