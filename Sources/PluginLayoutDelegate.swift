//
//  PluginLayoutDelegate.swift
//  Example
//
//  Created by Andrea Altea on 03/07/2019.
//  Copyright © 2019 Stefano Mondino. All rights reserved.
//

import UIKit

public protocol PluginType {
    func layoutAttributes(in section: Int, offset: inout CGPoint, layout: PluginLayout) -> [UICollectionViewLayoutAttributes]
    func layoutAttributesForElements(in rect: CGRect, from attributes: [UICollectionViewLayoutAttributes], section: Int,  layout: PluginLayout) -> [UICollectionViewLayoutAttributes]
}

public protocol Plugin: PluginType {
    associatedtype Delegate = UICollectionViewDelegateFlowLayout
    init(delegate: Delegate)
}

public extension Plugin {
    func layoutAttributesForElements(in rect: CGRect, from attributes: [UICollectionViewLayoutAttributes], section: Int, layout: PluginLayout) -> [UICollectionViewLayoutAttributes] {
        return attributes.filter { $0.frame.intersects(rect) }
    }
}

public protocol PluginLayoutDelegate: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: PluginLayout, pluginForSectionAt section: Int) -> PluginType?
    
}

extension PluginLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: PluginLayout, pluginForSectionAt section: Int) -> PluginType? {
        return nil
    }
}
