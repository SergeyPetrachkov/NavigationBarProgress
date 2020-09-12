# NavigationBarProgress

A simple drop-in library to show pending state in navigation bar (like Telegram does when refreshing chats).

Trivial usage sample:

```Swift
final class ViewController: UIViewController, INavigationBarProgressContainer {

  private var isPending: Bool = false

  var activityView: UIView & INavigationBarProgressView = NavigationBarProgressView(
      config: .init(
        interItemSpace: 8,
        regularTitle: "Regular",
        pendingTitle: "Updating...",
        titleFont: .systemFont(ofSize: 16, weight: .medium)
      )
  )

  override func viewDidLoad() {
    super.viewDidLoad()
    self.attach(navigationActivityView: self.activityView)
  }

  @IBAction func didTapButton(_ sender: Any) {
    if self.isPending {
      self.stopNavigationActivity()
    } else {
      self.startNavigationActivity()
    }
    self.isPending.toggle()
  }
}
```

Result:

![gif](https://i.imgur.com/86OySqO.gif)

[Read more](https://www.notion.so/Activity-indicator-in-UINavigationItem-a49a7435039b452dbce01af9462007c3)
