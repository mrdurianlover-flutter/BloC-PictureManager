const Gallery = require("../database/models/galleryModel");
const Picture = require("../database/models/pictureModel");
const galleryService = require('../service/galleryService');
const User = require("../database/models/userModel");
const { formatMongoData, checkObjectId } = require("../helper/dbHelper");
const constants = require("../constants");
const Shared = require("../database/models/sharedModel");
const Shared_User = require("../database/models/sharedUserModel");

module.exports.createGallery = async (serviceData) => {
  try {
    let gallery = new Gallery({ ...serviceData });
    let result = await gallery.save();
    let array_shared = { album_id: result.id, main_user_id: serviceData.owner };
    let shared = new Shared({ ...array_shared });
    let shared_result = await shared.save();
    console.log(shared);

    return formatMongoData(result);
  } catch (error) {
    console.log("Something went wrong: Service: createGallery", error);
    throw new Error(error);
  }
};

module.exports.addtoGallery = async (serviceData) => {
  try {
    console.log("add to gallery");
    console.log(serviceData);
    let user_by_album = await Picture.find({ owner: serviceData.main_user_id });
    let shared_by_main_user = await Shared.find({
      main_user_id: serviceData.main_user_id,
    });
    console.log(shared_by_main_user);
    console.log(user_by_album, "user_by_album");
    if (shared_by_main_user.length > 0) {
      if (user_by_album.length > 0) {
        console.log(user_by_album);
        let shared_model = new Shared({ ...serviceData });
        let result = await shared_model.save();
        return { status: true };
      } else {
        return { status: false };
      }
    } else {
      return { status: false };
    }
  } catch (error) {
    console.log("Something went wrong: Service: addtoGallery", error);
    throw new Error(error);
  }
};

module.exports.deletefromGallery = async (serviceData) => {
  try {
    console.log(serviceData, "deletefromGallery");

    return [];
  } catch (error) {
    console.log("Something went wrong: Service: addtoGallery", error);
    throw new Error(error);
  }
};

module.exports.getGalleryById = async (serviceData) => {
  try {
  } catch (error) {
    console.log("Something went wrong: Service: getGalleryById", error);
    throw new Error(error);
  }
};

module.exports.updateGalleryById = async (serviceData) => {
  try {
    console.log("ServiceData");
    console.log(serviceData);
    let return_update_gallery = await Gallery.findById(
      serviceData.album_id,
      function (err, p) {
        if (!p) {
          console.log("Could not load Document");
          return next(new Error("Could not load Document"));
        } else {
          p.galleryname = serviceData.galleryname;
          console.log(p);
          p.save(function (err) {
            if (err) {
              console.log("error");
              response.push({ status: "Error update" });
            } else {
              console.log("success");
            }
          });
        }
      }
    );

    return formatMongoData(return_update_gallery);
  } catch (error) {
    console.log("Something went wrong: Service: updateGalleryById", error);
    throw new Error(error);
  }
};

module.exports.deleteGalleryById = async ({ id }) => {
  try {
    checkObjectId(id);
    let gallery = await Gallery.findByIdAndDelete(id);
    let shareds = await Shared.find({ album_id: id });
    console.log(shareds);
    if (shareds.length > 0) {
      let shared_user = await Shared_User.findOneAndDelete({
        shared_id: shareds[0]._id,
      });

      let shared_delete = await Shared.findByIdAndDelete(shareds[0]._id);
      console.log("shared deleted");
      console.log(shareds);
      console.log("shared deleted user ");
      console.log(shared_user);
    }

    if (!gallery) {
      throw new Error(constants.galleryMessage.GALLERY_NOT_FOUND);
    }
    return formatMongoData(gallery);
  } catch (error) {
    console.log("Something went wrong: Service: deleteGalleryById", error);
    throw new Error(error);
  }
};

module.exports.getAllGalleryByOwner = async (owner) => {
  try {
    console.log("Owner : " + owner);
    let all_gallery = await Gallery.find({ owner: owner });
    if (all_gallery && all_gallery.length > 0) {
      return formatMongoData(all_gallery);
    } else {
      return  [];
    }
  } catch (error) {
    console.log("Something went wrong: Service: getAllGallery", error);
    throw new Error(error);
  }
};

