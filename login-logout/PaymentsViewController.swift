//
//  PaymentsViewController.swift
//  login-logout
//
//  Created by Galkov Nikita on 21.02.2021.
//

import UIKit

class PaymentsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var logOutButton: UIButton!
    var networkManager = NetworkManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        logOutButton.layer.cornerRadius = 6
        tableView.delegate = self
        tableView.dataSource = self
        networkManager.getPayments() { (response, error) in
            if error != nil {
                self.oneButtonAlert(title: "Error", message: "Could not load data")
                return
            }
            if response != nil {
                    self.tableView.reloadData()
                
            }
        }
    }
    @IBAction func logOutButtonTapped(_ sender: Any) {
        NetworkManager.token = nil
        self.performSegue(withIdentifier: "goSign", sender: nil)
    }
}

extension PaymentsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        networkManager.payments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "paymentCell", for: indexPath) as! PaymentsTableViewCell
        cell.descriptionLabel.text = "Description: \(networkManager.payments[indexPath.row].desc)"
        cell.currencyLabel.text = "Currency: \(networkManager.payments[indexPath.row].currency)"
        cell.amountLabel.text = "Amount: \(networkManager.payments[indexPath.row].amount)"
        cell.createdLabel.text = "Data: \(networkManager.payments[indexPath.row].created)"
        return cell
    }
    
    
}
