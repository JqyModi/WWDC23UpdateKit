//
//  MOJiAudioSettingVC.swift
//  TNShareApp
//
//  Created by J.qy on 2024/5/10.
//

import SwiftUI

import UIKit
import SnapKit

class ParameterSettingsViewController: UIViewController {
    
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let modeLabel = UILabel()
    private var modeButtons = RadioButtonGroup()
    private let playbackSpeedLabel = UILabel()
    private let sliderView = SlidingSliderView()
    private let playTimesLabel = UILabel()
    private var playTimesButtons = RadioButtonGroup()
    private let intervalLabel = UILabel()
    private var intervalButtons = RadioButtonGroup()
    private let autoRestartSwitch = UISwitch()
    private let autoRestartLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        configureConstraints()
    }
    
    private func setupViews() {
        titleLabel.text = "参数设置"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textColor = .black
        
        modeLabel.text = "注音模式"
        modeLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        modeLabel.textColor = .black
        
        modeButtons.titles = ["假名", "罗马音", "不注音"]
        
        playbackSpeedLabel.text = "播放倍速"
        playbackSpeedLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        playbackSpeedLabel.textColor = .black
        
        playTimesLabel.text = "播放遍数"
        playTimesLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        playTimesLabel.textColor = .black
        
        playTimesButtons.titles = ["1次", "2次", "3次", "4次", "5次", "无限次"]
        
        intervalLabel.text = "播放间隔"
        intervalLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        intervalLabel.textColor = .black
        
        intervalButtons.titles = ["0秒", "2秒", "5秒", "10秒", "15秒", "30秒"]
        
        autoRestartLabel.text = "自动播放下一句"
        autoRestartLabel.font = UIFont.systemFont(ofSize: 16)
        autoRestartLabel.textColor = .black
        
        autoRestartSwitch.isOn = false
        autoRestartSwitch.onTintColor = UIColor(hex: 0xE0315B)
        
        view.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(modeLabel)
        containerView.addSubview(modeButtons)
        containerView.addSubview(playbackSpeedLabel)
        containerView.addSubview(sliderView)
        containerView.addSubview(playTimesLabel)
        containerView.addSubview(playTimesButtons)
        containerView.addSubview(intervalLabel)
        containerView.addSubview(intervalButtons)
        containerView.addSubview(autoRestartSwitch)
        containerView.addSubview(autoRestartLabel)
    }
    
    private func configureConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        modeLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(33)
            make.leading.equalToSuperview()
        }
        
        modeButtons.snp.makeConstraints { make in
            make.top.equalTo(modeLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(32)
        }
        
        playbackSpeedLabel.snp.makeConstraints { make in
            make.top.equalTo(modeButtons.snp.bottom).offset(44)
            make.leading.equalToSuperview()
        }
        
        sliderView.snp.makeConstraints { make in
            make.top.equalTo(playbackSpeedLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
        
        playTimesLabel.snp.makeConstraints { make in
            make.top.equalTo(sliderView.snp.bottom).offset(44)
            make.leading.equalToSuperview()
        }
        
        playTimesButtons.snp.makeConstraints { make in
            make.top.equalTo(playTimesLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(55)
        }
        
        intervalLabel.snp.makeConstraints { make in
            make.top.equalTo(playTimesButtons.snp.bottom).offset(44)
            make.leading.equalToSuperview()
        }
        
        intervalButtons.snp.makeConstraints { make in
            make.top.equalTo(intervalLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(55)
        }
        
        autoRestartLabel.snp.makeConstraints { make in
            make.top.equalTo(intervalButtons.snp.bottom).offset(44)
            make.leading.equalToSuperview()
        }
        
        autoRestartSwitch.snp.makeConstraints { make in
            make.centerY.equalTo(autoRestartLabel)
            make.leading.greaterThanOrEqualTo(autoRestartLabel.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-16)
        }
    }
}

struct MOJiAudioSettingView: UIViewRepresentable {
    func updateUIView(_ uiView: UIView, context: Context) {}
    
    func makeUIView(context: Context) -> UIView {
        let view = ParameterSettingsViewController()
        return view.view
    }
    
}

#Preview {
    return MOJiAudioSettingView()
}




class RadioButtonGroup: UIView {
    
    private let stackView = UIStackView()
    private var selectedButton: RadioButton?
    var selectedIndex: Int = 0 {
        didSet {
            updateSelectedButton()
        }
    }
    
    var titles: [String] = [] {
        didSet {
            setupButtons()
        }
    }
    
    private let maxButtonsPerLine: Int = 3 // Adjust this value as needed
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(stackView)
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupButtons() {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        var currentLine: [UIView] = []
        var lines: [[UIView]] = []
        
        for (index, title) in titles.enumerated() {
            let button = createRadioButton(title: title, isSelected: index == selectedIndex)
            currentLine.append(button)
            
            if currentLine.count == maxButtonsPerLine || index == titles.count - 1 {
                
                // 添加额外占位
                if currentLine.count != maxButtonsPerLine {
                    let diffEmptyViewCount = maxButtonsPerLine - currentLine.count
                    for _ in 0..<diffEmptyViewCount {
                        currentLine.append(UIView())
                    }
                }
                
                lines.append(currentLine)
                currentLine.removeAll()
            }
        }
        
        for line in lines {
            let lineStackView = UIStackView(arrangedSubviews: line)
            lineStackView.distribution = .fillEqually
            lineStackView.spacing = 8
            stackView.addArrangedSubview(lineStackView)
        }
    }
    
    private func createRadioButton(title: String, isSelected: Bool) -> RadioButton {
        let radioBtn = RadioButton(title: title)
        radioBtn.tapBlock = { btn in
            self.radioButtonTapped(sender: btn)
        }
        return radioBtn
    }
    
    @objc private func radioButtonTapped(sender: RadioButton) {
        var buttonIndex = 0
        var lineIndex = 0
        
        for (index, stackView) in stackView.arrangedSubviews.enumerated() {
            guard let lineStackView = stackView as? UIStackView else { continue }
            if let idx = lineStackView.arrangedSubviews.firstIndex(of: sender) {
                buttonIndex = idx
                lineIndex = index
                break
            }
        }
        
        selectedIndex = lineIndex * maxButtonsPerLine + buttonIndex
    }
    
    private func updateSelectedButton() {
        for stackView in stackView.arrangedSubviews {
            guard let lineStackView = stackView as? UIStackView else { continue }
            for button in lineStackView.arrangedSubviews {
                guard let button = button as? RadioButton else { continue }
                button.isSelected = false
            }
        }
        
        var selectedButton: RadioButton?
        for (index, stackView) in stackView.arrangedSubviews.enumerated() {
            guard let lineStackView = stackView as? UIStackView else { continue }
            if let button = lineStackView.arrangedSubviews[safe: selectedIndex - (index * maxButtonsPerLine)] as? RadioButton {
                selectedButton = button
                break
            }
        }
        
        selectedButton?.isSelected = true
    }
}

extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

class RadioButton: UIView {
    lazy var normalImgView = {
        let imgView = UIImageView(image: UIImage(named: "ic_common_selected"))
        return imgView
    }()
    lazy var selectedImgView = {
        let imgView = UIImageView(image: UIImage(named: "ic_update_select"))
        return imgView
    }()
    lazy var titleLabel = {
        let title = UILabel()
        title.font = .systemFont(ofSize: 14)
        return title
    }()
    
    var isSelected: Bool = false {
        didSet {
            updateStyle()
        }
    }
    
    var tapBlock: ((RadioButton) -> Void)?
    
    var title: String?
    
    convenience init(title: String) {
        self.init(frame: .zero)
        
        self.title = title
        self.titleLabel.text = title
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupTap()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(normalImgView)
        addSubview(selectedImgView)
        addSubview(titleLabel)
        
        normalImgView.snp.makeConstraints { make in
            make.left.equalTo(8)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSizeMake(16, 16))
        }
        
        selectedImgView.snp.makeConstraints { make in
            make.left.equalTo(8)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSizeMake(16, 16))
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(normalImgView.snp.right).offset(8)
            make.centerY.equalToSuperview()
            make.right.equalTo(-8)
        }
        
        // 默认值
        isSelected = false
    }
    
    func setupTap() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapSelf)))
    }
    
    @objc func tapSelf() {
        tapBlock?(self)
    }
    
    func updateStyle() {
        if isSelected {
            normalImgView.isHidden = true
            selectedImgView.isHidden = false
        } else {
            normalImgView.isHidden = false
            selectedImgView.isHidden = true
        }
    }
}


