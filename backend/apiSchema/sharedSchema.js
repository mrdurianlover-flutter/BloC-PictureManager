const Joi = require("@hapi/joi");

module.exports.createShared = Joi.object().keys({
    picture_id: Joi.string().required(),
    album_id: Joi.string(),
    main_user_id: Joi.string().required(),
})
