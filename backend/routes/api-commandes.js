const express=require("express")
const Commandes = require("../models/commandes")
const router=express.Router()
const bodyparser= require("body-parser")
const auth=require("../middleware/auth")
// Body-parser middleware
router.use(bodyparser.urlencoded({extended:false}))
router.use(bodyparser.json())

//models
const cmd= require("../models/commandes")

//get list of commande
router.get("/commandes",(req,res,next)=>{
    Commandes.find({}).then((cmd)=>{
        res.send(cmd)
    })
})


    //get commande by id
router.get("/commandes/:id", async (req, res) => {
    try {
      console.log("req.body : " + req.params.id)
      let resultat = await Commandes.findById({ _id: req.params.id })
      res.send(resultat)
      // res.send("get ! "+req.params.id+ " / " +req.body.id)
    }
    catch (err) {
      console.log(err)
    }
  })

      //get commande by user id
router.get("/commandes/user/:id", async (req, res) => {
    try {
      let resultat = await Commandes.find({userId:req.params.id })
      res.send(resultat)
      // res.send("get ! "+req.params.id+ " / " +req.body.id)
    }
    catch (err) {
      console.log(err)
    }
  })

//add new commande
router.post("/Commandes",(req,res)=>{
    Commandes.create(req.body)
    .then((cmd) =>{
        res.send(cmd)
    })
    .catch((err) => {
        res.send({
            error:err.message
        })
    })
})
//update existing commande
router.put("/commandes/:id",async (req,res)=>{
    try {
        let resultat = await Commandes.updateOne({ _id: req.params.id }, { $set: req.body })
        // let resultat=await Produit.updateOne({_id:req.params.id})
    
        res.send("updated ! " + req.params.id + " / " + req.body.titre)
        // res.send(resultat)
      }
      catch (err) {
        console.log(err)
      }
    
})

router.put("/commandes/valider/:id",async (req,res)=>{
    try {
        var newStatut = { $set: {statut: "valider"} };

        let resultat = await Commandes.updateOne({ _id: req.params.id }, newStatut)
        // let resultat=await Produit.updateOne({_id:req.params.id})
    
        res.send("updated ! " + req.params.id + " / " + req.body.titre)
        // res.send(resultat)
      }
      catch (err) {
        console.log(err)
      }
    
})

router.put("/commandes/annuler/:id",async (req,res)=>{
    try {
        var newStatut = { $set: {statut: "annuler"} };

        let resultat = await Commandes.updateOne({ _id: req.params.id }, newStatut)
        // let resultat=await Produit.updateOne({_id:req.params.id})
    
        res.send("updated ! " + req.params.id + " / " + res.statut)
        //res.send(resultat)
      }
      catch (err) {
        console.log(err)
      }
    
})

//delete existing commande
router.delete("/commandes/:id",(req,res)=>{
    Commandes.findByIdAndDelete({_id:req.params.id})
    .then((cmd)=>{
        res.send(cmd)
        })
    })


module.exports= router