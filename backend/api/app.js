#!/usr/bin/env node

const public_api_init = require("./public_api");
const express = require("express");

const app = express();
app.use(express.json());

public_api.init(app);
app.listen(2520);
