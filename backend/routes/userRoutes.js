const express = require('express');
const router = express.Router();
const userController = require('../controller/userController');
const joiSchemaValidation = require('../middleware/joiSchemaValidation');
const userSchema = require('../apiSchema/userSchema');
const tokenValidation = require("../middleware/tokenValidation");

router.post('/signup',
  joiSchemaValidation.validateBody(userSchema.signup),
  userController.signup
);

router.post('/login',
  joiSchemaValidation.validateBody(userSchema.login),
  userController.login
)

router.get(
  "/:id",
  tokenValidation.validateToken,
  userController.getUserById
);

module.exports = router;