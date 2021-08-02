const pictureService = require("../service/pictureService");
const sharedUserService = require("../service/sharedUserService");
const sharedPictureService = require("../service/sharedPictureService");
const galleryService = require("../service/galleryService");
const sharedService = require("../service/sharedService");
const constants = require("../constants");
const jwt = require('jsonwebtoken');

const multer = require("multer");
const sharp = require("sharp");

// const multerStorage = multer.diskStorage({
//   destination: (req, file, cb) => {
//     cb(null, "public/img/users");
//   },
//   filename: (req, file, cb) => {
//     const ext = file.mimetype.split("/")[1];
//     console.log("test", req.body);
//     cb(null, `user-${req.body.owner}-${Date.now()}.${ext}`);
//   },
// });

const multerStorage = multer.memoryStorage();

const multerFilter = (req, file, cb) => {
    if (file.mimetype.startsWith("image")) {
        cb(null, true);
    } else {
        cb(new Error("Not an image! Please upload only images", 400), false);
    }
};

const upload = multer({
    storage: multerStorage,
    fileFilter: multerFilter,
});

module.exports.uploadPicture = upload.single("photo");

module.exports.imageToThumbnail = async (req, res, next) => {
  if (!req.file) return next();

  // get owner
  const token = req.headers.authorization.split('Bearer')[1].trim();
  const decoded = jwt.verify(token, process.env.SECRET_KEY || 'my-secret-key');
  req.body.owner = decoded.id;
  req.file.filename = `user-${req.body.owner}-${Date.now()}.jpeg`;

  // save original
  sharp(req.file.buffer)
  .toFormat('jpeg')
  .toFile(`public/img/picts/original/${req.file.filename}`, (err, info) => {
    if (err) console.log(err);
    });

  // save thumbnail
  sharp(req.file.buffer)
  .resize(500, 500)
  .toFormat('jpeg')
  .jpeg({quality: 90})
  .toFile(`public/img/picts/thumb/thumb-${req.file.filename}`, (err, info) => {
      if (err) console.log(err);
    });
  next();
}

module.exports.createPicture = async(req, res) => {
    let response = {...constants.defaultServerResponse };
    try {
        if (req.file)
            req.body.photo = req.file.filename;
        req.body.thumbnail = 'thumb-' + req.file.filename;
        // get owner
        const token = req.headers.authorization.split('Bearer')[1].trim();
        const decoded = jwt.verify(token, process.env.SECRET_KEY || 'my-secret-key');
        req.body.owner = decoded.id;
      
        const responseFromService = await pictureService.createPicture(req.body);
        if(req.body.album_id !== undefined && req.body.album_id.length > 0) {
            var shared_array = {picture_id: responseFromService.id, album_id:req.body.album_id, main_user_id: responseFromService.owner}
            const responseFromShared = await sharedService.test_create_shared(shared_array);
        } else {
            var gallery_by_name = await galleryService.getDefaultGallery(req.body.owner, responseFromService.id);
            console.log(gallery_by_name, "createPicture::gallery_by_name");
            var shared_array = {picture_id: responseFromService.id, album_id:gallery_by_name, main_user_id: responseFromService.owner}
            const responseFromShared = await sharedService.test_create_shared(shared_array);
        }

        response.status = 200;
        response.message = constants.pictureMessage.PICTURE_CREATED;
        responseFromService.tags = responseFromService.tags ? responseFromService.tags.split(",") : [];
        response.body = responseFromService;
    } catch (error) {
        console.log("Something went wrong: Controller: createPicture", error);
        response.message = error.message;
    }
    return res.status(response.status).send(response);
};

module.exports.getAllPictures = async(req, res) => {
    let response = {...constants.defaultServerResponse };
    try {
        // get owner
        const token = req.headers.authorization.split('Bearer')[1].trim();
        const decoded = jwt.verify(token, process.env.SECRET_KEY || 'my-secret-key');
        req.query.owner = decoded.id;
        const responseFromService = await pictureService.getAllPictures(req.query);
        response.status = 200;
        response.message = constants.pictureMessage.PICTURE_FETCHED;
        responseFromService.forEach(p => {
            p.tags = p.tags ? p.tags.split(",") : [];
        });
        let formatedResponse = {};
        formatedResponse.myPictures = responseFromService;
        const responseFromServiceSharedUser = await sharedPictureService.getPictureUser({user_id: decoded.id});
        responseFromServiceSharedUser.forEach(p => {
            p.tags = p.tags ? p.tags.split(",") : [];
        });
        formatedResponse.sharedPictures = responseFromServiceSharedUser;
        response.body = formatedResponse;
    } catch (error) {
        console.log("Something went wrong: Controller: getAllPictures", error);
        response.message = error.message;
    }
    return res.status(response.status).send(response);

};

