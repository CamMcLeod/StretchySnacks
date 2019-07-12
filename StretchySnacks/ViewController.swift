//
//  ViewController.swift
//  StretchySnacks
//
//  Created by Cameron Mcleod on 2019-07-11.
//  Copyright © 2019 Cameron Mcleod. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var navBar: UIView!
    @IBOutlet weak var navBarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var tableView: UITableView!

    var navBarOpen = false
    var navBarSnackIcons : UIStackView!
    var navBarSnackLabels : UIStackView!
    var snackIcons = [UIImageView]()
    var snackLabels = [UILabel]()
    var mySnacks = [String]()

    var navBarMaskLayer : CAShapeLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Do any additional setup after loading the view.
        tableView.delegate = self

        makeSnackIcons()
        makeSnackLabels()
        navBarSnackIcons = UIStackView.init(arrangedSubviews: snackIcons)
        navBarSnackIcons.axis = .horizontal
        navBarSnackIcons.distribution = .fillEqually
        navBarSnackIcons.alignment = .center
        navBarSnackIcons.spacing = 8
        navBarSnackIcons.isUserInteractionEnabled = true
        navBarSnackIcons.translatesAutoresizingMaskIntoConstraints = false
        navBar.addSubview(navBarSnackIcons)
        
        navBarSnackIcons.widthAnchor.constraint(equalTo: navBar.widthAnchor, multiplier: 0.8).isActive = true
        navBarSnackIcons.centerXAnchor.constraint(equalTo: navBar.centerXAnchor).isActive = true
        navBarSnackIcons.topAnchor.constraint(equalTo: navBar.topAnchor, constant: 100).isActive = true
        navBarSnackIcons.heightAnchor.constraint(equalTo: navBar.heightAnchor, constant: -100).isActive = true
        
        navBarSnackLabels = UIStackView.init(arrangedSubviews: snackLabels)
        navBarSnackLabels.axis = .horizontal
        navBarSnackLabels.isHidden =  false
        navBarSnackLabels.distribution = .fillEqually
        navBarSnackLabels.alignment = .center
        navBarSnackLabels.spacing = 8
        navBarSnackLabels.translatesAutoresizingMaskIntoConstraints = false
        navBar.addSubview(navBarSnackLabels)
        
        navBarSnackLabels.widthAnchor.constraint(equalTo: navBar.widthAnchor, multiplier: 0.8).isActive = true
        navBarSnackLabels.centerXAnchor.constraint(equalTo: navBar.centerXAnchor).isActive = true
        
        NSLayoutConstraint(item: navBarSnackLabels!,
                           attribute: .bottom,
                           relatedBy: .equal,
                           toItem: navBar,
                           attribute: .bottom,
                           multiplier: 0.05,
                           constant: 85).isActive = true
        
        navBarSnackLabels.heightAnchor.constraint(equalToConstant: 46.0).isActive = true
        
        for iconView in navBarSnackIcons.subviews {
            iconView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedSnack)))
        }
    }
    
    @objc func tappedSnack(recognizer: UITapGestureRecognizer) {
        
        // when tapped
        let tappedView = recognizer.view as! UIImageView
        switch recognizer.state {
        case .ended:
            
            
            if let index = navBarSnackIcons.arrangedSubviews.firstIndex(of: tappedView) {
                // Code to be executed upon completion

                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                    tappedView.alpha = 0.8
                    tappedView.transform = tappedView.transform.translatedBy(x: 0, y: tappedView.frame.height)
                }, completion: { (true) in
                    tappedView.alpha = 1.0
                    tappedView.transform = tappedView.transform.translatedBy(x: 0, y: -tappedView.frame.height)
                })
                mySnacks.insert(snackLabels[index].text!, at: 0)
                tableView.beginUpdates()
                tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
                tableView.endUpdates()
            }
            
        default:
            break
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mySnacks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel!.text = mySnacks[indexPath.row]
        
        return cell
    }
    
    
    @IBAction func plusButtonPressed(_ sender: UIButton) {
        print("plus button pressed")
        
        // animate open with basic View Animations
//        self.navBarHeightConstraint.constant = 200
//        UIView.animate(withDuration: 1, animations:{
//            self.view.layoutIfNeeded()
//        })
        
        // animate open and closed with spring animation on button as well
        if navBarOpen {
            self.navBarHeightConstraint.constant = 100
            UIView.animate(withDuration: 1.5, delay: 0.2, usingSpringWithDamping: 0.3, initialSpringVelocity: 25, options: .curveLinear, animations: {
                self.view.layoutIfNeeded()
                sender.transform = sender.transform.rotated(by: .pi/4)
            }) { (true) in
                self.navBarOpen = false
                print("nav bar closed")
            }
 
        } else {
            self.navBarHeightConstraint.constant = 200
            UIView.animate(withDuration: 1.5, delay: 0.2, usingSpringWithDamping: 0.3, initialSpringVelocity: 50.0, options: .curveLinear, animations: {
                self.view.layoutIfNeeded()
                sender.transform = sender.transform.rotated(by: -.pi/4)
            }) { (true) in
                self.navBarOpen = true
                print("nav bar opened")
            }
            
        }
        
    }
    
    private func makeSnackIcons() {
        
        let view1 = UIImageView(image: UIImage(named: "oreos"))
        let view2 = UIImageView(image: UIImage(named: "pizza_pockets"))
        let view3 = UIImageView(image: UIImage(named: "pop_tarts"))
        let view4 = UIImageView(image: UIImage(named: "popsicle"))
        let view5 = UIImageView(image: UIImage(named: "ramen"))
        
        snackIcons += [view1,view2,view3,view4,view5]
        
        for image in snackIcons {
            image.isUserInteractionEnabled = true
        }
    }
    
    private func makeSnackLabels() {
        let label1 = UILabel()
        let label2 = UILabel()
        let label3 = UILabel()
        let label4 = UILabel()
        let label5 = UILabel()
        
        label1.text = "Oreos"
        label2.text = "Pizza Pockets"
        label3.text = "Pop Tarts"
        label4.text = "Popsicles"
        label5.text = "Ramen"
        
        snackLabels += [label1,label2,label3,label4,label5]
        
        for label in snackLabels {
            label.transform = label.transform.rotated(by: -.pi/2)
            label.textAlignment = .center
            if label.text!.contains(" ") {
                label.numberOfLines = 2
            } else {
                label.numberOfLines = 1
                label.adjustsFontSizeToFitWidth = true
            }
            
            label.font = UIFont(name: label.font.fontName, size: 12)
        }
        
    }

}
