const Joi = require("@hapi/joi");

module.exports.createPictureSchema = Joi.object().keys({
  owner: Joi.string(),
  tags: Joi.string().allow('').optional(),
  name: Joi.string().required(),
  album_id: Joi.string()
});

module.exports.getAllPictureSchema = Joi.object().keys({
  skip: Joi.string(),
  limit: Joi.string(),
});

module.exports.updatePictureSchema = Joi.object().keys({
  owner: Joi.string(),
  name: Joi.string(),
  tags: Joi.string(),
});

module.exports.getGalleryByPictureSchema = Joi.object().keys({
  picture_id: Joi.string().required()
})

module.exports.getListGalleryByPictureSchema = Joi.object().keys({
  picture_id: Joi.string().required()
})

module.exports.getByAlbum = Joi.object().keys({
  skip: Joi.string(),
  limit: Joi.string(),
})