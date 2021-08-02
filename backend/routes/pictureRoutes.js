const express = require("express");
const router = express.Router();
const pictureController = require("../controller/pictureController");
const joiSchemaValidation = require("../middleware/joiSchemaValidation");
const pictureSchema = require("../apiSchema/pictureSchema");
const tokenValidation = require("../middleware/tokenValidation");

router.post(
  "/",
  pictureController.uploadPicture,
  pictureController.imageToThumbnail,
  tokenValidation.validateToken,
  joiSchemaValidation.validateBody(pictureSchema.createPictureSchema),
  pictureController.createPicture
);

router.get(
  "/",
  tokenValidation.validateToken,
  joiSchemaValidation.validateQueryParams(pictureSchema.getAllPictureSchema),
  pictureController.getAllPictures
);

router.get(
  "/search/:keyword",
  tokenValidation.validateToken,
  pictureController.search
);

router.put(
  "/:id",
  tokenValidation.validateToken,
  joiSchemaValidation.validateBody(pictureSchema.updatePictureSchema),
  pictureController.updatePicture
);

router.get(
  "/img/:url",
  tokenValidation.validateToken,
  tokenValidation.imageAccess,
  pictureController.serveImage
);

router.delete(
  "/:id",
  tokenValidation.validateToken,
  pictureController.deletePicture
);


router.post('/bygallery',
  tokenValidation.validateToken,
  joiSchemaValidation.validateBody(pictureSchema.getGalleryByPictureSchema),
  pictureController.getGalleryByPicture
);

router.post('/listgallery',
  tokenValidation.validateToken,
  joiSchemaValidation.validateBody(pictureSchema.getListGalleryByPictureSchema),
  pictureController.getListGalleryByPicture
);

router.get(
  "/getByAlbum/:albumId",
  tokenValidation.validateToken,
  pictureController.getByAlbum
);


module.exports = router;
