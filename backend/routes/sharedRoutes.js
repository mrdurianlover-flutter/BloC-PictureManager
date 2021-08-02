const express = require("express");
const router = express.Router();
const sharedController = require("../controller/sharedController");
const joiSchemaValidation = require("../middleware/joiSchemaValidation");
const sharedSchema = require("../apiSchema/sharedSchema");
const tokenValidation = require("../middleware/tokenValidation");


router.post('/createShared',
    joiSchemaValidation.validateBody(sharedSchema.createShared),
    sharedController.createShared
);

router.post('/:picture_id/:user_id/',
    tokenValidation.validateToken,
    sharedController.addPictureUser
);


module.exports = router;