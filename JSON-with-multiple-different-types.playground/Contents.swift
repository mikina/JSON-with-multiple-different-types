import UIKit

let json = """
[
    {
        "id": 1,
        "name": "Watermarking photos with ImageMagick, Vapor 3 and Swift on macOS and Linux",
        "type": "articles",
        "photo": "https://mikemikina.com/assets/imagemagick-vapor-3/watermarked-photo.png",
        "tags": ["Tutorial", "Vapor"]
    },
    {
        "id": 2,
        "name": "New Apple M1X silicon",
        "type": "news",
        "date": 1614869586,
        "intro": "The M1 successor could boast double the GPU performance"
    },
    {
        "id": 3,
        "name": "Passing weak self into a closure",
        "type": "videos",
        "views": 120,
        "category": "Swift"
    }
]
""".data(using: .utf8)!

struct ListElement: Decodable {
    let id: Int
    let name: String
    let type: Element

    enum Element: Decodable {
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let type = try container.decode(ElementType.self, forKey: .type)

            switch type {
            case .articles:
                self = .articles(try .init(from: decoder))
            case .news:
                self = .news(try .init(from: decoder))
            case .videos:
                self = .videos(try .init(from: decoder))
            }
        }

        enum ElementType: String, Decodable {
            case articles
            case news
            case videos
        }

        enum CodingKeys: String, CodingKey {
            case type
        }

        case articles(Articles), news(News), videos(Videos)

        struct Articles: Decodable {
            let photo: URL
            let tags: [String]
        }

        struct News: Decodable {
            let date: Date
            let intro: String
        }

        struct Videos: Decodable {
            let views: Int
            let category: String
        }
    }

    enum CodingKeys: String, CodingKey {
        case id, name, type
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.type = try .init(from: decoder)
    }
}

let elements = try JSONDecoder().decode([ListElement].self, from: json)
print(elements)

