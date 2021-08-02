const express = require("express");
const router = express.Router();
const sharedPictureController = require("../controller/sharedPictureController");
const joiSchemaValidation = require("../middleware/joiSchemaValidation");
const sharedSchema = require("../apiSchema/sharedSchema");
const tokenValidation = require("../middleware/tokenValidation");



router.put('/:picture_id/:username/',
    tokenValidation.validateToken,
    sharedPictureController.addPictureUser
);

router.delete('/:picture_id/:username/',
    tokenValidation.validateToken,
    sharedPictureController.deletePictureUser
);

router.get('/byuser/:user_id',
    tokenValidation.validateToken,
    sharedPictureController.getPictureUser
);

router.get('/bypicture/:picture_id',
    tokenValidation.validateToken,
    sharedPictureController.getUserPicture
);

router.get('/byowner/:owner_id',
    tokenValidation.validateToken,
    sharedPictureController.getOwnerPicture
);



module.exports = router;