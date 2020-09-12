import UIKit

public struct NavigationBarProgressViewConfigurator {
  public let activityStyle: UIActivityIndicatorView.Style
  public let frame: CGRect
  public let interItemSpace: CGFloat
  public let regularTitle: String
  public let pendingTitle: String
  public let titleColor: UIColor
  public let titleFont: UIFont

  public init(
    activityStyle: UIActivityIndicatorView.Style = .gray,
    frame: CGRect = .init(origin: .zero, size: .init(width: 120, height: 20)),
    interItemSpace: CGFloat,
    regularTitle: String,
    pendingTitle: String,
    titleColor: UIColor = .darkText,
    titleFont: UIFont
  ) {
    self.activityStyle = activityStyle
    self.frame = frame
    self.interItemSpace = interItemSpace
    self.regularTitle = regularTitle
    self.pendingTitle = pendingTitle
    self.titleColor = titleColor
    self.titleFont = titleFont
  }
}

public protocol INavigationBarProgressView: AnyObject {
  func didStartPending()
  func didStopPending()
}

public class NavigationBarProgressView: UIView {
  let activityIndicator: UIActivityIndicatorView

  let titleLabel: UILabel = {
    let label = UILabel(frame: .zero)
    return label
  }()

  private(set) var isPending: Bool = false

  let config: NavigationBarProgressViewConfigurator

  public init(config: NavigationBarProgressViewConfigurator) {
    self.config = config
    self.activityIndicator = UIActivityIndicatorView(style: config.activityStyle)
    self.activityIndicator.hidesWhenStopped = true
    super.init(frame: config.frame)
    self.titleLabel.font = config.titleFont
    self.titleLabel.text = config.regularTitle
    self.addSubview(self.activityIndicator)
    self.addSubview(self.titleLabel)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public override func layoutSubviews() {
    super.layoutSubviews()
    self.activityIndicator.frame.origin = .zero
    let maxWidth = self.isPending
      ? self.frame.width - self.activityIndicator.frame.size.width - self.config.interItemSpace
      : self.frame.width
    let maxTextSize = CGSize(
      width: maxWidth,
      height: self.activityIndicator.frame.height
    )
    let minTextSize = self.titleLabel.sizeThatFits(maxTextSize)
    let titleX = self.isPending
      ? self.activityIndicator.frame.maxX + self.config.interItemSpace
      : (maxWidth - minTextSize.width) / 2

    self.titleLabel.frame = CGRect(origin: .init(x: titleX,
                                                 y: (maxTextSize.height - minTextSize.height)/2),
                                   size: minTextSize)
  }
}

extension NavigationBarProgressView: INavigationBarProgressView {
  public func didStartPending() {
    self.isPending = true
    self.setNeedsLayout()
    self.activityIndicator.isHidden = false
    self.activityIndicator.startAnimating()
    self.titleLabel.text = self.config.pendingTitle
  }

  public func didStopPending() {
    self.isPending = false
    self.setNeedsLayout()
    self.activityIndicator.isHidden = true
    self.titleLabel.text = self.config.regularTitle
  }
}

public protocol INavigationBarProgressContainer: AnyObject {
  var activityView: INavigationBarProgressView & UIView { get set }
  func startNavigationActivity()
  func stopNavigationActivity()
}

public protocol IAttachableNavigationBarProgressContainer: AnyObject {
  func attach(navigationActivityView: INavigationBarProgressView & UIView)
}

extension UIViewController: IAttachableNavigationBarProgressContainer {
  public func attach(navigationActivityView: INavigationBarProgressView & UIView) {
    self.navigationItem.titleView = navigationActivityView
  }
}

public extension INavigationBarProgressContainer {
  func startNavigationActivity() {
    self.activityView.didStartPending()
  }

  func stopNavigationActivity() {
    self.activityView.didStopPending()
  }
}
