const Joi = require("@hapi/joi");

module.exports.signup = Joi.object().keys({
  username: Joi.string().required(),
  fullname: Joi.string().required(),
  password: Joi.string().required(),
});

module.exports.login = Joi.object().keys({
  username: Joi.string().required(),
  password: Joi.string().required(),
});
