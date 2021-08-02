const Shared = require('../database/models/sharedModel');
const SharedPicture = require('../database/models/sharedPictureModel');
const User = require('../database/models/userModel');
const Picture = require('../database/models/pictureModel');
const Gallery = require('../database/models/galleryModel');
const service_gallery = require('./galleryService');
const { formatMongoData, checkObjectId } = require('../helper/dbHelper');
const constants = require('../constants');
const { sharedMessage } = require('../constants');

module.exports.addPictureUser = async(serviceData) => {
    try {
        console.log(serviceData, "AddPictureUser");

        let user_by_id = await User.find({username:serviceData.username});
        console.log(user_by_id);
        if (user_by_id.length > 0) {
                console.log(user_by_id);
            let sharedArray = {picture_id: serviceData.picture_id, user_id:user_by_id[0].id, owner_id:serviceData.owner}
            let sharedPicture = new SharedPicture({...sharedArray});
            let result = await sharedPicture.save();

            return {status:true};
        } else {
            return {status:false};
        }

    } catch (error) {
        console.log("Something went wrong: Service: test_create_shared", error);
        throw new Error(error);
    }
}

module.exports.getPictureUser = async(serviceData) => {
    try {
        console.log(serviceData, "getPictureUser");
        let array_return = [];
        let shared_by_user = await SharedPicture.find({user_id: serviceData.user_id});

        if(shared_by_user.length == 0) {
            return [];
        } else {
            for (const shared_picture of shared_by_user) {
                let user_by_picture = await Picture.findById(shared_picture.picture_id);
                if(user_by_picture) {
                    array_return.push(user_by_picture);
                }
            }
            return formatMongoData(array_return);
        }
    } catch (error) {
        console.log("Something went wrong: Service: test_create_shared", error);
        throw new Error(error);
    }
}

module.exports.getUserPicture = async(serviceData) => {
    try {
        console.log(serviceData, "getUserPicture");
        let array_return = [];
        let shared_by_picture = await SharedPicture.find({picture_id: serviceData.picture_id});
        if(shared_by_picture.length == 0) {
            return [];
        } else {
            for (const shared_picture of shared_by_picture) {
                let user_by_picture = await User.findById(shared_picture.user_id);
                if(user_by_picture) {
                    array_return.push(user_by_picture);
                }
            }
            return formatMongoData(array_return);
        }

    } catch (error) {
        console.log("Something went wrong: Service: test_create_shared", error);
        throw new Error(error);
    }
}

module.exports.getOwnerPicture = async(serviceData) => {
    try {
        console.log(serviceData, "getOwnerPicture");

        let shared_by_owner = await SharedPicture.find({owner_id: serviceData.owner_id});

        if(shared_by_owner.length == 0) {
            return [];
        } else {
            return formatMongoData(shared_by_owner);
        }

    } catch (error) {
        console.log("Something went wrong: Service: test_create_shared", error);
        throw new Error(error);
    }
}

module.exports.deletePictureUser = async(serviceData) => {
    try {
        console.log(serviceData, "deletePictureUser");
        let user_by_id = await User.find({username:serviceData.username});
        console.log(user_by_id);
        if (user_by_id.length > 0) {
            console.log(user_by_id);
            let delete_shared_picture = await SharedPicture.deleteOne({picture_id: serviceData.picture_id, user_id: user_by_id[0].id});

            console.log(delete_shared_picture, "delete_shared_picture");

            if(delete_shared_picture.deletedCount > 0 ) {
                return {status:true, id_user:user_by_id[0].id};
            } else {
                return {status:false, id_user:user_by_id[0].id};
            }
        } else {
            return {status:false};
        }
    } catch (error) {
        console.log("Something went wrong: Service: test_create_shared", error);
        throw new Error(error);
    }
}