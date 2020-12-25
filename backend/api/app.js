#!/usr/bin/env node

const public_api_init = require("./public_api");
const login_api_init  = require("./login_api");
const express = require("express");
const cors = require("cors");

const app = express();
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({extended: true}));

public_api_init(app);
login_api_init(app);

app.get ('/echo', (req, res) => res.json({query: req.query, cookies: req.cookies}));
app.post('/echo', (req, res) => res.json({body:  req.body,  cookies: req.cookies}));

app.listen(2520);
