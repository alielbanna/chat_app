const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

// Send notification when a new message is sent
exports.sendMessageNotification = functions.firestore
  .document('chats/{chatId}/messages/{messageId}')
  .onCreate(async (snapshot, context) => {
    const message = snapshot.data();
    const chatId = context.params.chatId;

    try {
      // Get chat participants
      const chatDoc = await admin.firestore()
        .collection('chats')
        .doc(chatId)
        .get();

      if (!chatDoc.exists) {
        console.log('Chat not found');
        return null;
      }

      const chat = chatDoc.data();
      const participants = chat.participantIds;

      // Get recipient (not the sender)
      const recipientId = participants.find(id => id !== message.senderId);

      if (!recipientId) {
        console.log('No recipient found');
        return null;
      }

      // Get recipient's FCM token
      const userDoc = await admin.firestore()
        .collection('users')
        .doc(recipientId)
        .get();

      if (!userDoc.exists) {
        console.log('User not found');
        return null;
      }

      const user = userDoc.data();
      const fcmToken = user.fcmToken;

      if (!fcmToken) {
        console.log('No FCM token for user');
        return null;
      }

      // Prepare notification payload
      let notificationBody = message.content;
      
      if (message.type === 'image') {
        notificationBody = '📷 Image';
      } else if (message.type === 'file') {
        notificationBody = '📎 File';
      } else if (message.type === 'voice') {
        notificationBody = '🎤 Voice message';
      }

      const payload = {
        notification: {
          title: message.senderName,
          body: notificationBody,
          sound: 'default',
        },
        data: {
          chatId: chatId,
          messageId: message.id,
          senderId: message.senderId,
          type: 'new_message',
        },
        token: fcmToken,
      };

      // Send notification
      const response = await admin.messaging().send(payload);
      console.log('Notification sent successfully:', response);
      return response;

    } catch (error) {
      console.error('Error sending notification:', error);
      return null;
    }
  });