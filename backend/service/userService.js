const User = require("../database/models/userModel");
const constants = require("../constants");
const { formatMongoData, checkObjectId } = require("../helper/dbHelper");
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");

module.exports.signup = async ({ username, fullname, password }) => {
  try {
    const user = await User.findOne({ username });
    if (user) {
      throw new Error(constants.userMessage.DUPLICATE_EMAIL);
    }
    password = await bcrypt.hash(password, 12);
    const newUser = new User({ username, fullname, password });
    let result = await newUser.save();

    return formatMongoData(result);
  } catch (error) {
    console.log("Something went wrong: Service: signup", error);
    throw new Error(error);
  }
};

module.exports.login = async ({ username, password }) => {
  try {
    const user = await User.findOne({ username });
    if (!user) {
      throw new Error(constants.userMessage.USER_NOT_FOUND);
    }
    const isValid = await bcrypt.compare(password, user.password);
    if (!isValid) {
      throw new Error(constants.userMessage.INVALID_PASSWORD);
    }
    const token = jwt.sign(
      { id: user._id },
      process.env.SECRET_KEY || "my-secret-key",
      { expiresIn: "365d" }
    );
    return {
      user: {
        fullname: user.fullname,
        username: user.username,
        id: user.id
      }, token
    };
  } catch (error) {
    console.log("Something went wrong: Service: login", error);
    throw new Error(error);
  }
};

module.exports.getUserById = async ({ id }) => {
  try {
    checkObjectId(id);
    let user = await User.findById(id);
    if (!user) {
      throw new Error(constants.userMessage.USER_NOT_FOUND);
    }
    return {
      fullname: user.fullname,
      username: user.username,
      id: user.id
    };
  } catch (error) {
    console.log("Something went wrong: Service: getUserById", error);
    throw new Error(error);
  }
};

