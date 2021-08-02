const Joi = require("@hapi/joi");

module.exports.createGallerySchema = Joi.object().keys({
    galleryname: Joi.string().required(),
    picture_id: Joi.string()
    
});

module.exports.getAllGallerySchemaByOwner = Joi.object().keys({
    owner: Joi.string()
});

// module.exports.getGallerySchema = Joi.object().keys({
//     skip: Joi.string(),
//     limit: Joi.string(),
// });

module.exports.updateGallerySchema = Joi.object().keys({
    galleryname: Joi.string().required(),
    album_id: Joi.string().required()
});

module.exports.addGallerySchema = Joi.object().keys({
    picture_id: Joi.string().required(),
    album_id: Joi.string().required()
})

