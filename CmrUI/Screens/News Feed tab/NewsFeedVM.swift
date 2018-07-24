//
//  NewsFeedVM.swift
//  CmrUI
//
//  Created by Vasyl on 7/22/18.
//  Copyright © 2018 Vasyl.Savka. All rights reserved.
//

import UIKit

private struct Constants {
    
    let kImgCellHeight: CGFloat = 0.866
    let kImgName = "pict_"
    let backgroundColor = UIColor(red: 235.0/255.0, green: 235.0/255.0, blue: 235.0/255.0, alpha: 1.0)
}

protocol NewsFeedVMProtocol {
    func updateDataSource()

}

protocol NewsFeedDataSource {
    func feedItemForRowAtItemIndex(index: Int) -> FeedItem?
    func populateDataSource()
    var count: Int { get }
}

class NewsFeedVM: NewsFeedDataSource {
    var count: Int {
        get {
            return dataSource.count
        }
    }
    
    var dataSource = [FeedItem]()
    
    fileprivate var delegate: NewsFeedVMProtocol?
    
    init(delegate: NewsFeedVMProtocol) {
        self.delegate = delegate
    }
    
    func populateDataSource() {
        dataSource = [
            FeedItem(image: UIImage(named: Constants().kImgName + "\(1)"), title: "First title", subtitle: "First subtitle", content: "First content", feedType: FeedType.feedImage),
            FeedItem(image: nil, title: "First text title", subtitle: "Only text subtitle", content: "", feedType: FeedType.feedText),
            FeedItem(image: UIImage(named: Constants().kImgName + "\(2)"), title: "Second title", subtitle: "Second subtitle", content: "Second content", feedType: FeedType.feedImage),
            FeedItem(image: UIImage(named: Constants().kImgName + "\(3)"), title: "Third title", subtitle: "Third subtitle", content: "The photographs are stunning: a giant mountain of ice towers over a tiny village, with colorful homes reminiscent of little doll houses against the stark, blue-gray landscape.\nBut for the people living in those houses – that beauty could be life-threatening.\nIts kind of like, if you lived in the suburbs, and you woke up one morning and looked out, and there was a skyscraper next to your house,\n says David Holland, an oceanographer at New York University who does research in Greenland during the summer months.I'd be the first to get out of there.\nHe says that's why authorities have taken action to evacuate those living closest to the water from the village of Innaarsuit, where the iceberg has parked itself just off the coast. According to the BBC, the village has just 169 residents.\nIn these shallow bays, these icebergs may drift in and become stuck, grounded on the sea floor, Holland says.So that's what happened to one of these bergs.Holland says it can be quite alarming for residents. Article continues after sponsorship These are small villages with little houses located right at the shoreline, and all of a sudden icebergs show up, and they look like New York skyscrapers, they're just towering, he says.They're very unstable, and they can break up.\nLast year in northwestern Greenland, four people died when a landslide resulted in a tsunami that swamped a number of homes.That disaster is fresh in peoples' minds, says glaciologist Anna Hogg at the University of Leeds, who also does research in Greenland.\nMassive Iceberg Makes A Stop Off Newfoundland Coast World Massive Iceberg Makes A Stop Off Newfoundland Coast There's a risk that a large chunk of ice could break off this very large iceberg, fall into the ocean, and cause a mini-tidal wave that will wash up and hit the village, Dr. Hogg says.\n We know that icebergs are quite fragile things, they've got lots of fractures through them, she adds.\n\nOne surprising thing about many of the seaside communities in Greenland, Hogg says, is that despite the marine-based economy, most people can't swim. Hogg has spent a lot of time doing research near the village that's currently under threat from the iceberg, and says this adds to the risk of a potential tidal wave or flooding.\nThere's only one swimming pool in Greenland. It's in Nuuk, which is much further down the coast than this village that we're talking about, Hogg says. If you think about it, why would they be able to swim? The ocean water is just so cold; you can't even put your toe in without it being unbearably freezing.\nLocal authorities and media are keeping close watch on the iceberg: the newspaper Sermitsiaq reported today that it moved 500-600 meters during the night.\nThough the process of glaciers losing ice is natural, and happens every summer, the waters around Greenland have warmed in recent decades, which means that it's happening at a faster rate.", feedType: FeedType.feedImage),
            FeedItem(image: UIImage(named: Constants().kImgName + "\(4)"), title: "Fourth title", subtitle: "Fourth subtitle", content: "Fourth content", feedType: FeedType.feedImage),
            FeedItem(image: nil, title: "A huge iceberg has drifted close to a village in western Greenland, prompting a partial evacuation in case it splits and the resulting wave swamps homes.",
                     subtitle: "Massive iceberg threatens Greenland village", content: "The photographs are stunning: a giant mountain of ice towers over a tiny village, with colorful homes reminiscent of little doll houses against the stark, blue-gray landscape.\nBut for the people living in those houses – that beauty could be life-threatening.\nIts kind of like, if you lived in the suburbs, and you woke up one morning and looked out, and there was a skyscraper next to your house,\n says David Holland, an oceanographer at New York University who does research in Greenland during the summer months.I'd be the first to get out of there.\nHe says that's why authorities have taken action to evacuate those living closest to the water from the village of Innaarsuit, where the iceberg has parked itself just off the coast. According to the BBC, the village has just 169 residents.\nIn these shallow bays, these icebergs may drift in and become stuck, grounded on the sea floor, Holland says.So that's what happened to one of these bergs.Holland says it can be quite alarming for residents. Article continues after sponsorship These are small villages with little houses located right at the shoreline, and all of a sudden icebergs show up, and they look like New York skyscrapers, they're just towering, he says.They're very unstable, and they can break up.\nLast year in northwestern Greenland, four people died when a landslide resulted in a tsunami that swamped a number of homes.That disaster is fresh in peoples' minds, says glaciologist Anna Hogg at the University of Leeds, who also does research in Greenland.\nMassive Iceberg Makes A Stop Off Newfoundland Coast World Massive Iceberg Makes A Stop Off Newfoundland Coast There's a risk that a large chunk of ice could break off this very large iceberg, fall into the ocean, and cause a mini-tidal wave that will wash up and hit the village, Dr. Hogg says.\n We know that icebergs are quite fragile things, they've got lots of fractures through them, she adds.\n\nOne surprising thing about many of the seaside communities in Greenland, Hogg says, is that despite the marine-based economy, most people can't swim. Hogg has spent a lot of time doing research near the village that's currently under threat from the iceberg, and says this adds to the risk of a potential tidal wave or flooding.\nThere's only one swimming pool in Greenland. It's in Nuuk, which is much further down the coast than this village that we're talking about, Hogg says. If you think about it, why would they be able to swim? The ocean water is just so cold; you can't even put your toe in without it being unbearably freezing.\nLocal authorities and media are keeping close watch on the iceberg: the newspaper Sermitsiaq reported today that it moved 500-600 meters during the night.\nThough the process of glaciers losing ice is natural, and happens every summer, the waters around Greenland have warmed in recent decades, which means that it's happening at a faster rate."
                ,
                     feedType: FeedType.feedText),
            FeedItem(image: UIImage(named: Constants().kImgName + "\(5)"), title: "Fifth title", subtitle: "Fifth subtitle", content: "Fifth content", feedType: FeedType.feedImage)
        ]
        
        dataSource.sort(by: sorterTime)
    }
    
    func updateDataSource() {
        populateDataSource()
    }
    
    func feedItemForRowAtItemIndex(index: Int) -> FeedItem? {
        return dataSource[index]
    }
    
    fileprivate func sorterTime(this: FeedItem, that: FeedItem) -> Bool {
        if let thisTime = this.time, let thatTime = that.time {
            return thisTime > thatTime
        }
        else {
            return false
        }
    }
}
