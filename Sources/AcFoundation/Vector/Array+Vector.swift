import Foundation

extension Array where Element: AdditiveArithmetic {
    static func &+ (lhs: Self, rhs: Self) -> Self { zip(lhs,rhs).map(+) }
    static func &+ (lhs: Self, rhs: Element) -> Self { zip(lhs,repeatElement(rhs, count: lhs.count)).map(+) }
    static func &+ (lhs: Element, rhs: Self) -> Self { zip(repeatElement(lhs, count: rhs.count),rhs).map(+) }
    static func &- (lhs: Self, rhs: Self) -> Self { zip(lhs,rhs).map(-) }
    static func &- (lhs: Self, rhs: Element) -> Self { zip(lhs,repeatElement(rhs, count: lhs.count)).map(-) }
    static func &- (lhs: Element, rhs: Self) -> Self { zip(repeatElement(lhs, count: rhs.count),rhs).map(-) }
}

extension Array where Element: Numeric {
    static func &* (lhs: Self, rhs: Self) -> Self { zip(lhs,rhs).map(*) }
    static func &* (lhs: Self, rhs: Element) -> Self { zip(lhs,repeatElement(rhs, count: lhs.count)).map(*) }
    static func &* (lhs: Element, rhs: Self) -> Self { zip(repeatElement(lhs, count: rhs.count),rhs).map(*) }
}

func dot<Element: Numeric>(_ lhs: Array<Element>,_ rhs: Array<Element>) -> Element {
    zip(lhs, rhs).map(*).reduce(0, +)
}

func length_squared<Element: Numeric>(_ rhs: Array<Element>) -> Element {
    dot( rhs, rhs)
}