struct RadioButtonGroupView: UIViewRepresentable {
    func updateUIView(_ uiView: UIView, context: Context) {}
    
    func makeUIView(context: Context) -> UIView {
        let radioButtonGroup = RadioButtonGroup(frame: CGRect(x: 0, y: 0, width: 375, height: 44))
        radioButtonGroup.titles = ["Option 1", "Option 2", "Option 3", "Option 4", "Option 5", "Option 6"]
        return radioButtonGroup
    }
    
}



// -------------------------

protocol SlidingSliderViewDelegate: AnyObject {
    func didSelectLevel(level: Float)
}

class SlidingSliderView: UIControl {
    
    weak var delegate: SlidingSliderViewDelegate?
    
    private let trackView = UIView()
    private let progressView = UIView()
    private let indicatorView = UIView()
    private let levelLabelsStackView = UIStackView()
    
    private var levels: [CGFloat] = [0.2, 0.4, 0.6, 0.8, 1.0, 1.2, 1.4, 1.6, 1.8, 2.0]
    // default to 1.0
    private var currentGearIndex: Int = 0 {
        didSet {
            updateStyle()
        }
    }
    
    private var loadFinished: Bool = false {
        didSet {
            if loadFinished {
                // 默认定位1.0位置
                updateGear(to: 4, animated: false)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupGestures()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
        setupGestures()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !loadFinished && trackView.width > 0 {
            loadFinished = true
        }
    }
    
    private func setupUI() {
        // 设置浅色线条
        addSubview(trackView)
        trackView.backgroundColor = UIColor(hex: 0xECECEC)
        trackView.layer.cornerRadius = 2 // 设置圆角
        trackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview() // 位置在顶部偏移10个点
            make.leading.trailing.equalToSuperview() // 横向铺满
            make.height.equalTo(4) // 高度为1
        }
        
        // 设置滑块
        addSubview(progressView)
        progressView.backgroundColor = UIColor(hex: 0xE0315B) // 滑块背景颜色
        progressView.layer.cornerRadius = 2 // 设置圆角
        progressView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(4) // 设置滑块高度
            make.leading.equalToSuperview() // 设置初始位置为最左边
            make.width.equalTo(0)
        }
        
        // 设置指示器
        progressView.addSubview(indicatorView)
        indicatorView.backgroundColor = UIColor(hex: 0xE0315B) // 指示器颜色
        indicatorView.layer.cornerRadius = 7 // 设置圆角
        indicatorView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.width.equalTo(14) // 设置指示器尺寸
            make.left.equalToSuperview()
        }
        
