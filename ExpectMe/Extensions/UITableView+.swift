//
//  UIView.swift
//  Snikpic Swift
//
//  Created by Vasyl Boichuk on 3/26/19.
//  Copyright © 2018 MobileDev. All rights reserved.
//

import UIKit

extension UITableView {
    public func register<T: UITableViewCell>(_: T.Type) {
        register(T.self, forCellReuseIdentifier: String(describing: T.self))
    }

    public func dequeue<T: UITableViewCell>(_: T.Type) -> T {
        return dequeueReusableCell(withIdentifier: String(describing: T.self)) as? T ?? T()
    }

    public func dequeue<T: UITableViewHeaderFooterView>(_: T.Type) -> T {
        return dequeueReusableHeaderFooterView(withIdentifier: String(describing: T.self)) as? T ?? T()
    }
}

extension UICollectionView {
    public func register<T: UICollectionViewCell>(_: T.Type) {
        register(T.self, forCellWithReuseIdentifier: String(describing: T.self))
    }
}
