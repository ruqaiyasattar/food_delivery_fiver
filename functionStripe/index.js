'use strict';

const admin = require('firebase-admin');
const functions = require('firebase-functions');
admin.initializeApp();
//const logging = require('@google-cloud/logging')();
const stripe = require('stripe')(functions.config().stripe.token);
const currency = functions.config().stripe.currency || 'EUR';

// [START chargecustomer]
// Charge the Stripe customer whenever an amount is created in Cloud Firestore
module.exports.createStripeCharge = functions.firestore.document('orders/{userId}/pending/{pushId}').onCreate(async (snap, context) => {
      const val = snap.data();
      try {
        // Look up the Stripe customer id written in createStripeCustomer
        const snapshot = await admin.firestore().collection(`stripe_customers`).doc(context.params.userId).get()
        const snapval = snapshot.data();
        const customer = snapval.customer_id
        // Create a charge using the pushId as the idempotency key
        // protecting against double charges
        const amount = val.amount;
        const idempotencyKey = context.params.id;
        const charge = {amount, currency, customer};
        if (val.source !== null) {
          charge.source = val.source;
        }
        const response = await stripe.charges.create(charge, {idempotencyKey: idempotencyKey});
        await admin.firestore().collection('orders').doc(context.params.userId).set({'status':response.status},{merge:true});
        // If the result is successful, write it back to the database
        return snap.ref.set(response, { merge: true });
      } catch(error) {
        // We want to capture errors and render them in a user-friendly way, while
        // still logging an exception with StackDriver
        console.log(error);
        await snap.ref.set({error: userFacingMessage(error)}, { merge: true });
        return ' ';//reportError(error, {user: context.params.userId});
      }
    });
// [END chargecustomer]]

// When a user is created, register them with Stripe
exports.createStripeCustomer = functions.auth.user().onCreate(async (user) => {
  console.log('creating user');
  const customer = await stripe.customers.create({email: user.email});
  return admin.firestore().collection('stripe_customers').doc(user.uid).set({customer_id: customer.id});
});

// Add a payment source (card) for a user by writing a stripe payment source token to Cloud Firestore
module.exports.addPaymentSource = functions
.firestore
.document('/stripe_customers/{userId}/tokens/{pushId}')
.onCreate(async (snap, context) => {
  const source = snap.data();
  const token = source.tokenId;
  if (source === null){
    return null;
  }

  try {
    const snapshot = await admin.firestore().collection('stripe_customers').doc(context.params.userId).get();
    const customer =  snapshot.data().customer_id;
    const response = await stripe.customers.createSource(customer, {source: token});
    return admin.firestore().collection('stripe_customers').doc(context.params.userId).collection("sources").doc(response.fingerprint).set(response, {merge: true});
  } catch (error) {
    await snap.ref.set({'error':userFacingMessage(error)},{merge:true});
    return ' ';//reportError(error, {user: context.params.userId});
  }
});

async function getData (index, productList, products){
  if(index===-1)return products;
  var snapshot=await admin.firestore().collection('products').doc(productList[index]).get();
  products.push(snapshot.data());
  return getData(index-1,productList,products);
}

module.exports.processOrderRequest = functions
.firestore
.document('orders/{userId}/requests/{pushId}')
.onCreate(async (snap,context) => {
  const productList=snap.data().productList;
  const quantities=snap.data().quantities;
  var products=Array();
  products=await getData(productList.length-1,productList,products);
  await admin.firestore().collection('orders').doc(context.params.userId).set({'status':'requesting'},{merge:true});

  var cost=0;
  for(var j=0;j<products.length;j++){
    cost += products[j].price.toFixed(0) * quantities[j];
  }

  // cost=cost*100;

  if(snap.data().discount != null){
    const coupon = await admin.firestore().collection('coupons').document(snap.data().discount).get();
    cost = coupon.get('type') == "Percent"?(parseInt(coupon.get('valueoff')) / 100) * cost:(parseInt(coupon.get('valueoff')) / 100) * cost;
    await admin.firestore().collection('orders').doc(context.params.userId).update({ 'coupons': admin.firestore.FieldValue.arrayUnion(snap.data().discount) });
  }

  var data={
    "amount":cost,
    "productList":productList,
    "quantities":quantities,
  };
  snap.ref.delete();
  console.log(data);
  admin.firestore().collection('orders')
  .doc(context.params.userId)
  .collection('pending').doc(context.params.pushId)
  .set(data,{merge:false});

  return 1;
});

// When a user deletes their account, clean up after them
module.exports.cleanupUser = functions.auth.user().onDelete(async (user) => {
  const snapshot = await admin.firestore().collection('stripe_customers').doc(user.uid).get();
  const customer = snapshot.data();
  await stripe.customers.del(customer.customer_id);
  return admin.firestore().collection('stripe_customers').doc(user.uid).delete();
});

// To keep on top of errors, we should raise a verbose error report with Stackdriver rather
// than simply relying on console.error. This will calculate users affected + send you email
// alerts, if you've opted into receiving them.
// [START reporterror]

// function reportError(err, context = {}) {
//   // This is the name of the StackDriver log stream that will receive the log
//   // entry. This name can be any valid log stream name, but must contain "err"
//   // in order for the error to be picked up by StackDriver Error Reporting.
//   const logName = 'errors';
// //  const log = logging.log(logName);

//   // https://cloud.google.com/logging/docs/api/ref_v2beta1/rest/v2beta1/MonitoredResource
//   const metadata = {
//     resource: {
//       type: 'cloud_function',
//       labels: {function_name: process.env.FUNCTION_NAME},
//     },
//   };

//   // https://cloud.google.com/error-reporting/reference/rest/v1beta1/ErrorEvent
//   const errorEvent = {
//     message: err.stack,
//     serviceContext: {
//       service: process.env.FUNCTION_NAME,
//       resourceType: 'cloud_function',
//     },
//     context: context,
//   };

//   // Write the error log entry
//   return new Promise((resolve, reject) => {
//     log.write(log.entry(metadata, errorEvent), (error) => {
//       if (error) {
//        return reject(error);
//       }
//       return resolve();
//     });
//   });
// }
// [END reporterror]

// Sanitize the error message for the user
function userFacingMessage(error) {
  return error.type ? error.message : 'An error occurred, developers have been alerted';
}



/*
Complete Shopping Cart Screen
  Show No Items->Disable Place Order
  Remove Coupon Code
  Pass Calculated Value To NextScreen




*/