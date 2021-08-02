const express = require("express");
const router = express.Router();
const sharedUserController = require("../controller/sharedUserController");
const joiSchemaValidation = require("../middleware/joiSchemaValidation");
const sharedUserSchema = require("../apiSchema/sharedUserSchema");
const tokenValidation = require("../middleware/tokenValidation");

router.post("/getPicturesByOwner",
    joiSchemaValidation.validateBody(sharedUserSchema.getPicturesByOwner),
    sharedUserController.getPicturesByOwner
);

router.post("/createSharedUser",
    joiSchemaValidation.validateBody(sharedUserSchema.createSharedUser),
    sharedUserController.createSharedUser
);


router.post("/addUserToGallery",
    tokenValidation.validateToken,
    joiSchemaValidation.validateBody(sharedUserSchema.AddUserToGallery),
    sharedUserController.AddUserToGallery
);

router.delete("/:album_id/:user_id",
    tokenValidation.validateToken,
    sharedUserController.DeleteUserToGallery
);

module.exports = router;