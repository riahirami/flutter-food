const express=require("express")
const Categorie = require("../models/categories")
const router=express.Router()
const bodyparser= require("body-parser")
const auth=require("../middleware/auth")
// Body-parser middleware
router.use(bodyparser.urlencoded({extended:false}))
router.use(bodyparser.json())

//models
const catg= require("../models/categories")

//get list of categorie
router.get("/categories",(req,res,next)=>{
    Categorie.find({}).then((catg)=>{
        res.send(catg)
    })
})

router.get("/categories",(req,res,next)=>{
    try {
      Categorie.findOne({ titre: req.params.titre }).then((catg)=>{
          res.send(catg)
      })
    } catch (error) {
      console.log(error.message);
    }
  })

    //get categorie by id
router.get("/categories/:id", async (req, res) => {
    try {
      console.log("req.body : " + req.params.id)
      let resultat = await Categorie.findById({ _id: req.params.id })
      res.send(resultat)
      // res.send("get ! "+req.params.id+ " / " +req.body.id)
    }
    catch (err) {
      console.log(err)
    }
  })

//add new categorie
router.post("/categories",(req,res)=>{
    Categorie.create(req.body)
    .then((catg) =>{
        res.send(catg)
    })
    .catch((err) => {
        res.send({
            error:err.message
        })
    })
})

//update existing categorie
router.put("/categories/:id",async (req,res)=>{
    try {
        console.log("req.body : " + req.body.titre)
        let resultat = await Categorie.updateOne({ _id: req.params.id }, { $set: req.body })
        // let resultat=await Produit.updateOne({_id:req.params.id})
    
        res.send(resultat)
        res.send("updated ! " + req.params.id + " / " + req.body.titre)
      }
      catch (err) {
        console.log(err)
      }
    
})

//delete existing categorie
router.delete("/categories/:id",(req,res)=>{
    Categorie.findByIdAndDelete({_id:req.params.id})
    .then((catg)=>{
        res.send(catg)
        })
    })


module.exports= router