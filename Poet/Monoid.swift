//
//  Monoid.swift
//  Poet
//
//  Created by Mikael Konutgan on 20/05/15.
//  Copyright (c) 2015 Mikael Konutgan. All rights reserved.
//

public protocol Monoid {
    static var mempty: Self { get }
    func mappend(m: Self) -> Self
}

infix operator <> {
    associativity left
    precedence 140
}

func <><T where T: Monoid>(m: T, n: T) -> T {
    return m.mappend(n)
}

extension String: Monoid {
    public static var mempty: String {
        return ""
    }
    
    public func mappend(m: String) -> String {
        return self + m
    }
}

extension Int: Monoid {
    public static var mempty: Int {
        return 0
    }
    
    public func mappend(m: Int) -> Int {
        return self + m
    }
}
