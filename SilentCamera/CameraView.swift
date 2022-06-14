//
//  CameraView.swift
//  SilentCamera
//
//  Created by cmStudent on 2022/06/14.
//

import SwiftUI
import Photos //カメラ機能のライブラリ

class CameraView: UIView{
    //入力と出力を管理する機能
    let captureSession = AVCaptureSession()
    //デバイス(ないかもしれない（シュミレーターなど）)
    var mainCamera: AVCaptureDevice?
    //インナーカメラ（ないかもしれない）
    var innerCamera: AVCaptureDevice?
    //実際に使うのはどっち？使う方を入れる(もしかしたらないかもしれない)
    var device: AVCaptureDevice?
    //キャプチャーした画面をアプトプットするための入れ物
    var photoOutput = AVCapturePhotoOutput()
    
    //カメラのセッティング
    func setupDevice(){
        //設定を開始する
        captureSession.beginConfiguration()
        //画像の解像度 （端末依存）
        captureSession.sessionPreset = .photo
        
        //カメラの設定
        //組み込みカメラを使う
        //カメラはフロント（インナー）とバックがある
        //広角カメラが条件でデバイスを探してもらう
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video,
            position: .unspecified)
        
        //条件を満たしデバイスを取得する（複数あるかもしれない）
        let devices = deviceDiscoverySession.devices
        //取得したデバイスを振り分ける(もしかしたら両方ないかもしれない)
        for device in devices{
            if device.position  == .back{
                mainCamera = device
            } else if device.position == .front{
                innerCamera = device
            }
        }
        
        //実際に起動するカメラは背面が優先、インナーは背面がなかったら使う
        device = mainCamera == nil ? innerCamera : mainCamera
        
        //出力の設定
        guard captureSession.canAddOutput(photoOutput) else {
            captureSession.commitConfiguration()
            return
        }
        //ここから下は実行されないかもしれない
        //セッションが使うアウトプットの設定
        captureSession.addOutput(photoOutput)
        //入力の設定
        if let device = device{
            guard let captureDeviceInput = try? AVCaptureDeviceInput(device: device),
           captureSession.canAddInput(captureDeviceInput) else{
            captureSession.commitConfiguration()
            return
        }
        //セッションが使うインプットの設定
        captureSession.addInput(captureDeviceInput)
            
        }
        //設定終える、設定はコミットする
        captureSession.commitConfiguration()
        
    }
    //Layerの設定
    
    //プレビュー用のレイヤー
    var cameraPreViewLayer: AVCaptureVideoPreviewLayer?
    //レイヤーの設定
    func setupLayer(){
        cameraPreViewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
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
    func run(){
        captureSession.startRunning()
    }
}

//swiftUIで使うためのRepresent
struct CameraViewRepresent: UIViewRepresentable{
    typealias UIViewType = CameraView
    
    func makeUIView(context: Context) -> CameraView {
        let view = CameraView()
        view.setupDevice()
        view.setupLayer()
        view.run()
        return view
    }
    
    func updateUIView(_ uiView: CameraView, context: Context) {
        //使わない
    }
}
    
    
    


