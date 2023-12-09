const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

const db = admin.firestore();

// CREATE: Add a new item
exports.createItem = functions.https.onRequest(async (req, res) => {
  try {
    const item = {
      itemName: req.body.itemName,
      itemDescription: req.body.itemDescription,
      itemImage: req.body.itemImage,
      sellerName: req.body.sellerName,
      sellerPhone: req.body.sellerPhone,
      itemPrice: req.body.itemPrice,
      status: req.body.status,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    };
    const docRef = await db.collection("items").add(item);
    res.status(201).send({itemID: docRef.id});
  } catch (e) {
    res.status(400).send(e.message);
  }
});


// READ: Récupérer tous les éléments
exports.getItems = functions.https.onRequest(async (req, res) => {
  try {
    const snapshot = await db.collection("items").get();
    const items = [];
    snapshot.forEach((doc) => {
      items.push({id: doc.id, data: doc.data()});
    });
    res.status(200).send(items);
  } catch (e) {
    res.status(400).send(e.message);
  }
});

// UPDATE: Mettre à jour un élément par ID
exports.updateItem = functions.https.onRequest(async (req, res) => {
  try {
    const itemId = req.params.id;
    const item = req.body;
    await db.collection("items").doc(itemId).update(item);
    res.status(200).send();
  } catch (e) {
    res.status(400).send(e.message);
  }
});

// DELETE: Supprimer un élément par ID
exports.deleteItem = functions.https.onRequest(async (req, res) => {
  try {
    const itemId = req.params.id;
    await db.collection("items").doc(itemId).delete();
    res.status(200).send();
  } catch (e) {
    res.status(400).send(e.message);
  }
});
