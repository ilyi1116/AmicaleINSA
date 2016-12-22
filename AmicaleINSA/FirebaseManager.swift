//
//  FirebaseManager.swift
//  AmicaleINSA
//
//  Created by Arthur Papailhau on 28/02/16.
//  Copyright © 2016 Arthur Papailhau. All rights reserved.
//

import Foundation
import Firebase
import JSQMessagesViewController
import CryptoSwift

class FirebaseManager {
    
    static let firebaseManager = FirebaseManager()
    
    fileprivate let PATH_CHAT_IMAGE = "chat/"
    var chatVC = ChatViewController.chatViewController
    fileprivate(set) var BASE_REF = FIRDatabase.database().reference()
    
    // Storage
    let storageRef = FIRStorage.storage().reference(forURL: Secret.FIREBASE_STORAGE_BUCKET)

    func createTypingIndicatorRef() -> FIRDatabaseReference {
        return BASE_REF.child("typingIndicator")
    }
    
    func createMasterChatRef() -> FIRDatabaseReference {
        return BASE_REF.child("MasterChat")
    }
    
    func createActiveUsersRef() -> FIRDatabaseReference {
        return BASE_REF.child("activeUsers")
    }

    func createMessageRef() -> FIRDatabaseReference {
        return BASE_REF.child("messages")
    }
    
    func createPostRef() -> FIRDatabaseReference {
        return BASE_REF.child("posts")
    }
    
    func createWashingRef() -> FIRDatabaseReference {
        return BASE_REF.child("washing")
    }
    
    // Storage reference
    func createStorageRef() -> FIRStorageReference {
        return storageRef
    }
    
    func createStorageRefChat(_ nameImage: String) -> FIRStorageReference {
        return storageRef.child(PATH_CHAT_IMAGE+nameImage+".jpg")
    }
    
    func sendMessageFirebase(_ text: String, senderId: String, senderDisplayName: String,
                              date: Date, isMedia: Bool, imageURL: String) {
        let dateTimestamp = date.timeIntervalSince1970
        if (chatVC.shouldUpdateLastTimestamp(dateTimestamp)){
            chatVC.lastTimestamp = dateTimestamp
        }
        let itemRef = BASE_REF.child("messages").childByAutoId()
        let messageItem: [String: Any] = [ // 2
            "text": text,
            "senderId": senderId,
            "senderDisplayName": senderDisplayName,
            "dateTimestamp": dateTimestamp,
            "timestampServerFirebase": FIRServerValue.timestamp(),
            "isMedia": false,
            "hashValue": "\(senderId)\(dateTimestamp)".md5(),
            "imageURL": imageURL
        ]
        itemRef.setValue(messageItem)
        
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
    }    
}
