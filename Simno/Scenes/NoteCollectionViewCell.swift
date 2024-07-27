//
//  NoteCollectionViewCell.swift
//  Simno
//
//  Created by Владислав Горелов on 27.07.2024.
//

import UIKit

class NoteCollectionViewCell: UICollectionViewCell {

    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    let dateLabel = UILabel()
    let colorView = UIView()
    let actionIcon = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        contentView.backgroundColor = .snBackgroundCell
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 1 
        contentView.layer.borderColor = UIColor.snCellBorder.cgColor
        colorView.backgroundColor = .green
        contentView.addSubview(colorView)

        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        titleLabel.textColor = .snText
        titleLabel.numberOfLines = 0
        contentView.addSubview(titleLabel)

        descriptionLabel.font = UIFont.systemFont(ofSize: 15)
        descriptionLabel.textColor = .snText
        descriptionLabel.numberOfLines = 0
        contentView.addSubview(descriptionLabel)

        dateLabel.font = UIFont.systemFont(ofSize: 10)
        dateLabel.textColor = .gray
        contentView.addSubview(dateLabel)

        actionIcon.image = UIImage(systemName: "trash")
        actionIcon.tintColor = .gray
        contentView.addSubview(actionIcon)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setColorViewCorners()
    }

    private func setColorViewCorners() {
        let maskPath = UIBezierPath(roundedRect: colorView.bounds,
                                    byRoundingCorners: [.topLeft, .bottomLeft],
                                    cornerRadii: CGSize(width: 10, height: 10))
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        colorView.layer.mask = maskLayer
    }

    private func setupConstraints() {
        colorView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        actionIcon.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            colorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            colorView.topAnchor.constraint(equalTo: contentView.topAnchor),
            colorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            colorView.widthAnchor.constraint(equalToConstant: 10),

            titleLabel.leadingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: 8),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: actionIcon.leadingAnchor, constant: -8),

            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            descriptionLabel.trailingAnchor.constraint(equalTo: actionIcon.leadingAnchor, constant: -8),

            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dateLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 4),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            dateLabel.trailingAnchor.constraint(equalTo: actionIcon.leadingAnchor, constant: -8),

            actionIcon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            actionIcon.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            actionIcon.widthAnchor.constraint(equalToConstant: 20),
            actionIcon.heightAnchor.constraint(equalToConstant: 20)
        ])

        DispatchQueue.main.async {
            self.setColorViewCorners()
        }
    }

    func configure(with title: String, description: String, date: String, iconColor: UIColor) {
        titleLabel.text = title
        descriptionLabel.text = description
        dateLabel.text = date
        colorView.backgroundColor = iconColor
    }
}
