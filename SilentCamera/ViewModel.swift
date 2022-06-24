//
//  ViewModel.swift
//  SilentCamera
//
//  Created by cmStudent on 2022/06/21.
//

import Foundation
import Photos
import UIKit

//継承はclassの記述のある方に書く
class ViewModel:  NSObject{
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
    
    //キャプチャしたイメージデータを保存する入れもの
    var imageData: Data?
    
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
    
    func run(){
        DispatchQueue(label: "Background", qos: .background).async {
            self.captureSession.startRunning()
        }
    }
}
// classの継承をextensionに書くことができない
extension ViewModel: AVCapturePhotoCaptureDelegate {
    
    // 撮影に関連する一連の処理が終わったあとに実行する処理
    public func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        //data型
        self.imageData = photo.fileDataRepresentation()
        //画面に撮った写真を表示
        //image()→直接はimageDataをImage()にできない
        _ = UIImage(data: imageData!)
    }
    
    // 写真をキャプチャーする直前に動作する（シャッター音）
    func photoOutput(_ output: AVCapturePhotoOutput, willCapturePhotoFor resolvedSettings: AVCaptureResolvedPhotoSettings) {
        // シャッター音を消す
        AudioServicesDisposeSystemSoundID(1108)
        // あるいは、シャッター音を他の音に変更する
        AudioServicesPlaySystemSound(1009)
    }
    
    // 写真をキャプチャー終わったら何をするか処理を書く
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishCaptureFor resolvedSettings: AVCaptureResolvedPhotoSettings, error: Error?) {
        // 写真の保存処理
        //PHPhotoLibraryは最近変わった書き方
        PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
            guard status == .authorized else { return }
            //photoLibraryのあれこれにアクセスできるように
            //photoLibraryに変更を求める、非同期
            PHPhotoLibrary.shared().performChanges {
                //photoLibraryに保存するリクエスト
                let creationRequest = PHAssetCreationRequest.forAsset()
                //リクエストに素材（写真）を渡す
                //imagedataはオプショナルでデータがないかもしれない
                guard let imageData  = self.imageData else {return}
                creationRequest.addResource(with: .photo, data: imageData, options: nil)
            }
            
        }
        
    }
    
    // 写真を撮る
    func takePhoto() {
        // キャプチャーに関する設定
        let settings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
}
