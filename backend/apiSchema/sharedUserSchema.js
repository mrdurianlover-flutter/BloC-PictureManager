const Joi = require("@hapi/joi");

module.exports.getPicturesByOwner = Joi.object().keys({
    user_id: Joi.string().required()
})

module.exports.createSharedUser = Joi.object().keys({
    shared_id: Joi.string().required(),
    owner_id: Joi.string().required()
})

module.exports.AddUserToGallery = Joi.object().keys({
    username: Joi.string().required(),
    album_id: Joi.string().required()
})