module.exports.getDefaultGallery = async (owner_id, p_picture_id) => {
  try {
    var exist = false;
    console.log(owner_id, "getDefaultGallery::owner_id");
    let default_gallery = await Gallery.find({ galleryname: "__DEFAULT" });
    let shared_default_by_user = await Shared.find({main_user_id:owner_id});

    console.log(shared_default_by_user , "getDefaultGallery::shared_default_by_user");
    if(shared_default_by_user.length > 0) {
        for (const shareds of shared_default_by_user) {
          console.log(shareds, "shareds");
          let gallery_by_shared = await Gallery.findById(shareds.album_id);
          if(gallery_by_shared !== null ) {
              if(gallery_by_shared.galleryname == "__DEFAULT") {
                exist = true;
                console.log('EXIST 1');
                return gallery_by_shared.id;
                break;
              }
          } else {
            continue;
          }
        }
      } else {
        let create_default_gallery = await galleryService.createGallery({galleryname: "__DEFAULT", owner: owner_id});
        var shared_array = {picture_id: p_picture_id, album_id:create_default_gallery.id, main_user_id: owner_id}
        let shared = new Shared({...shared_array});
        console.log(shared_array, "getDefaultGallery::result l.176");
        return false;
      }
    


    

  /*  console.log(default_gallery.length, "default_gallery");
    console.log(shared_default_by_user, "shared_default_by_user");
    let finded_gallery = [];

    for (const shareds of shared_default_by_user) {
      console.log(shareds, "shareds");
      let gallery_by_shared = await Gallery.findById(shareds.album_id);
      if(gallery_by_shared !== null ) {
          if(gallery_by_shared.galleryname == "__DEFAULT") {
            exist = true;
            console.log('EXIST 1');
            finded_gallery.push(gallery_by_shared);
            break;
          }
      } else {
        continue;
      }
    }
    if(!exist) {
      console.log('NOT EXIST');
      let create_default_gallery = await galleryService.createGallery({galleryname: "__DEFAULT", owner_id: owner_id, picture_id: p_picture_id});
      console.log(create_default_gallery, "create_default_gallery");
      let shared_default = await Shared.find({album_id:create_default_gallery.id, main_user_id:owner_id});

      return formatMongoData(shared_default);
    } else {
      console.log('EXIST 2');
      return false;
    } */
  } catch (error) {
    console.log("Something went wrong: Service: getAllGallery", error);
    throw new Error(error);
  }
};

module.exports.getGalleryByPicture = async (serviceData) => {
  try {
    let get_by_gallery = await Shared.find({
      picture_id: serviceData.picture_id,
    });
    console.log(get_by_gallery);
    var index = 0;
    if (get_by_gallery.length < 1) {
      return [];
    } else {
      if (get_by_gallery.length > 1) {
        index = 1;
      }
      let find_gallery = await Gallery.findById(get_by_gallery[index].album_id);
      return formatMongoData(find_gallery);
    }

    return formatMongoData(get_by_gallery);
  } catch (error) {
    console.log("Something went wrong: Service: getGalleryByPicture", error);
    throw new Error(error);
  }
};

module.exports.getListGalleryByPicture = async (serviceData) => {
  try {
    console.log(serviceData);

    let gallery_by_owner = await Gallery.find({ owner: serviceData.owner });
    let formatted_return = [];
    console.log(gallery_by_owner, "gallery_by_owner");
    for (const albums of gallery_by_owner) {
      let shared_by_picture = await Shared.find({
        picture_id: serviceData.picture_id,
        album_id: albums.id,
      });
      console.log(shared_by_picture , "shared_by_picture::getListGalleryByPicture l.239");
      let tmp = {};
      tmp.galleryname = albums.galleryname;
      tmp.id = albums.id;
      if (shared_by_picture.length > 0) {
        for (const shareds of shared_by_picture) {
          if (shareds.album_id == albums.id) {
            tmp.hasPicture = true;
            break;
          } else {
            tmp.hasPicture = false;
          }
        }
      } else {
        tmp.hasPicture = false;
      }
      formatted_return.push(tmp);
    }
    console.log(formatted_return);
    return formatted_return;
  } catch (error) {
    console.log("Something went wrong: Service: getGalleryByPicture", error);
    throw new Error(error);
  }
};

module.exports.getAllUsers = async ({ galleryId }) => {
  let shareds = await Shared.find({ album_id: galleryId });
  let sharedUsers = [];

  for (const s of shareds) {
    if (s.picture_id.length === 0) {
        continue;
    }
    console.log(s.picture_id, "coucou")
    let p = await Shared_User.findOne({ shared_id: s.id });
    if (p && p.owner_id && p.owner_id.length > 0) {
      const user = await User.findOne({ _id: p.owner_id[0] });
      if (sharedUsers.filter(u => u.id === user.id).length === 0) { 
        console.log(sharedUsers.filter(u => u.id === user.id), user);
        sharedUsers.push(await User.findOne({ _id: p.owner_id[0] }));
      }
    }
  }
  sharedUsers = sharedUsers.filter((p) => p != null);
  return formatMongoData(sharedUsers);
};

module.exports.getDefaultGalleryNameByUserId = async (user_id) => {
  try {
    let default_gallery = await Gallery.find({ galleryname: "__DEFAULT" });
    let shared_default_by_user = await Shared.find({main_user_id:user_id});
    console.log(default_gallery.length, "default_gallery");
    console.log(shared_default_by_user, "shared_default_by_user");
    var exist = false;
    let finded_gallery = [];

    for (const shareds of shared_default_by_user) {
      let gallery_by_shared = await Gallery.findById(shareds.album_id);
      if(gallery_by_shared !== null ) {
          if(gallery_by_shared.galleryname == "__DEFAULT") {
            exist = true;
            finded_gallery.push(gallery_by_shared);
            break;
          }
      } else {
        continue;
      }
    }

    return formatMongoData(finded_gallery);

  } catch (error) {
    console.log("Something went wrong: Service: getDefaultGalleryNameByUserId", error);
    throw new Error(error);
  }
}
