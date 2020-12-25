#!/usr/bin/env node

const public_api_init = require("./public_api");
const login_api_init  = require("./login_api");
const user_api_init   = require("./user_api");

const cors = require("cors");
const express = require("express");

const app = express();
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({extended: true}));

public_api_init(app);
login_api_init(app);
user_api_init(app);

app.listen(2520);