module.exports.updatePicture = async(req, res) => {
    let response = {...constants.defaultServerResponse };
    try {
        const responseFromService = await pictureService.updatePicture({
            id: req.params.id,
            updateInfo: {
                ...req.body, 
                tags:  (req.body.tags && req.body.tags.length > 0) ? req.body.tags : "" 
              }
        });
        response.status = 200;
        response.message = constants.pictureMessage.PICTURE_UPDATED;
        responseFromService.tags = responseFromService.tags ? responseFromService.tags.split(",") : [];
        response.body = responseFromService;
    } catch (error) {
        console.log("Something went wrong: Controller: updatePicture", error);
        response.message = error.message;
    }
    return res.status(response.status).send(response);
};

module.exports.deletePicture = async(req, res) => {
    let response = {...constants.defaultServerResponse };
    try {
        const responseFromService = await pictureService.deletePicture(req.params);
        response.status = 200;
        response.message = constants.pictureMessage.PICTURE_DELETED;
        response.body = responseFromService;
    } catch (error) {
        console.log("Something went wrong: Controller: deletePicture", error);
        response.message = error.message;
    }
    return res.status(response.status).send(response);
};


module.exports.serveImage = async (req, res) => {
  var path = req.params.url; 
  var root;
  res.status = 200;
  if (path.startsWith('thumb'))
    root = './public/img/picts/thumb/';
  else 
    root = './public/img/picts/original/';
  return res.sendFile(path, {root: root});
};

module.exports.search = async (req, res) => {
  let response = { ...constants.defaultServerResponse };
  req.query.keyword = req.params.keyword;
  const token = req.headers.authorization.split('Bearer')[1].trim();
  req.query.decoded_token = jwt.verify(token, process.env.SECRET_KEY || 'my-secret-key');
  const responseFromService = await pictureService.search(req.query);
  response.status = 200;
  response.message = constants.pictureMessage.SEARCH_DONE;
  responseFromService.forEach(p => {
    p.tags = p.tags ? p.tags.split(",") : [];
});
  responseFromService.tags = responseFromService.tags ? responseFromService.tags.split(",") : [];
  response.body = responseFromService;
  return res.status(response.status).send(response);
};

module.exports.getGalleryByPicture = async(req, res) => {
    let response = { ...constants.defaultServerResponse };
    try {

        const token = req.headers.authorization.split('Bearer')[1].trim();
        const decoded = jwt.verify(token, process.env.SECRET_KEY || 'my-secret-key');
        owner = decoded.id;

        const response_from_picture = await galleryService.getGalleryByPicture(req.body);
        response.status = 200;
        response.message = constants.pictureMessage.GALLERY_BY_PICTURE_DELETED;
        response.body = response_from_picture;

    } catch (error) {
        console.log("Something went wrong: Controller: getGalleryByPicture", error);
        response.message = error.message;
    }

    return res.status(response.status).send(response);
}

module.exports.getGalleryByPicture = async(req, res) => {
    let response = { ...constants.defaultServerResponse };
    try {

        const token = req.headers.authorization.split('Bearer')[1].trim();
        const decoded = jwt.verify(token, process.env.SECRET_KEY || 'my-secret-key');
        owner = decoded.id;

        const response_from_picture = await galleryService.getGalleryByPicture(req.body);
        response.status = 200;
        response.message = constants.pictureMessage.GALLERY_BY_PICTURE_DELETED;
        response.body = response_from_picture;

    } catch (error) {
        console.log("Something went wrong: Controller: getGalleryByPicture", error);
        response.message = error.message;
    }

    return res.status(response.status).send(response);
}

module.exports.getListGalleryByPicture = async(req, res) => {
    let response = { ...constants.defaultServerResponse };
    try {

        const token = req.headers.authorization.split('Bearer')[1].trim();
        const decoded = jwt.verify(token, process.env.SECRET_KEY || 'my-secret-key');
        req.body.owner = decoded.id;
        
        const response_from_picture = await galleryService.getListGalleryByPicture(req.body);
        console.log(response_from_picture);
        response.status = 200;
        response.message = constants.pictureMessage.GALLERY_BY_PICTURE_DELETED;
        let response_list = [];
        response_list = response_from_picture.filter((p) => p.galleryname != "__DEFAULT");
        response.body = response_list;

    } catch (error) {
        console.log("Something went wrong: Controller: getGalleryByPicture", error);
        response.message = error.message;
    }

    return res.status(response.status).send(response);
}

module.exports.getByAlbum = async (req, res) => {
    let response = { ...constants.defaultServerResponse };
    req.query.albumId = req.params.albumId;
    const responseFromService = await pictureService.getByAlbum(req.query);
    response.status = 200;
    response.message = constants.pictureMessage.PICTURE_FETCHED;
    responseFromService.forEach(p => {
      p.tags = p.tags ? p.tags.split(",") : [];
  });
    responseFromService.tags = responseFromService.tags ? responseFromService.tags.split(",") : [];
    response.body = responseFromService;
    return res.status(response.status).send(response);
  };