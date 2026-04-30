# Codable

Use this file when the question is about mapping external payloads into Swift models, preserving resilience, or diagnosing decoding failures.

## When to use
- Designing API models with `Decodable` or `Codable`.
- Mapping snake_case or otherwise mismatched payload keys.
- Handling dates, binary data, lossy arrays, or mixed payload formats.
- Decoding heterogeneous arrays or tagged unions without falling back to `[String: Any]`.

## Preferred modern choices
- Prefer strongly typed `struct` models with explicit `CodingKeys` when payload keys are unstable or inconsistent.
- Prefer `JSONDecoder` and `JSONEncoder` strategies over custom parsing when the format is regular.
- Prefer resilient wrappers for lossy or partial payloads instead of crashing the entire decode.
- Model heterogeneous payloads with enums or nested containers instead of dynamic dictionaries when the schema is knowable.

## CodingKeys
```swift
struct User: Codable, Sendable {
    let id: Int
    let displayName: String

    enum CodingKeys: String, CodingKey {
        case id = "user_id"
        case displayName = "display_name"
    }
}
```

## Date and data strategies
Keep strategies local to the decoder or encoder that matches the API contract.

```swift
let decoder = JSONDecoder()
decoder.dateDecodingStrategy = .iso8601
decoder.dataDecodingStrategy = .base64
let user = try decoder.decode(User.self, from: data)
```

For mixed date formats, use a custom strategy and fail with a useful debug description instead of guessing silently.

## Lossy or resilient decoding
Use wrappers when one bad element should not invalidate an entire list.

```swift
struct LossyArray<Element: Decodable>: Decodable {
    let values: [Element]

    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        var output: [Element] = []

        while !container.isAtEnd {
            do {
                let value = try container.decode(Element.self)
                output.append(value)
            } catch {
                _ = try container.decode(Discard.self)
            }
        }

        values = output
    }
}

private struct Discard: Decodable {}
```

## Mixed `String` and `Int` fields
When an API sends the same field as either a string or an integer, normalize it in one place instead of spreading ad hoc fallback logic across models.

```swift
struct StringBackedInt: Codable, Sendable, Hashable {
    let value: Int

    init(_ value: Int) {
        self.value = value
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let intValue = try? container.decode(Int.self) {
            value = intValue
            return
        }

        let stringValue = try container.decode(String.self)
        guard let intValue = Int(stringValue) else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Expected Int or numeric String"
            )
        }
        value = intValue
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(value)
    }
}

struct User: Decodable, Sendable {
    let id: StringBackedInt
}
```

If the domain model should expose `String` instead, mirror the same wrapper in the opposite direction and keep the inconsistency out of the rest of the app.

## Heterogeneous payload handling
When payload variants are tagged, decode into an enum with a discriminator.

```swift
enum FeedItem: Decodable {
    case article(Article)
    case video(Video)

    enum CodingKeys: String, CodingKey {
        case kind
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        switch try container.decode(String.self, forKey: .kind) {
        case "article":
            self = .article(try Article(from: decoder))
        case "video":
            self = .video(try Video(from: decoder))
        default:
            throw DecodingError.dataCorruptedError(
                forKey: .kind,
                in: container,
                debugDescription: "Unsupported feed item kind"
            )
        }
    }
}
```

## Common traps
- Relying on `.convertFromSnakeCase` when the server keys are inconsistent or acronym-heavy.
- Hiding payload problems by turning everything into optional properties.
- Mixing decoder strategies globally across unrelated APIs.
- Repeating `decodeIfPresent(Int.self) ?? Int(try decode(String.self))` throughout many models instead of centralizing the rule in a wrapper.
- Falling back to `[String: Any]` before trying enums, nested containers, or resilient wrappers.
