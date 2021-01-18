//
//  ViewController.swift
//  ToDoListApp
//
//  Created by Naratama on 17/01/21.
//

import UIKit
import CalendarKit


class ViewController: UIViewController {
    
    private let button: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 52))
        button.setTitle("Start", for: .normal)
        button.backgroundColor = .blue
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .white
        view.addSubview(button)
        
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        button.center = view.center
    }
    
    @objc func didTapButton() {
        let tabBarVC = UITabBarController()
        UITabBar.appearance().barTintColor = UIColor.white

        let vc1 = FirstViewController()
        let vc2 = SecondViewController()
        let vc3 = ThirdViewController()
        
        vc1.title = "Task"
        vc3.title = "Setting"

        tabBarVC.setViewControllers([vc1, vc2, vc3], animated: false)
        
        guard let items = tabBarVC.tabBar.items else {
            return
        }
        
        let images = ["rectangle.grid.1x2","plus.square.fill","gear"]
        
        for x in 0..<items.count {
            items[x].image = UIImage(systemName: images[x])
        }
        
        tabBarVC.modalPresentationStyle = .fullScreen
        present(tabBarVC, animated: true)
    }


class FirstViewController: DayViewController {
    
    let extendNavBar: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.blue
        return view
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Ellipse 8")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let headerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        label.text = "Hallo, Sam!"
        label.textColor = .white
        return label
    }()
    
    let bodyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.text = "2 Task for Today"
        label.textColor = .orange
        return label
    }()
    
    var data = [["Daily Stand Up"],
                
                ["Meeting Client A"],
                
                ["Complete"],
                
                ["Complete"],
                
    ]
    
    var generatedEvents = [EventDescriptor]()
    var alreadyGeneratedSet = Set<Date>()
    
    var colors = [UIColor.blue,
                  UIColor.orange,
                  UIColor.gray,
                  UIColor.red]

    private lazy var rangeFormatter: DateIntervalFormatter = {
      let fmt = DateIntervalFormatter()
      fmt.dateStyle = .none
      fmt.timeStyle = .short

      return fmt
    }()

    override func loadView() {
      calendar.timeZone = TimeZone(identifier: "Europe/Paris")!

      dayView = DayView(calendar: calendar)
      view = dayView
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        dayView.autoScrollToFirstEvent = true
        reloadData()

        
//        let weekView = WeekView()
//        weekView.translatesAutoresizingMaskIntoConstraints = false
        
//        view.addSubview(weekView)
//        weekView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        weekView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        weekView.topAnchor.constraint(equalTo: view.topAnchor, constant: 120).isActive = true
//        weekView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        self.navigationController?.isNavigationBarHidden = true
        setupExtendNavBar()
        
    }
    
    func setupExtendNavBar() {
        view.addSubview(extendNavBar)
        extendNavBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        extendNavBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        extendNavBar.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        extendNavBar.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        extendNavBar.addSubview(imageView)
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 48).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 56).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        extendNavBar.addSubview(headerLabel)
        headerLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 20).isActive = true
        headerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 52).isActive = true
        
        extendNavBar.addSubview(bodyLabel)
        bodyLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 20).isActive = true
        bodyLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 8).isActive = true
        
    }
    
    // MARK: EventDataSource
    
    override func eventsForDate(_ date: Date) -> [EventDescriptor] {
      if !alreadyGeneratedSet.contains(date) {
        alreadyGeneratedSet.insert(date)
        generatedEvents.append(contentsOf: generateEventsForDate(date))
      }
      return generatedEvents
    }
    
    private func generateEventsForDate(_ date: Date) -> [EventDescriptor] {
      var workingDate = Calendar.current.date(byAdding: .hour, value: Int.random(in: 1...15), to: date)!
      var events = [Event]()
      
      for i in 0...4 {
        let event = Event()

        let duration = Int.random(in: 60 ... 160)
        event.startDate = workingDate
        event.endDate = Calendar.current.date(byAdding: .minute, value: duration, to: workingDate)!

        var info = data[Int(arc4random_uniform(UInt32(data.count)))]
        
        let timezone = dayView.calendar.timeZone
        print(timezone)

        info.append(rangeFormatter.string(from: event.startDate, to: event.endDate))
        event.text = info.reduce("", {$0 + $1 + "\n"})
        event.color = colors[Int(arc4random_uniform(UInt32(colors.count)))]
        event.isAllDay = Int(arc4random_uniform(2)) % 2 == 0
        event.lineBreakMode = .byTruncatingTail
        
        // Event styles are updated independently from CalendarStyle
        // hence the need to specify exact colors in case of Dark style
        if #available(iOS 12.0, *) {
          if traitCollection.userInterfaceStyle == .dark {
            event.textColor = textColorForEventInDarkTheme(baseColor: event.color)
            event.backgroundColor = event.color.withAlphaComponent(0.6)
          }
        }
        
        events.append(event)
        
        let nextOffset = Int.random(in: 40 ... 250)
        workingDate = Calendar.current.date(byAdding: .minute, value: nextOffset, to: workingDate)!
        event.userInfo = String(i)
      }

      print("Events for \(date)")
      return events
    }
    
    private func textColorForEventInDarkTheme(baseColor: UIColor) -> UIColor {
      var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
      baseColor.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
      return UIColor(hue: h, saturation: s * 0.3, brightness: b, alpha: a)
    }
    
    // MARK: DayViewDelegate
    
    private var createdEvent: EventDescriptor?
    
    override func dayViewDidSelectEventView(_ eventView: EventView) {
      guard let descriptor = eventView.descriptor as? Event else {
        return
      }
      print("Event has been selected: \(descriptor) \(String(describing: descriptor.userInfo))")
    }
    
    override func dayViewDidLongPressEventView(_ eventView: EventView) {
      guard let descriptor = eventView.descriptor as? Event else {
        return
      }
      endEventEditing()
      print("Event has been longPressed: \(descriptor) \(String(describing: descriptor.userInfo))")
      beginEditing(event: descriptor, animated: true)
      print(Date())
    }
    
    override func dayView(dayView: DayView, didTapTimelineAt date: Date) {
      endEventEditing()
      print("Did Tap at date: \(date)")
    }
    
    override func dayViewDidBeginDragging(dayView: DayView) {
      endEventEditing()
      print("DayView did begin dragging")
    }
    
    override func dayView(dayView: DayView, willMoveTo date: Date) {
      print("DayView = \(dayView) will move to: \(date)")
    }
    
    override func dayView(dayView: DayView, didMoveTo date: Date) {
      print("DayView = \(dayView) did move to: \(date)")
    }
    
    override func dayView(dayView: DayView, didLongPressTimelineAt date: Date) {
      print("Did long press timeline at date \(date)")
      // Cancel editing current event and start creating a new one
      endEventEditing()
      let event = generateEventNearDate(date)
      print("Creating a new event")
      create(event: event, animated: true)
      createdEvent = event
    }
    
    private func generateEventNearDate(_ date: Date) -> EventDescriptor {
      let duration = Int(arc4random_uniform(160) + 60)
      let startDate = Calendar.current.date(byAdding: .minute, value: -Int(CGFloat(duration) / 2), to: date)!
      let event = Event()

      event.startDate = startDate
      event.endDate = Calendar.current.date(byAdding: .minute, value: duration, to: startDate)!
      
      var info = data[Int(arc4random_uniform(UInt32(data.count)))]

      info.append(rangeFormatter.string(from: event.startDate, to: event.endDate))
      event.text = info.reduce("", {$0 + $1 + "\n"})
      event.color = colors[Int(arc4random_uniform(UInt32(colors.count)))]
      event.editedEvent = event
      
      // Event styles are updated independently from CalendarStyle
      // hence the need to specify exact colors in case of Dark style
      if #available(iOS 12.0, *) {
        if traitCollection.userInterfaceStyle == .dark {
          event.textColor = textColorForEventInDarkTheme(baseColor: event.color)
          event.backgroundColor = event.color.withAlphaComponent(0.6)
        }
      }
      return event
    }
    
    override func dayView(dayView: DayView, didUpdate event: EventDescriptor) {
      print("did finish editing \(event)")
      print("new startDate: \(event.startDate) new endDate: \(event.endDate)")
      
      if let _ = event.editedEvent {
        event.commitEditing()
      }
      
      if let createdEvent = createdEvent {
        createdEvent.editedEvent = nil
        generatedEvents.append(createdEvent)
        self.createdEvent = nil
        endEventEditing()
      }
      
      reloadData()
    }
    
}


class SecondViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
}

class ThirdViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
}

}
