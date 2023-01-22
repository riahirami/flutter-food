const express=require("express")
const User= require("../models/user")
const bcrypt = require("bcrypt")
const _=require("lodash")
const usr= require("../models/user")
const router=express.Router()
const bodyparser= require("body-parser")
const mongoose = require("mongoose");
const Joi = require("joi");
const jwt= require("jsonwebtoken")
router.post("/",async(req,res)=>{
    let userCheck = await User.findOne({email:req.body.email})
   if (!userCheck) {
       console.log("usercheck"+res.status(400))
    return res.status(400).send({message:"email ou password invalid !"})
   }
        const passwordcheck=await bcrypt.compare(req.body.password,userCheck.password)
        if (!passwordcheck) {
            console.log("passwordcheck"+res.status(400))

            return res.status(400).send({message:"email ou password invalid !"})
    }
    const token= jwt.sign({_id:userCheck._id},"privateKey")    
    //res.header("x-auth-token",token)
        res.send(userCheck)
        // return res.json({status:"ok",user: token})

    })

    function Validate(req) {
        const schema={
            email:Joi.string().min(5).max(255).required().email(),
            isAdmin:Joi.string().min(5).max(255).required().isAdmin(),
            password:Joi.string().min(8).max(1024).required(),
        }
        // return Joi.error
    }

    exports.Validate=Validate;
module.exports= router