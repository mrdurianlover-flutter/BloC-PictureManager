const constants = require('../constants');
const userService = require('../service/userService');
const galleryService = require('../service/galleryService');

module.exports.signup = async (req, res) => {
  let response = { ...constants.defaultServerResponse };
  try {
    const responseFromService = await userService.signup(req.body);
    response.status = 200;
    response.message = constants.userMessage.SIGNUP_SUCCESS;
    response.body = responseFromService;
  } catch (error) {
    console.log('Something went wrong: Controller: signup', error);
    response.message = error.message;
  }
  return res.status(response.status).send(response);
}

module.exports.login = async (req, res) => {
  let response = { ...constants.defaultServerResponse };
  try {
    const responseFromService = await userService.login(req.body);
    response.status = 200;
    response.message = constants.userMessage.LOGIN_SUCCESS;
    response.body = responseFromService;
    console.log(responseFromService);
    var gallery_by_name = await galleryService.getDefaultGallery(responseFromService.user.id);
    console.log(gallery_by_name, "login::gallery_by_name");
    response.body = responseFromService;
  } catch (error) {
    console.log('Something went wrong: Controller: login', error);
    response.message = error.message;
  }
  return res.status(response.status).send(response);
}

module.exports.getUserById = async (req, res) => {
  let response = { ...constants.defaultServerResponse };
  try {
    const responseFromService = await userService.getUserById(req.params);
    response.status = 200;
    response.message = constants.userMessage.USER_FETCH;
    response.body = responseFromService;
  } catch (error) {
    console.log("Something went wrong: Controller: getUserById", error);
    response.message = error.message;
  }
  return res.status(response.status).send(response);
};
