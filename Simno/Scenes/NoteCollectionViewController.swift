//
//  NoteCollectionViewController.swift
//  Simno
//
//  Created by Владислав Горелов on 27.07.2024.
//

import UIKit

class NoteCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var notes: [(title: String, description: String, date: String, color: UIColor)] = [
        ("Заголовок 1", "Поливать растения", "20.07.2024, 11:24", .snColor1),
        ("Заголовок 2", "Купить продукты", "20.07.2024, 13:42", .snColor2),
        ("Заголовок 3", "Забрать посылку", "20.07.2024, 09:30", .snColor3)
    ]

    let collectionView: UICollectionView

    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .snBackground
        view.addSubview(collectionView)

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .snBackground
        collectionView.register(NoteCollectionViewCell.self, forCellWithReuseIdentifier: "NoteCell")

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    // MARK: - UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return notes.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoteCell", for: indexPath) as! NoteCollectionViewCell
        let note = notes[indexPath.item]
        cell.configure(with: note.title, description: note.description, date: note.date, iconColor: note.color)
        return cell
    }

    // MARK: - UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 100)
    }
}
