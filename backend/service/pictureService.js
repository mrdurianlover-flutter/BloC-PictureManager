const Picture = require("../database/models/pictureModel");
const Shared = require("../database/models/sharedModel");
const { formatMongoData, checkObjectId } = require("../helper/dbHelper");
const constants = require("../constants");

module.exports.createPicture = async (serviceData) => {
  let picture = new Picture({ ...serviceData });
  let result = await picture.save();
  return formatMongoData(result);
};

module.exports.getAllPictures = async ({ owner }) => {
  let pictures = await Picture.find({ owner: owner });
  return formatMongoData(pictures);
};

module.exports.updatePicture = async ({ id, updateInfo }) => {
  checkObjectId(id);
  let picture = await Picture.findOneAndUpdate({ _id: id }, updateInfo, {
    new: true,
  });
  if (!picture) {
    throw new Error(constants.pictureMessage.PICTURE_NOT_FOUND);
  }
  return formatMongoData(picture);
};

module.exports.deletePicture = async ({ id }) => {
  checkObjectId(id);
  let picture = await Picture.findByIdAndDelete(id);
  if (!picture) {
    throw new Error(constants.pictureMessage.PICTURE_NOT_FOUND);
  }
  return formatMongoData(picture);
};

module.exports.search = async ({ keyword, decoded_token }) => {
  // get owner
  let pictures = await Picture.find({
    $or: [{ name: { $regex: keyword } }, { tags: { $regex: keyword } }],
    owner: decoded_token.id,
  });

  return formatMongoData(pictures);
};

module.exports.getByAlbum = async ({ albumId }) => {
  let shareds = await Shared.find({ album_id: albumId });
  let pictures = [];
  for (const s of shareds) {
    if (s.picture_id.length != 0) {
      let p = await Picture.findOne({ _id: s.picture_id[0] });
      pictures.push(p);
    }
  }
  pictures = pictures.filter((p) => p != null);

  

  return formatMongoData(pictures);
};
