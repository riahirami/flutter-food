const express=require("express")
const User= require("../models/user")
// const userValidate = require("../models/user")
const userValidate= require("../models/user")
const bcrypt = require("bcrypt")
const _=require("lodash")
const usr= require("../models/user")
const router=express.Router()
const bodyparser= require("body-parser")
const auth=require("../middleware/auth")
const jwt= require("jsonwebtoken")


//get list of categorie
router.get("/profile",auth,async(req,res)=>{
    const profile = await User.findById(req.user._id).select('-password')
    res.send(profile)
})

router.get("/utilisateur",async(req,res)=>{
    const usr = await User.find()
    .then((usr) => {
        res.send(usr)
      })
})

//get produit by id
router.get("/utilisateur/:id", async (req, res) => {
    try {
        if (req.params.id) {        
      console.log("req.body : " + req.params.id)
      let resultat = await usr.findById({ _id: req.params.id })
      res.send(resultat)
      } else {
          res.send(1)
      }
      // res.send("get ! "+req.params.id+ " / " +req.body.id)
    }
    catch (err) {
      console.log(err)
    }
  })

  
//get produit by id
router.get("/utilisateur/checkadmin/:id?", async (req, res) => {
    try {
      console.log("/utilisateur/checkadmin/ " + req.params.id)
        let resultat = await usr.findById({ _id: req.params.id })
        res.send(resultat.isAdmin)   
      // res.send("get ! "+req.params.id+ " / " +req.body.id)
    }
    catch (err) {
        // let resultat = await usr.findById({ _id:"628d5111c14f217c5c56c1b5"})
        // res.send(resultat.isAdmin)
        res.send(err)
    }
  })

  router.get("/utilisateur/checkadminbyemail/:email?", async (req, res) => {
    try {
      // console.log("/utilisateur/checkadmin/ " + req.params.email)
        let resultat = await usr.findOne({ email: req.params.email })
        res.send(resultat);   
        
        //  if (resultat.isAdmin == true)
        //  else
        // res.send("false");   
      // res.send("get ! "+req.params.id+ " / " +req.body.id)
    }
    catch (err) {
        // let resultat = await usr.findById({ _id:"628d5111c14f217c5c56c1b5"})
        // res.send(resultat.isAdmin)
        res.send(err)
    }
  })

  

  router.put("/utilisateur/checkemailadmin/:mail?", async (req, res) => {
    try {
      var newStatut = { $set: {isAdmin: "true"} };

      let resultat = await usr.updateOne({ mail: req.params.email }, newStatut)
      // let resultat=await Produit.updateOne({_id:req.params.id})
  
      res.send("updated ! " + req.params.mail + " / " + res.isAdmin)
      //res.send(resultat)
    }
    catch (err) {
      console.log(err)
    }
  
})




router.post("/",async(req,res)=>{
    const {error} = userValidate(req.body)
    if(error){
        console.log("erreur")
        return res.status(404).send(error.details[0].message)
    }
    let userCheck = await User.findOne({email:req.body.email})
   if (userCheck) {
    return res.status(404).send("l'adresse email saisie est déja utilisé !")
   }
   user= new User(_.pick(req.body,["username",
                    "email",
                    "password",                  
                    "isAdmin"]))
const saltRounds=10
const salt= await bcrypt.genSalt(saltRounds)
user.password= await bcrypt.hash(user.password,salt)
   await  user.save()
   const token= jwt.sign({_id:user._id},"privateKey")  
   res.send(user);  
  //  res.send(token)
//   res.header("x-auth-token",token).send(_.pick(user,["_id","username","email","isAdmin"]))
    })

    router.put("/superadmin/:id",async (req,res)=>{
        try {
            var newStatut = { $set: {isAdmin: "true"} };
    
            let resultat = await usr.updateOne({ _id: req.params.id }, newStatut)
            // let resultat=await Produit.updateOne({_id:req.params.id})
        
            res.send("updated ! " + req.params.id + " / " + res.isAdmin)
            //res.send(resultat)
          }
          catch (err) {
            console.log(err)
          }
        
    })

    router.put("/revokesuperadmin/:id",async (req,res)=>{
        try {
            var newStatut = { $set: {isAdmin: "false"} };
    
            let resultat = await usr.updateOne({ _id: req.params.id }, newStatut)
            // let resultat=await Produit.updateOne({_id:req.params.id})
        
            res.send("updated ! " + req.params.id + " / " + res.isAdmin)
            //res.send(resultat)
          }
          catch (err) {
            console.log(err)
          }
        
    })

module.exports= router