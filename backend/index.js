const express = require("express")
const mongoose=require("mongoose")
const bodyparser= require("body-parser")
const routeproduit=require("./routes/api-produits")
const routecommande=require("./routes/api-commandes")
const routecategorie=require("./routes/api-categories")
const routeuser=require("./routes/api-user")
const routeauth=require("./routes/auth")
const cors = require("cors")

const app=express()


//middleware
app.use(bodyparser.urlencoded({ extended: false }));
app.use(bodyparser.json())
app.use(cors())
app.use('uploads', express.static('G:/pfa/front-end/e-commerce/public/images'));

mongoose.Promise = global.Promise;

//connection mongodb
const uri="mongodb+srv://ramos:root@miniprojet-menu.ekvkcps.mongodb.net/?retryWrites=true&w=majority";
mongoose.connect(uri,{useNewUrlParser:true})


//routes
//app.use(routeproduit)
app.use(routecategorie)
app.use("/produits", routeproduit);
app.use("/", routecommande);
app.use("/produits/:id", routeproduit);
app.use("/users", routeuser);
app.use("/auth", routeauth);

//listen
app.listen(5000,()=>{
    console.log("connecter sur le port 5000")
})