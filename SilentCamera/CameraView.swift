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
        //取得したデバイスを振り分ける(両方ないかもしれない)
        for device in devices{
            if device.position  == .back{
                mainCamera = device
            } else if device.position == .front{
                innerCamera = device
            }
            
        }
        //実際に起動するカメラは背面が優先、インナーは背面がなかったら使う
        device = mainCamera == nil ? innerCamera : mainCamera
        //設定終える、設定はコミットする
        captureSession.commitConfiguration()
        
        
    }
    
}
    
    
    


