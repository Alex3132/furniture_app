const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

const db = admin.firestore();

// CREATE: Ajouter un nouvel item
exports.createItem = functions.https.onRequest(async (req, res) => {
  try {
    const newItem = {
      itemName: req.body.itemName,
      itemDescription: req.body.itemDescription,
      itemImage: req.body.itemImage,
      sellerName: req.body.sellerName,
      sellerPhone: req.body.sellerPhone,
      itemPrice: req.body.itemPrice,
      stock: req.body.stock,
      status: req.body.status,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    };
    const docRef = await db.collection("items").add(newItem);
    res.status(201).send({ itemID: docRef.id });
  } catch (e) {
    console.error(e);
    res.status(400).send(e.message);
  }
});

// READ: Récupérer tous les items
exports.getItems = functions.https.onRequest(async (req, res) => {
  try {
    const itemsSnapshot = await db.collection("items").get();
    const items = [];
    itemsSnapshot.forEach(doc => {
      items.push({ id: doc.id, ...doc.data() });
    });
    res.status(200).send(items);
  } catch (e) {
    console.error(e);
    res.status(400).send(e.message);
  }
});

// UPDATE: Mettre à jour un item par ID
exports.updateItem = functions.https.onRequest(async (req, res) => {
  try {
    const itemId = req.query.id; // Utilisez req.params.id si l'ID est dans le chemin
    const itemToUpdate = req.body;
    await db.collection("items").doc(itemId).update(itemToUpdate);
    res.status(200).send(`Item with ID: ${itemId} updated successfully.`);
  } catch (e) {
    console.error(e);
    res.status(400).send(e.message);
  }
});

// DELETE: Supprimer un item par ID
exports.deleteItem = functions.https.onRequest(async (req, res) => {
  try {

    const itemId = req.query.id; // Utilisez req.params.id si l'ID est dans le chemin
    await db.collection("items").doc(itemId).delete();
    res.status(200).send(`Item with ID: ${itemId} deleted successfully.`);

  } catch (e) {
    console.error(e);
    res.status(400).send(e.message);
  }
});
