const sharedPictureService = require('../service/sharedPictureService');
const constants = require('../constants');
const jwt = require('jsonwebtoken');



module.exports.addPictureUser = async(req, res) => {
    let response = {...constants.defaultServerResponse };
    try {
        const token = req.headers.authorization.split('Bearer')[1].trim();
        const decoded = jwt.verify(token, process.env.SECRET_KEY);
        req.params.owner = decoded.id;

        const responseFromService = await sharedPictureService.addPictureUser(req.params);
        if (!responseFromService.status) {
            response.status = 401;
            response.message = constants.sharedPictureMessage.USER_NOT_FIND;
        } else {
            response.status = 200;
            response.message = constants.sharedPictureMessage.PICTURE_ADD_USER;
            response.body = [];
        }

    
        
    } catch (error) {
        console.log('Something went wrong : Controller getGalleryByOwner', error);
        response.message = error.message;
    }

    return res.status(response.status).send(response);
}


module.exports.getPictureUser = async(req, res) => {
    let response = {...constants.defaultServerResponse };
    try {
        const token = req.headers.authorization.split('Bearer')[1].trim();
        const decoded = jwt.verify(token, process.env.SECRET_KEY);
        req.params.owner = decoded.id;

        const responseFromService = await sharedPictureService.getPictureUser(req.params);
        response.status = 200;
        response.message = constants.sharedPictureMessage.PICTURE_GET_PICTURE_USER;
        response.body = responseFromService;
        
    } catch (error) {
        console.log('Something went wrong : Controller getGalleryByOwner', error);
        response.message = error.message;
    }

    return res.status(response.status).send(response);
}

module.exports.getUserPicture = async(req, res) => {
    let response = {...constants.defaultServerResponse };
    try {
        const token = req.headers.authorization.split('Bearer')[1].trim();
        const decoded = jwt.verify(token, process.env.SECRET_KEY);
        req.params.owner = decoded.id;

        const responseFromService = await sharedPictureService.getUserPicture(req.params);
        response.status = 200;
        response.message = constants.sharedPictureMessage.PICTURE_GET_USER_PICTURE;
        response.body = responseFromService;
        
    } catch (error) {
        console.log('Something went wrong : Controller getGalleryByOwner', error);
        response.message = error.message;
    }

    return res.status(response.status).send(response);
}

module.exports.getOwnerPicture = async(req, res) => {
    let response = {...constants.defaultServerResponse };
    try {
        const token = req.headers.authorization.split('Bearer')[1].trim();
        const decoded = jwt.verify(token, process.env.SECRET_KEY);
        req.params.owner = decoded.id;

        const responseFromService = await sharedPictureService.getOwnerPicture(req.params);
        response.status = 200;
        response.message = constants.sharedPictureMessage.PICTURE_GET_OWNER_PICTURE;
        response.body = responseFromService;
        
    } catch (error) {
        console.log('Something went wrong : Controller getGalleryByOwner', error);
        response.message = error.message;
    }

    return res.status(response.status).send(response);
}


module.exports.deletePictureUser = async(req, res) => {
    let response = {...constants.defaultServerResponse };
    try {
        const token = req.headers.authorization.split('Bearer')[1].trim();
        const decoded = jwt.verify(token, process.env.SECRET_KEY);
        req.params.owner = decoded.id;

        const responseFromService = await sharedPictureService.deletePictureUser(req.params);
        console.log(responseFromService, "deletePictureUser::responseFromService");
        if(responseFromService.status) {
            response.status = 200;
            response.message = constants.sharedPictureMessage.PICTURE_DELETE_USER_SUCCESS + ' ' + responseFromService.id_user;
        } else {
            response.status = 401;
            response.message = constants.sharedPictureMessage.PICTURE_DELETE_USER_ERROR;
        }
        response.body = [];
        
    } catch (error) {
        console.log('Something went wrong : Controller getGalleryByOwner', error);
        response.message = error.message;
    }

    return res.status(response.status).send(response);
}