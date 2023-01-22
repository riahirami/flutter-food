const mongoose = require("mongoose");
const Joi = require("joi");
const UserSchema = new mongoose.Schema(
  {
    username: { type: String, required: false,minlength:3,maxlength:30 },
    email: { type: String, required: true,unique:true,minlength:8,maxlength:40 },
    password: { type: String, required: true,minlength:8,maxlength:1024 },
    telephone: { type: String, required: false,minlength:8,maxlength:11 },
    isAdmin:{type:String,default:"false", required: false},
    //Role:{type:String,default:"Client"}
    
    
    
  },
  { timestamps: true }
);


function userValidate(user) {
    const schema={
        username:joi.string().min(3).max(30).required(),
        email:joi.string().min(5).max(255).required().email(),
        password:joi.string().min(8).max(1024).required(),
        isAdmin:Joi.string().min(5).max(255).required().isAdmin(),

    }
    return Joi.validate(user,schema)
}

// exports.User=User;
exports.userValidate = userValidate;
module.exports = mongoose.model("User", UserSchema);
