#!/usr/bin/env node

import * as public_api from './public_api.mjs';
import express from 'express';

const app = express();
app.use(express.json());

public_api.init(app);
app.listen(2520);
