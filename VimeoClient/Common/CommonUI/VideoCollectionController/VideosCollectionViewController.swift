//
//  VideosCollectionViewController.swift
//  tvOSClient
//
//  Created by Uladzislau Abramchuk on 6/9/20.
//  Copyright © 2020 Uladzislau Abramchuk. All rights reserved.
//

import UIKit

class VideosCollectionViewController
    <
    Item: Hashable,
    Cell: ConfigurableVideoCell<Item>
    >: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    enum Section {
        case main
    }
    
    @IBOutlet private(set) weak var collectionView: UICollectionView!
    
    private var videos: [Item] = []
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>! = nil
    private var selectionAction: ((Item) -> Void)?
    private var footerAction: (() -> Void)?
    
    required init() {
        super.init(nibName: Self.identifier, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.remembersLastFocusedIndexPath = true
        footerAction = { [weak self] in
            self?.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0),
                                             at: .top,
                                             animated: true)
        }
        configCollection()
    }
    
    override var preferredFocusEnvironments: [UIFocusEnvironment] {
        return [collectionView]
    }
    
//    MARK: - Colection delegate.
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let video = dataSource.itemIdentifier(for: indexPath) else { return }
        didSelect(video: video)
    }
    #if os(tvOS)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if videos.isEmpty { return CGSize.zero }
        return CGSize(width: 120, height: 120)
    }
    #endif
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        setNeedsFocusUpdate()
    }
    
//    MARK:- Public method.
    func setSelectionAction(handler: @escaping (Item) -> Void) {
        selectionAction = handler
    }
    
    func setFooterAction(handler: @escaping () -> Void) {
        footerAction = handler
    }
}

private extension VideosCollectionViewController {
    func configCollection() {
        collectionView.delegate = self
        collectionView.register(cellClass: Cell.self)

        dataSource = UICollectionViewDiffableDataSource
            <Section, Item>(collectionView: collectionView)
            { (collection, index, item) -> UICollectionViewCell? in
                let cell = collection.dequeueReusableCell(cellClass: Cell.self, for: index)
                cell.config(for: item)
                return cell
        }
        
        
        #if os(tvOS)
        collectionView.registerNib(VideoCollectionFooter.self,
                                   forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter)
        dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            
            guard kind == UICollectionView.elementKindSectionFooter else {
                return nil
            }
            let view = collectionView
                .dequeueReusableSupplementaryView(cellClass: VideoCollectionFooter.self,
                                                  ofKind: UICollectionView.elementKindSectionFooter,
                                                  for: indexPath)
            view.setScrollToTopButtonAction(handler: self?.footerAction)
            return view
        }
        #endif
        
        updateUI(animated: false)
    }
    
    func currentSnapShot() -> NSDiffableDataSourceSnapshot<Section, Item> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(videos)
        return snapshot
    }
    
    func updateUI(animated: Bool = true) {
        let snapshot = currentSnapShot()
        dataSource.apply(snapshot, animatingDifferences: animated)
    }
}

extension VideosCollectionViewController {
    func update(for videos: [Item]) {
        self.videos = videos
        updateUI()
    }
    
    func didSelect(video: Item) {
        guard let action = selectionAction else { return }
        action(video)
    }
}
