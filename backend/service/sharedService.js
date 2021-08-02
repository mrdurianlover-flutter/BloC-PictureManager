const Shared = require("../database/models/sharedModel");
const SharedUser = require("../database/models/sharedUserModel");
const Gallery = require("../database/models/galleryModel");
const service_gallery = require("./galleryService");
const { formatMongoData, checkObjectId } = require("../helper/dbHelper");
const constants = require("../constants");
const { sharedMessage } = require("../constants");
// const ObjectId = require('mongoose').Types.ObjectId;

// Fonction temporaire , Juste pour inserer rapidement

module.exports.test_create_shared = async (serviceData) => {
  try {
    let shared = new Shared({ ...serviceData });
    let result = await shared.save();

    return result;
  } catch (error) {
    console.log("Something went wrong: Service: test_create_shared", error);
    throw new Error(error);
  }
};


module.exports.getSharedByAlbumByOwner = async (p_owner) => {
  try {
    let array_mySharedAlbums = [];
    let array_shareds = [];

    let result_shared_user = await SharedUser.find({ owner_id: p_owner });
    console.log(result_shared_user, "result_shared_user::getSharedByAlbumByOwner");
    if (result_shared_user.length > 0) {
      for (const shareds_user of result_shared_user) {
        console.log("ID TESTER : " + shareds_user.shared_id);
        let result_shared = await Shared.find({_id : shareds_user.shared_id , picture_id: { $ne: [] } });
        console.log(result_shared, "result_shared::getSharedByAlbumByOwner");
        if(result_shared.length > 0 ) {
          if(result_shared[0].picture_id.length > 0) {
            array_shareds.push(result_shared);
          }
        }
      }
      console.log("array_shareds");

      for (const shareds of array_shareds) {
        console.log(shareds);
        if (
          shareds[0] &&
          shareds[0].main_user_id &&
          shareds[0].main_user_id.length > 0 &&
          shareds[0].picture_id.length > 0 &&
          shareds[0].main_user_id.toString().trim() !==
            p_owner.toString().trim()
        ) {
          console.log("Shareds success: ");
          let result_albums = await Gallery.findById(shareds[0].album_id);
          array_mySharedAlbums.push(result_albums);

          // Delete duplicate 
          new_array = array_mySharedAlbums.filter((v,i,a)=>a.findIndex(t=>(t.id === v.id))===i)
          array_mySharedAlbums = new_array;
          continue;
        } else {
          console.log('continuer;;;;;');
          continue;
        }
      }
      return formatMongoData(array_mySharedAlbums);
    } else {
      array_mySharedAlbums = [];
    }
    return array_mySharedAlbums;
  } catch (error) {
    console.log(
      "Something went wrong: Service: getSharedByAlbumByOwner",
      error
    );
    throw new Error(error);
  }
};

module.exports.deletePictureGallery = async (serviceData) => {
  try {
    console.log(serviceData);
    console.log(serviceData.picture_id);
    try {
      checkObjectId(serviceData.picture_id);
      checkObjectId(serviceData.album_id);
      let shared_ = await Shared.deleteOne({
        picture_id: serviceData.picture_id,
        album_id: serviceData.album_id,
        main_user_id: serviceData.owner,
      });
      console.log(shared_.deletedCount);

      if (shared_.deletedCount > 0) {
        return { status: true };
      } else {
        return { status: false };
      }
    } catch (error) {
      return { status: false };
    }

    console.log(shared_);
  } catch (error) {
    console.log("Something went wrong: Service: deletePictureGallery", error);
    throw new Error(error);
  }
};

module.exports.addPictureUser = async (serviceData) => {
  try {
    console.log(serviceData, "Service Data AddPictureUser");
    let shared = await Shared.find({
      picture_id: serviceData.picture_id,
      main_user_id: serviceData.owner,
    });

    console.log(shared, "Find shared by picture_id & main_user_id");
    try {
    } catch (error) {
      return [];
    }

    return [];
  } catch (error) {
    console.log("Something went wrong: Service: deletePictureGallery", error);
    throw new Error(error);
  }
};
