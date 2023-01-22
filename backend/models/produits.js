const mongoose = require("mongoose");
const { ObjectId } = mongoose.Schema;
//const Categorie = require("../models/categories")

const categories = mongoose.model("categories", new mongoose.Schema(
  {
    titre: { type: String, required: true },
    description: { type: String, required: true },
    img: { type: String, required: false },
    prix: { type: String, required: false },
    favorite:{type:String,default: "false",required:false},

  },
  { timestamps: true }
));

const ProduitSchema = new mongoose.Schema(
  {_id: mongoose.Schema.Types.ObjectId,
    titre: { type: String, required: true, unique: true },
    description: { type: String, required: false, },
    favorite: { type: String,default:"false", required: false, },
    produitImage: { type: String, required: false },
    categories: {
                type: mongoose.Schema.Types.ObjectId,
                ref: "categories",
                required: false
                },
    taille: { type: String , required:false},
    couleur: { type: String,required:false },
    promo:{type:String,required:false},
    flash:{type:String,required:false},
    prix: { type: Number, required: false },
    quantite: { type: Number, required: false },
    
  },
  { timestamps: true }
);

module.exports = mongoose.model("Produit", ProduitSchema);