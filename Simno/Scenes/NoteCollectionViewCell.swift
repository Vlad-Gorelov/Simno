//
//  NoteCollectionViewCell.swift
//  Simno
//
//  Created by Владислав Горелов on 27.07.2024.
//

import UIKit

protocol NoteCollectionViewCellDelegate: AnyObject {
    func didTapPinButton(on cell: NoteCollectionViewCell)
    func didTapDeleteButton(on cell: NoteCollectionViewCell)
    func didTapEditButton(on cell: NoteCollectionViewCell)
}

class NoteCollectionViewCell: UICollectionViewCell {

    weak var delegate: NoteCollectionViewCellDelegate?

    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    let dateLabel = UILabel()
    let colorView = UIView()
    let actionIcon = UIButton(type: .system)

    private let pinIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "pin.fill"))
        imageView.tintColor = .systemBlue
        imageView.isHidden = true
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        descriptionLabel.text = nil
        dateLabel.text = nil
        pinIcon.isHidden = true
    }

    private func setupViews() {
        contentView.backgroundColor = .snBackgroundCell
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 1
        contentView.layer.masksToBounds = true
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

        actionIcon.setImage(UIImage(named: "dots"), for: .normal)
        actionIcon.tintColor = .gray
        contentView.addSubview(actionIcon)

        contentView.addSubview(pinIcon)
    }

    private func setupConstraints() {
        colorView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        actionIcon.translatesAutoresizingMaskIntoConstraints = false
        pinIcon.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            colorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            colorView.topAnchor.constraint(equalTo: contentView.topAnchor),
            colorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            colorView.widthAnchor.constraint(equalToConstant: 8),

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
            actionIcon.heightAnchor.constraint(equalToConstant: 20),

            pinIcon.widthAnchor.constraint(equalToConstant: 16),
            pinIcon.heightAnchor.constraint(equalToConstant: 16),
            pinIcon.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -14),
            pinIcon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -14)
        ])
    }

    func setPinned(_ isPinned: Bool) {
        pinIcon.isHidden = !isPinned
        setupMenu()
    }

    private func setupMenu() {
        let pinTitle = pinIcon.isHidden ? "MenuPin".localized : "MenuUnpin".localized
        let pinImage = pinIcon.isHidden ? UIImage(named: "pin") : UIImage(named: "pin")

        let pinAction = UIAction(title: pinTitle, image: pinImage) { [weak self] action in
            guard let self = self else { return }
            self.delegate?.didTapPinButton(on: self)
        }

        let editAction = UIAction(title: "MenuEdit".localized, image: UIImage(named: "edit")) { [weak self] action in
            guard let self = self else { return }
            self.delegate?.didTapEditButton(on: self)
        }

        let deleteAction = UIAction(title: "MenuDelete".localized, image: UIImage(systemName: "trash"), attributes: .destructive) { [weak self] action in
            guard let self = self else { return }
            self.delegate?.didTapDeleteButton(on: self)
        }

        let menu = UIMenu(title: "", children: [editAction, pinAction, deleteAction])
        actionIcon.menu = menu
        actionIcon.showsMenuAsPrimaryAction = true
    }

    func configure(with title: String, description: String, date: String, iconColor: UIColor) {
        titleLabel.text = title
        descriptionLabel.text = description
        dateLabel.text = date
        colorView.backgroundColor = iconColor
    }
}
