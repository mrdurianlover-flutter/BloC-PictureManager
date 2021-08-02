const constants = require('../constants');
const jwt = require('jsonwebtoken');
const Picture = require("../database/models/pictureModel");
const SharedPicture = require("../database/models/sharedPictureModel");

module.exports.validateToken = (req, res, next) => {
  let response = { ...constants.defaultServerResponse };
  try {
    if (!req.headers.authorization) {
      throw new Error(constants.requestValidationMessage.TOKEN_MISSING);
    }
    const token = req.headers.authorization.split('Bearer')[1].trim();
    const decoded = jwt.verify(token, process.env.SECRET_KEY || 'my-secret-key');
    console.log('decoded', decoded);
    return next();
  } catch (error) {
    console.log('Error', error);
    response.message = error.message;
    response.status = 401;
  }
  return res.status(response.status).send(response);
}

module.exports.imageAccess = async (req, res, next) => {
  let response = { ...constants.defaultServerResponse };
  let picture_owner = "";
  let p = {};
  let isThumb = false;
  try {
    const token = req.headers.authorization.split('Bearer')[1].trim();
    const decoded = jwt.verify(token, process.env.SECRET_KEY || 'my-secret-key');
    
    if (req.params.url.startsWith('thumb')) {
      picture_owner = req.params.url.split('-')[2].toString();
      isThumb = true;
    } else {
      picture_owner = req.params.url.split('-')[1].toString();
    }

    isThumb ? p = await Picture.findOne({thumbnail: req.params.url}) : p = await Picture.findOne({photo: req.params.url});

    // TODO: update the logic to allow shared && allow shared gallery pictures to user
    let sh = await SharedPicture.findOne({picture_id: p.id, user_id: decoded.id});

    if (decoded.id != picture_owner && !sh) {
      throw new Error(constants.pictureMessage.NO_ACCESS_TO_IMAGE);
    }

    return next();
  } catch (error) {
    console.log('Error', error);
    response.message = error.message;
    response.status = 401;
  }
  return res.status(response.status).send(response);
}