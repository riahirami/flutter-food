const express = require("express")
const Produit = require("../models/produits")
const router = express.Router()
const multer = require('multer');
const mongoose = require("mongoose");

const bodyparser = require("body-parser")
router.use(bodyparser.urlencoded({ extended: false }));
router.use(bodyparser.json())

const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, 'G:/pfa/front-end/e-commerce/public/images');
  },
  filename: function (req, file, cb) {
    cb(null, file.originalname);
    console.log("******fiile ----" + file)

  }
});

const fileFilter = (req, file, cb) => {
  // reject a file
  if (file.mimetype === 'image/jpeg' || file.mimetype === 'image/png') {
    cb(null, true);
  } else {
    cb(null, false);
  }
};

const upload = multer({
  storage: storage,
  limits: {
    fileSize: 1024 * 1024 * 5
  },
  fileFilter: fileFilter
});

//models
const prd = require("../models/produits")
const produit = require("../models/produits");
const categories = require("../models/categories");






//get list of produit
router.get("/", (req, res, next) => {
  Produit.find().populate("categories", "titre description").sort(mysort).then((produit) => {
    res.send(produit)
  })
})

var query = { promo: true };
var query2 = { flash: true };
var mysort = { createdAt: -1 };

//get list of produit en promo
router.get("/promo", (req, res, next) => {
  Produit.find(query)
  .then((produit) => {
    res.send(produit)
  })
})

//get list of produit en vente flash
router.get("/venteflash", (req, res, next) => {
  Produit.findOne(query2)
  .then((produit) => {
    res.send(produit)
  })
})


//add new produit
router.post("/", upload.single('produitImage'), (req, res, next) => {
  //console.log(res)
  //const cat = new categories ({titre:req.body.categories.titre,description:req.body.categories.description})
  // original=req.file.originalname
  // imagenom=original.replace(/\s+/g, '')
  const produit = new Produit({
    _id: new mongoose.Types.ObjectId(),
    titre: req.body.titre,
    description: req.body.description,
    // categories: req.body.categories,
    prix: req.body.prix,
    // quantite: req.body.quantite,
    // couleur: req.body.couleur,
    // promo: req.body.promo,
    // flash: req.body.flash,
    // produitImage:req.body.produitImage,
    // produitImage: req.body.produitImage,
  });
  produit.save();
    // .then(result => {
      //  console.log("c'est le resultat : "+result);

      // res.status(201).json({
      //   message: "Created product successfully",
      //   createdProduct: {
      //     titre: result.titre,
      //     description: result.description,
      //     couleur: result.couleur,
      //     categories: result.categories[1],
      //     quantite: result.quantite,
      //     prix: result.prix,
      //     _id: result._id,
      //     produitImage: result.produitImage,
      //     // request: {
      //     //     type: 'GET',
      //     //     url: "localhost:5000/produits" + result._id
      //     // }
      //   }
      // });
    // })
    // .catch(err => {
    //   res.status(500).json({
    //     error: err
    //   });
    // });
});

//get produit by id
router.get("/:id", async (req, res) => {
  try {
    console.log("req.body : " + req.params.id)
    let resultat = await Produit.findById({ _id: req.params.id })
    res.send(resultat)
    // res.send("get ! "+req.params.id+ " / " +req.body.id)
  }
  catch (err) {
    console.log(err)
  }
})

//get produit by id categorie
router.get("/cat/:id", async (req, res) => {
  try {
    console.log("req.body : " + req.params.id)
    let resultat = await Produit.find({ categories: req.params.id })
    res.send(resultat)
  }
  catch (err) {
    console.log(err)
  }
})

//update existing produit
router.put("/:id", async (req, res) => {
  try {
    console.log("req.body : " + req.body.titre)
    let resultat = await Produit.updateOne({ _id: req.params.id }, { $set: req.body })
    // let resultat=await Produit.updateOne({_id:req.params.id})

    // res.send(resultat)
    res.send("updated ! " + req.params.id + " / " + req.body.titre)
  }
  catch (err) {
    console.log(err)
  }

})

//delete existing produit
router.delete("/:id", (req, res) => {
  Produit.findByIdAndDelete({ _id: req.params.id })
    .then((prd) => {
      res.send(prd)
    })
})

//search existing produit by key
router.get("/search/:key", async (req, res) => {
  let resultat = await Produit.find({
    "$or": [
      { titre: { $regex: req.params.key } },
      { description: { $regex: req.params.key } }
    ]
  })
  res.send(resultat)
})


router.put("/favoris/:id",async (req,res)=>{
  try {
      var newStatut = { $set: {favorite: "true"} };

      let resultat = await Produit.updateOne({ _id: req.params.id }, newStatut)
      // let resultat=await Produit.updateOne({_id:req.params.id})
  
      res.send("updated ! " + req.params.id + " / " + req.body.titre)
      // res.send(resultat)
    }
    catch (err) {
      console.log(err)
    }
  
})
var queryFav = { favorite: true };

router.get("/fav/lists", (req, res, next) => {
  Produit.find({ favorite: true })
  .then((produit) => {
    res.send(produit)
  })
})

router.put("/notfavoris/:id",async (req,res)=>{
  try {
      var newStatut = { $set: {favorite: false} };

      let resultat = await Produit.updateOne({ _id: req.params.id }, newStatut)
      // let resultat=await Produit.updateOne({_id:req.params.id})
  
      res.send("updated ! " + req.params.id + " / " + req.body.titre)
      // res.send(resultat)
    }
    catch (err) {
      console.log(err)
    }
  
})

module.exports = router