        // 设置级别文本
        addSubview(levelLabelsStackView)
        levelLabelsStackView.axis = .horizontal
        levelLabelsStackView.distribution = .equalSpacing
        levelLabelsStackView.snp.makeConstraints { make in
            make.top.equalTo(progressView.snp.bottom).offset(10) // 设置文本距离滑块底部的距离
            make.leading.trailing.equalToSuperview() // 将文本视图横向铺满
        }
        
        for level in levels {
            let label = UILabel()
            label.text = "\(level)"
            label.textColor = UIColor(hex: 0x8B8787)
            label.font = UIFont.systemFont(ofSize: 13)
            levelLabelsStackView.addArrangedSubview(label)
        }
    }
    
    private func setupGestures() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        addGestureRecognizer(panGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        addGestureRecognizer(tapGesture)
    }
    
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began, .changed:
            let translation = gesture.translation(in: self)
            updateGear(withTranslation: translation.x)
            
        case .ended, .cancelled:
            break
            
        default:
            break
        }
    }
    
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        let translation = gesture.location(in: self)
        updateGear(withTranslation: translation.x)
    }
    
    private func updateGear(withTranslation translation: CGFloat) {
        let newGearIndex = snapToNearestGearIndex(translation: translation)
        updateGear(to: newGearIndex, animated: true)
    }
    
    private func snapToNearestGearIndex(translation: CGFloat) -> Int {
        let ratio = translation / bounds.width
        let targetValue = ratio * (CGFloat(levels.count))
        let roundedValue = round(targetValue)
        
        return Int(max(0, min(roundedValue, CGFloat(levels.count - 1))))
    }
    
    private func updateGear(to index: Int, animated: Bool) {
        guard index != currentGearIndex else { return }
        
        let sigleWidth = bounds.width / CGFloat(levels.count-1)
        
        let gearValue = levels[index]
        var progressWidth = bounds.width * (gearValue/2)
        
        progressWidth = CGFloat(index) * sigleWidth
        
        let indicatorX = progressWidth - indicatorView.bounds.width / 2
        
        if animated {
            UIView.animate(withDuration: 0.3) {
                self.progressView.snp.updateConstraints { make in
                    make.width.equalTo(progressWidth)
                }
                self.indicatorView.snp.updateConstraints { make in
                    make.left.equalTo(indicatorX)
                }
                self.layoutIfNeeded()
            }
        } else {
            progressView.snp.updateConstraints { make in
                make.width.equalTo(progressWidth)
            }
            indicatorView.snp.updateConstraints { make in
                make.left.equalTo(indicatorX)
            }
            layoutIfNeeded()
        }
        
        currentGearIndex = index
        sendActions(for: .valueChanged)
        
        delegate?.didSelectLevel(level: Float(levels[index]))
    }

    func updateStyle() {
        levelLabelsStackView.arrangedSubviews.forEach { button in
            guard let button = button as? UILabel else { return }
            button.textColor = UIColor(hex: 0x8B8787)
        }
        
        if let selectedButton = levelLabelsStackView.arrangedSubviews[currentGearIndex] as? UILabel {
            selectedButton.textColor = UIColor(hex: 0xE0315B)
        }
    }
    
}


class TestGearView: UIView {
    
    lazy var slider: SlidingSliderView = {
        let view = SlidingSliderView()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        
        addSubview(slider)
        slider.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}

struct GearSliderView: UIViewRepresentable {
    func updateUIView(_ uiView: UIView, context: Context) {}
    
    func makeUIView(context: Context) -> UIView {
        let gearSlider = TestGearView(frame: CGRect(x: 0, y: 100, width: 375, height: 44))
        return gearSlider
    }
}
