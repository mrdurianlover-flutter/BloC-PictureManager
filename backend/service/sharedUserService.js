const SharedUser = require("../database/models/sharedUserModel");
const Shared = require("../database/models/sharedModel");
const User = require("../database/models/userModel");
const SharedPicture = require("../database/models/sharedPictureModel");
const Picture = require("../database/models/pictureModel");
const { formatMongoData, checkObjectId } = require("../helper/dbHelper");
const constants = require("../constants");
const { sharedUserMessage } = require("../constants");
const app = require("../server");
const { Mongoose } = require("mongoose");

module.exports.getPicturesByOwner = async (id) => {
  try {
    checkObjectId(id.user_id);
    // let main_user_id = checkObjectId(main_user_id);
    console.log("id : ");
    console.log(id.user_id);
    let shared_user_by_owner = await SharedUser.find({
      owner_id: id.user_id,
    }).select("shared_id");
    let array_of_picture_id = [];
    let array_of_pictures = [];
    if (shared_user_by_owner.length < 1) {
      return [];
    }
    console.log("shared user by owner  : ");
    console.log(shared_user_by_owner);
    console.log(shared_user_by_owner[0].shared_id[0]);

    // let galleries = await galleries_by_owner.forEach(function(albums) {
    //     checkObjectId(albums.album_id[0]);
    //     let gallery_by_owner = Gallery.find(albums.album_id[0]).exec();
    //     array_of_galleries.push(gallery_by_owner);
    //     console.log(albums.album_id[0]);
    // })

    for (const shareds of shared_user_by_owner) {
      console.log("shared id : ");
      console.log(shareds.shared_id[0]);
      checkObjectId(shareds.shared_id[0]);
      let shared_by_owner = await Shared.findById(shareds.shared_id[0]).exec();
      console.log("shared_by_owner : ");
      console.log(shared_by_owner);
      array_of_picture_id.push(shared_by_owner.picture_id);
    }

    for (const pictures of array_of_picture_id) {
      console.log("Picture  ID : ");
      console.log(pictures[0]);
      checkObjectId(pictures[0]);
      let picture_by_id = await Picture.findById(pictures[0]).exec();
      console.log("Picture by  ID : ");
      console.log(picture_by_id);
      if (
        picture_by_id &&
        picture_by_id.owner &&
        picture_by_id.owner.toString().trim() !== id.user_id.toString().trim()
      ) {
        array_of_pictures.push(picture_by_id);
      }
    }

    console.log(array_of_pictures);

    if (array_of_pictures.length > 0) {
      return formatMongoData(array_of_pictures);
    } else {
      return [];
    }
  } catch (error) {
    console.log("Something went wrong: Service: getPicturesByOwner", error);
    throw new Error(error);
  }
};

module.exports.createSharedUser = async (serviceData) => {
  try {
    let sharedUser = new SharedUser({ ...serviceData });
    let result = await sharedUser.save();

    return result;
  } catch (error) {
    console.log("Something went wrong: Service: createSharedUser", error);
    throw new Error(error);
  }
};

module.exports.addUserToGallery = async (serviceData) => {
  try {
    var shared_album = await Shared.find({ album_id: serviceData.album_id });
    var insert_shared_user;
    const user = await User.findOne({ username: serviceData.username });

    if (!user) {
      throw new Error("Username " + serviceData.username + " not exist !");
    }
    if (shared_album.length > 0) {
      for (const shareds of shared_album) {
        if (shareds.picture_id.length > 0) {
          let add_to_shared_picture = new SharedPicture({
            picture_id: shareds.picture_id,
            user_id: user.id,
            owner_id: serviceData.owner
          });
          let result = await add_to_shared_picture.save();
          insert_shared_user = {
            shared_id: shareds._id,
            owner_id: user.id,
          };
          response = await this.createSharedUser(insert_shared_user);
        } else {
          let result_shared = await Shared.find({album_id : serviceData.album_id , picture_id: { $ne: [] } });
          insert_shared_user = {
            shared_id: result_shared[0]._id,
            owner_id: user.id,
          };
          response = await this.createSharedUser(insert_shared_user);
        }
        
      }
    }

    return { status: "Album partagé avec l'utilisateur : " + user.username };
  } catch (error) {
    console.log("Something went wrong: Service: addUserToGallery", error);
    throw new Error(error);
  }
};

module.exports.DeleteUserToGallery = async (serviceData) => {
  try {
    var shared_album = await Shared.find({ album_id: serviceData.album_id });
    let response = false;

    for (const shareds of shared_album) {
      let shareds_user = await SharedUser.find({ shared_id: shareds.id });
      if (shareds.picture_id.length > 0) {
        let delete_shared_picture = await SharedPicture.deleteMany({
          picture_id: shareds.picture_id,
          user_id: serviceData.user_id,
        });
      } else {
      }
      if (shareds_user.length > 0) {
        if (
          shareds_user[0].main_user_id !== serviceData.user_id &&
          serviceData.user_id == shareds_user[0].owner_id
        ) {
          let delete_shared_user = await SharedUser.deleteMany({
            shared_id: shareds.id,
            owner_id: serviceData.user_id
          });
          console.log(serviceData, delete_shared_user, "tag dd");
          response = true;
        }
      }
    }
    if (!response) {
      return { status: false };
    } else {
      return { status: true };
    }
  } catch (error) {
    console.log("Something went wrong: Service: addUserToGallery", error);
    throw new Error(error);
  }
};
