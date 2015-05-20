//
//  Writer.swift
//  Poet
//
//  Created by Mikael Konutgan on 20/05/15.
//  Copyright (c) 2015 Mikael Konutgan. All rights reserved.
//

public struct Writer<M: Monoid, T> {
    private let t: T
    private let m: M
    
    public init(_ t: T, _ m: M) {
        self.t = t
        self.m = m
    }
    
    public static func pure(t: T) -> Writer<M, T> {
        return Writer(t, M.mempty)
    }
    
    func bind(f: T -> Writer<M, T>) -> Writer<M, T> {
        let newWriter = f(t)
        return Writer(newWriter.t, m <> newWriter.m)
    }
    
    public static func tell(m: M)(t: T) -> Writer<M, T> {
        return Writer(t, m)
    }
    
    public func run() -> (T, M) {
        return (t, m)
    }
}

public func >>=<M: Monoid, T>(w: Writer<M, T>, f: T -> Writer<M, T>) -> Writer<M, T> {
    return w.bind(f)
}

public func ==<M: protocol<Monoid, Equatable>, T: Equatable>(w1: Writer<M, T>, w2: Writer<M, T>) -> Bool {
    return w1.m == w2.m && w1.t == w2.t
}
