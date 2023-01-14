//
//  LogInCell.swift
//  SimpleNotes
//
//  Created by Jared Kozar on 1/12/23.
//

import SwiftUI

struct LogInCell: View {
    var icon: RoundedIcon?
    var title: String
    var interactor: APIInteractor
    
    var body: some View {
        HStack {
            
            Text(title)
            
            Button(action: {
                interactor.isSignedIn ? interactor.signOut() : interactor.signIn()
            }) {
                Text(interactor.isSignedIn ? "Log Out" : "Log In")
                    .foregroundColor(.white)
                    .background(.blue)
            }
        }
    }
}

struct LogInCell_Previews: PreviewProvider {
    static var previews: some View {
        LogInCell(title: "Hello", interactor: GoogleInteractor())
    }
}
