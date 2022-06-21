//
//  CameraView.swift
//  SilentCamera
//
//  Created by cmStudent on 2022/06/14.
//

import SwiftUI
import Photos //カメラ機能のライブラリ

class CameraView: UIView{
    var viewModel = ViewModel()

    //Layerの設定
    //プレビュー用のレイヤー
    var cameraPreViewLayer: AVCaptureVideoPreviewLayer?
    //レイヤーの設定
    func setupLayer(){
        cameraPreViewLayer = AVCaptureVideoPreviewLayer(session: viewModel.captureSession)
        cameraPreViewLayer?.videoGravity = .resizeAspectFill
        //カメラの向きによってカメラが変な向きになるので直す
        
        //大きさ
        //画面起動時のフルサイズ
        self.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: UIScreen.main.bounds.size)
        //LayerもViewと同じ大きさにする
        cameraPreViewLayer?.frame = self.frame
        //オプショナルの値を安全に取り出す
        if let cameraPreviewLayer = cameraPreViewLayer{
            self.layer.addSublayer(cameraPreviewLayer)
            
        }
    }
   
}

//swiftUIで使うためのRepresent
struct CameraViewRepresent: UIViewRepresentable{
    typealias UIViewType = CameraView
    
    func makeUIView(context: Context) -> CameraView {
        let view = CameraView()
        view.viewModel.setupDevice()
        view.setupLayer()
        view.viewModel.run()
        return view
    }
    
    func updateUIView(_ uiView: CameraView, context: Context) {
        //使わない
    }
    
    
}
    
    
    


