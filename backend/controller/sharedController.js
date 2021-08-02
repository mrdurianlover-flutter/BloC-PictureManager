const sharedService = require('../service/sharedService');
const constants = require('../constants');
const jwt = require('jsonwebtoken');


module.exports.createShared = async(req, res) => {
    let response = {...constants.defaultServerResponse };
    console.log(req.body);
    try {
        const responseFromService = await sharedService.test_create_shared(req.body);
        response.status = 200;
        response.message = constants.sharedMessage.SHARED_FOUND_SUCESS;
        response.body = responseFromService;
    } catch (error) {
        console.log('Something went wrong : Controller: createShared', error);
        response.message = error.message;
    }

    return res.status(response.status).send(response);
}


module.exports.addPictureUser = async(req, res) => {
    let response = {...constants.defaultServerResponse };
    console.log(req.body);
    try {
        const token = req.headers.authorization.split('Bearer')[1].trim();
        const decoded = jwt.verify(token, process.env.SECRET_KEY);
        req.params.owner = decoded.id;

        const responseFromService = await sharedService.addPictureUser(req.params);
        response.status = 200;
        response.message = constants.sharedMessage.SHARED_FOUND_SUCESS;
        response.body = responseFromService;
    } catch (error) {
        console.log('Something went wrong : Controller: createShared', error);
        response.message = error.message;
    }

    return res.status(response.status).send(response);
}