#!/usr/bin/env node

const public_api_init = require("./public_api");
const login_api_init  = require("./login_api");
const express = require("express");

const app = express();
app.use(express.json());
app.use(express.urlencoded({extended: true}));

public_api_init(app);
login_api_init(app);

app.listen(2520);