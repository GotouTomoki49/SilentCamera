//
//  ContentView.swift
//  SilentCamera
//
//  Created by cmStudent on 2022/06/14.
//完成6/24

import SwiftUI

struct ContentView: View {
    var viewModel = ViewModel()
    var body: some View {
        CameraViewRepresent(viewModel: viewModel)
            .gesture(
                TapGesture()
                    .onEnded{
                        viewModel.takePhoto()
                    }
            )
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
    
}
