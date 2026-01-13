const functions = require("firebase-functions/v1");
const admin = require("firebase-admin");

admin.initializeApp();

exports.sendReportStatusNotification = functions.firestore
    .document("reports/{reportId}")
    .onUpdate(async (change, context) => {
        const newData = change.after.data();
        const oldData = change.before.data();

        if (!newData || !oldData) return null;

        if (newData.status === oldData.status) {
            return null;
        }

        const userId = newData.user_id;
        const newStatus = newData.status;

        try {
            const userDoc = await admin.firestore().collection("users").doc(userId).get();

            if (!userDoc.exists) {
                console.log("User not found:", userId);
                return null;
            }

            const userData = userDoc.data();
            const fcmToken = userData.fcmToken;

            if (!fcmToken) {
                console.log("No Token found for user:", userId);
                return null;
            }

            let title = "Report Status Updated!";
            let body = `Your report "${newData.title}" status has been updated to "${newStatus}".`;

            if (newStatus === "Resolved") {
                title = "Your report has been resolved!";
                body = `Great news! Your report "${newData.title}" has been marked as resolved. Thank you for your contribution.`;
            }

            const message = {
                notification: {
                    title: title,
                    body: body,
                },
                token: fcmToken,
                data: {
                    reportId: String(context.params.reportId),
                    click_action: "FLUTTER_NOTIFICATION_CLICK",
                    status: newStatus
                }
            };

            await admin.messaging().send(message);
            console.log("Notification sent successfully");
            return null;

        } catch (error) {
            console.error("Error sending notification:", error);

            if (error.code === 'messaging/registration-token-not-registered' ||
                error.code === 'messaging/invalid-registration-token') {

                console.log(`Cleaning up invalid token for user: ${userId}`);
                await admin.firestore().collection("users").doc(userId).update({
                    fcmToken: admin.firestore.FieldValue.delete()
                });
            }
            return null;
        }
    });