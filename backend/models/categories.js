const mongoose = require("mongoose");

const CategorieSchema = new mongoose.Schema(
  {
    titre: { type: String, required: true,unique:true },
    description: { type: String, required: true },
    img: { type: String, required: false }, 
    
  },
  { timestamps: true }
);

module.exports = mongoose.model("Categorie", CategorieSchema);