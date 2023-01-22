const mongoose = require("mongoose");
const { ObjectId } = mongoose.Schema;

const CommandeSchema = new mongoose.Schema(
  {
    userId: { type: String, required: false },
    //  produits: { type:  mongoose.Schema.Types.ObjectId, ref: "produits",required: false },  
    //produits: { type: String, required: false },
    produits: [{
      type: String
    }],
    montant: { type: Number, required: false },
    // address: { type: Object, required: true },
    statut: { type: String, default: "en cours", required: false },
  },
  { timestamps: true }
);

module.exports = mongoose.model("Commande", CommandeSchema);