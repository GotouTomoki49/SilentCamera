//
//  ContentView.swift
//  SilentCamera
//
//  Created by cmStudent on 2022/06/14.
//

import SwiftUI

struct ContentView: View {
    var viewModel = ViewModel()
    var body: some View {
        CameraViewRepresent()
            .gesture(
                TapGesture()
                    .onEnded{
                        takePhoto()
                    }
                
            
            )
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
    
}
