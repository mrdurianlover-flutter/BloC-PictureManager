const express = require("express");
const router = express.Router();
const galleryController = require("../controller/galleryController");
const joiSchemaValidation = require("../middleware/joiSchemaValidation");
const gallerySchema = require("../apiSchema/gallerySchema");
const tokenValidation = require("../middleware/tokenValidation");


router.post('/creategallery',
    tokenValidation.validateToken,
    joiSchemaValidation.validateBody(gallerySchema.createGallerySchema),
    galleryController.createGallery
);

router.get('/getByOwner',
    tokenValidation.validateToken,
    joiSchemaValidation.validateBody(gallerySchema.getAllGallerySchemaByOwner),
    galleryController.getAllGalleryByOwner
);

router.get('/getAllUsers/:galleryId',
    tokenValidation.validateToken,
    joiSchemaValidation.validateBody(gallerySchema.getAllGallerySchemaByOwner),
    galleryController.getAllUsers
);

router.post('/add',
    tokenValidation.validateToken,
    joiSchemaValidation.validateBody(gallerySchema.addGallerySchema),
    galleryController.addtoGallery
);

router.put('/update',
    tokenValidation.validateToken,
    joiSchemaValidation.validateBody(gallerySchema.updateGallerySchema),
    galleryController.updateGallery
);

router.delete('/:album_id/:picture_id',
    tokenValidation.validateToken,
    galleryController.deletePictureGallery
);

//router.post('/add',
//    joiSchemaValidation.validateBody(gallerySchema.addGallerySchema),
//    galleryController.addGallery
//);

// router.put(
//     "/:id",
//     tokenValidation.validateToken,
//     joiSchemaValidation.validateBody(gallerySchema.updateGallerySchema),
//     galleryController.updateGalleryById
// );

// router.get(
//     "/",
//     tokenValidation.validateToken,
//     joiSchemaValidation.validateQueryParams(gallerySchema.getAllGallerySchema),
//     galleryController.getAllGallery
// );

router.delete(
    "/:id",
    tokenValidation.validateToken,
    galleryController.deleteGalleryById
);

module.exports = router;