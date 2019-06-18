//
//  ToDoTableViewCell.swift
//  ToDoApp
//
//  Created by Akhil Singh on 04/06/19.
//  Copyright © 2019 Akhil Singh. All rights reserved.
//

import UIKit

class ToDoTableViewCell: UITableViewCell {

    @IBOutlet weak var checkMarkLabel: UILabel!
    @IBOutlet weak var toDoNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCheckmark(for item:ToDoItem){
            if item.isCompleted{
                checkMarkLabel.text = "✓"
            }
            else{
                checkMarkLabel.text = ""
            }
    }
    
    func configureText(for item:ToDoItem){
            toDoNameLabel.text = item.itemName
    }
}
