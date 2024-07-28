const admin = require('firebase-admin');
admin.initializeApp();

// Function to add admin claim to a user
exports.addAdminClaim = functions.https.onCall(async (data, context) => {
  // Check that the request is made by an authenticated admin
  if (!context.auth.token.admin) {
    throw new functions.https.HttpsError('permission-denied', 'Must be an admin to add other admins.');
  }

  // Set the admin custom claim
  return admin.auth().setCustomUserClaims(data.uid, { admin: true }).then(() => {
    return {
      message: `Success! ${data.uid} is now an admin.`
    };
  }).catch((error) => {
    return {
      error: error.message
    };
  });
});
