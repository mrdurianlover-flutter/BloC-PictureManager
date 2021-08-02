const galleryService = require("../service/galleryService");
const sharedService = require('../service/sharedService');
const constants = require("../constants");
const jwt = require('jsonwebtoken');

module.exports.createGallery = async(req, res) => {
    let response = {...constants.defaultServerResponse };
    console.log(req.body);
    try {
        const token = req.headers.authorization.split('Bearer')[1].trim();
        const decoded = jwt.verify(token, process.env.SECRET_KEY);
        req.body.owner = decoded.id;
        const response_gallery_info = await galleryService.createGallery(req.body);
        
        response.status = 200;
        response.message = constants.galleryMessage.GALLERY_CREATED;
        response.body = response_gallery_info;
    } catch (error) {
        console.log('Something went wrong : Controller: createGallery', error);
        response.message = error.message;
    }

    return res.status(response.status).send(response);
}

module.exports.addtoGallery = async(req, res) => {
    let response = {...constants.defaultServerResponse };
    try {
        const token = req.headers.authorization.split('Bearer')[1].trim();
        const decoded = jwt.verify(token, process.env.SECRET_KEY);
        req.body.main_user_id = decoded.id;
        const response_gallery_info = await galleryService.addtoGallery(req.body);
        console.log(response_gallery_info, "response_gallery_info");
        if(response_gallery_info.status) {
            response.status = 200;
            response.message = constants.galleryMessage.GALLERY_ADDED;
        } else {
            response.status = 403;
            response.message = constants.galleryMessage.USER_RIGHT;
        }
        response.body = [];
    } catch (error) {
        console.log('Something went wrong : Controller: addtoGallery', error);
        response.message = error.message;
    }
    return res.status(response.status).send(response);
}

module.exports.deletefromGallery = async(req, res) => {
    let response = {...constants.defaultServerResponse };
    try {
        const token = req.headers.authorization.split('Bearer')[1].trim();
        const decoded = jwt.verify(token, process.env.SECRET_KEY);
        req.body.main_user_id = decoded.id;
        const response_gallery_info = await galleryService.deletefromGallery(req.body);
        response.status = 200;
        response.message = constants.galleryMessage.GALLERY_ADDED;
        response.body = response_gallery_info;
    } catch (error) {
        console.log('Something went wrong : Controller: addtoGallery', error);
        response.message = error.message;
    }
    return res.status(response.status).send(response);
}

module.exports.getAllGalleryByOwner = async(req, res) => {
    let response = {...constants.defaultServerResponse };
    try {
        const token = req.headers.authorization.split('Bearer')[1].trim();
        const decoded = jwt.verify(token, process.env.SECRET_KEY);
        owner_id = decoded.id;
        const response_gallery_info = await galleryService.getAllGalleryByOwner(decoded.id);
        const response_shared_info = await sharedService.getSharedByAlbumByOwner(owner_id);
        let response_formatted = {};
        console.log(response_shared_info);
        let response_gallery = [];
        let reponse_shared = [];
        response_gallery = response_gallery_info.filter((p) => p.galleryname != "__DEFAULT");
        reponse_shared = response_shared_info.filter((p) => p.galleryname != "__DEFAULT");


        response_formatted.myAlbums = response_gallery;
        response_formatted.mySharedAlbums = response_shared_info;
        response.status = 200;
        response.message = constants.galleryMessage.GALLERY_FETCHED;
        response.body = response_formatted;
        
    } catch (error) {
        console.log("Something went wrong: Controller: getAllGalleryByOwner", error);
        response.message = error.message;
    }
    return res.status(response.status).send(response);
}

module.exports.deleteGalleryById = async(req, res) => {
    let response = {...constants.defaultServerResponse };
    try {
        const responseFromService = await galleryService.deleteGalleryById(req.params);
        response.status = 200;
        response.message = constants.galleryMessage.GALLERY_DELETED;
        response.body = responseFromService;
    } catch (error) {
        console.log('Something went wrong : Controller: deletedGallery', error);
        response.message = error.message;
    }

    return res.status(response.status).send(response);
}

module.exports.updateGallery = async(req, res) => {
    let response = {...constants.defaultServerResponse };

    try {
        const response_gallery_update = await galleryService.updateGalleryById(req.body);
        console.log(response_gallery_update);
        response.status = 200;
        response.message = constants.galleryMessage.GALLERY_UPDATED;
        response.body = response_gallery_update;

    } catch (error) {

        console.log('Something went wrong : Controller: deletedGallery', error);
        response.message = error.message;

    }
    return res.status(response.status).send(response);
}

module.exports.deletePictureGallery = async(req, res) => {
    let response = {...constants.defaultServerResponse };

    try {
        const token = req.headers.authorization.split('Bearer')[1].trim();
        const decoded = jwt.verify(token, process.env.SECRET_KEY);
        req.params.owner = decoded.id;

        const response_shared = await sharedService.deletePictureGallery(req.params);
        if(response_shared.status) {
            response.status = 200;
            response.message = constants.galleryMessage.PICTURE_DELETE_GALLERY;
            
        } else {
            response.status = 403;
            response.message = constants.galleryMessage.PICTURE_NOT_FOUND;
        }
        console.log(response_shared);  
        response.body = [];

    } catch (error) {

        console.log('Something went wrong : Controller: deletedGallery', error);
        response.message = error.message;

    }
    return res.status(response.status).send(response);
}

module.exports.getAllUsers = async (req, res) => {
    let response = { ...constants.defaultServerResponse };
    req.query.galleryId = req.params.galleryId;
    const responseFromService = await galleryService.getAllUsers(req.query);
    response.status = 200;
    response.message = constants.galleryMessage.ALL_GALLERY_USERS;
   
    response.body = responseFromService;
    return res.status(response.status).send(response);
  };