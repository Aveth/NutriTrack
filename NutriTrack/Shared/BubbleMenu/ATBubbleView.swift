//
//  ATBubbleMenuView.swift
//  NutriTrack
//
//  Created by Avais on 2016-05-02.
//  Copyright © 2016 Aveth. All rights reserved.
//

import UIKit

protocol ATBubbleViewDataSource: class {
    func bubbleViewNumberOfItems(sender: ATBubbleView) -> Int
    func bubbleView(sender: ATBubbleView, titleForBubbleAtIndex index: Int) -> String
    func bubbleView(sender: ATBubbleView, imageForBubbleAtIndex index: Int) -> UIImage
    func bubbleView(sender: ATBubbleView, backgroundColorForBubbleAtIndex index: Int) -> UIColor
}

class ATBubbleView: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    weak internal var dataSource: ATBubbleViewDataSource?
    
    lazy private var collectionView: UICollectionView = {
        let layout = ATBubbleViewFlowLayout()
        layout.itemSize = CGSize(width: 50.0, height: 50.0)
        layout.minimumInteritemSpacing = 20.0
        layout.minimumLineSpacing = 20.0
        layout.scrollDirection = .Horizontal
        let collection = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collection.registerClass(ATBubbleViewCell.self, forCellWithReuseIdentifier: ATBubbleViewCell.reuseIdentifier)
        collection.dataSource = self
        collection.delegate = self
        collection.backgroundColor = UIColor.clearColor()
        return collection
    }()

    override internal init(frame: CGRect) {
        super.init(frame: frame)
        self.buildView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildView() {
        self.backgroundColor = UIColor.clearColor()
        self.addSubview(self.collectionView)
        self.setNeedsUpdateConstraints()
    }
    
    internal func reloadData() {
        self.collectionView.reloadData()
    }
    
    override internal func updateConstraints() {
        super.updateConstraints()
        self.collectionView.autoPinEdgesToSuperviewEdges()
    }
    
    // MARK: UICollectionViewDataSource methods
    
    internal func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Int.unwrapOrZero(self.dataSource?.bubbleViewNumberOfItems(self))
    }
    
    internal func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: ATBubbleViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(ATBubbleViewCell.reuseIdentifier, forIndexPath: indexPath) as! ATBubbleViewCell
        cell.title = self.dataSource?.bubbleView(self, titleForBubbleAtIndex: indexPath.row)
        cell.image = self.dataSource?.bubbleView(self, imageForBubbleAtIndex: indexPath.row)
        cell.backgroundColor = self.dataSource?.bubbleView(self, backgroundColorForBubbleAtIndex: indexPath.row)
        return cell
    }
    
    internal func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        if let numCells = self.dataSource?.bubbleViewNumberOfItems(self) {
            let edgeInsets: CGFloat = ((self.frame.width - (CGFloat(numCells) * 50)) / (CGFloat(numCells) + 1)) + (50.0 / 2)
            return UIEdgeInsets(top: 0.0, left: edgeInsets, bottom: 0.0, right: edgeInsets)
        }
        return UIEdgeInsetsZero;
    }
    
}
