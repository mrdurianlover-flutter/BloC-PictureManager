const sharedUserService = require('../service/sharedUserService');
const constants = require('../constants');
const jwt = require('jsonwebtoken');

module.exports.getPicturesByOwner = async(req, res) => {
    let response = {...constants.defaultServerResponse };
    try {
        const responseFromService = await sharedUserService.getPicturesByOwner(req.body);
        response.status = 200;
        response.message = constants.sharedUserMessage.SHARED_USER_FETCHED;
        response.body = responseFromService;
    } catch (error) {
        console.log('Something went wrong : Controller getGalleryByOwner', error);
        response.message = error.message;
    }

    return res.status(response.status).send(response);
}

module.exports.createSharedUser = async(req, res) => {
    let response = {...constants.defaultServerResponse };
    try {
        const responseFromService = await sharedUserService.createSharedUser(req.body);
        response.status = 200;
        response.message = constants.sharedUserMessage.SHARED_USER_CREATED;
        response.body = responseFromService;
    } catch (error) {
        console.log('Something went wrong : Controller: createShared', error);
        response.message = error.message;
    }

    return res.status(response.status).send(response);
}


module.exports.AddUserToGallery = async(req, res) => {
    let response = {...constants.defaultServerResponse };
    try {
        const token = req.headers.authorization.split('Bearer')[1].trim();
        const decoded = jwt.verify(token, process.env.SECRET_KEY);
        req.body.owner = decoded.id;

        const responseFromService = await sharedUserService.addUserToGallery(req.body);
        response.status = 200;
        response.message = constants.sharedUserMessage.SHARED_USER_CREATED;
        response.body = responseFromService;
    } catch (error) {
        console.log('Something went wrong : Controller: createShared', error);
        response.message = error.message;
    }

    return res.status(response.status).send(response);
}

module.exports.DeleteUserToGallery = async(req, res) => {
    let response = {...constants.defaultServerResponse };
    try {
        const token = req.headers.authorization.split('Bearer')[1].trim();
        const decoded = jwt.verify(token, process.env.SECRET_KEY);
        req.params.owner = decoded.id;

        const responseFromService = await sharedUserService.DeleteUserToGallery(req.params);
        if(!responseFromService.status) {
            response.status = 402;
            response.message = constants.sharedUserMessage.ERROR;
        } else {
            response.status = 200;
            response.message = constants.sharedUserMessage.SHARED_USER_DELETED;
        }

        response.body = [];
    } catch (error) {
        console.log('Something went wrong : Controller: createShared', error);
        response.message = error.message;
    }

    return res.status(response.status).send(response);
}

