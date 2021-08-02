module.exports = {
    defaultServerResponse: {
        status: 400,
        message: "",
        body: {},
    },
    pictureMessage: {
        PICTURE_CREATED: "Picture Created Successfully",
        PICTURE_FETCHED: "Picture Fetched Successfully",
        PICTURE_UPDATED: "Picture Updated Successfully",
        PICTURE_DELETED: "Picture Deleted Successfully",
        GALLERY_BY_PICTURE_DELETED: "Album from Picture Successfully fetched",
        TAG_ADDED_TO_PICTURE: "Tag added to picture Successfully",
        NO_ACCESS_TO_IMAGE: "Unauthorized access to image",
        PICTURE_NOT_FOUND: "Picture Not Found",
        SEARCH_DONE: "Search done Successfully",
    },
    sharedPictureMessage: {
        PICTURE_ADD_USER: "Picture shared with user successfully",
        PICTURE_DELETE_USER_SUCCESS: "Picture is no longer shared with user",
        USER_NOT_FIND: "User not find",
        PICTURE_DELETE_USER_ERROR: "Error while deleting shared rights",
        PICTURE_GET_PICTURE_USER: "Picture shared with user fetched successfully",
        PICTURE_GET_USER_PICTURE: "User shared with picture fetched successfully",
        PICTURE_GET_OWNER_PICTURE: "Owner shared pictures fetched successfully"
    },
    galleryMessage: {
        GALLERY_CREATED: "Gallery Created Successfully",
        USER_RIGHT: "You don't have the privilege to do that",
        PICTURE_NOT_FOUND: "Picture Not Found",
        GALLERY_ADDED: "Picture added to gallery Successfully",
        GALLERY_FETCHED: "Gallery Fetched Successfully",
        GALLERY_UPDATED: "Gallery Updated Successfully",
        GALLERY_DELETED: "Gallery Deleted Successfully",
        GALLERY_NOT_FOUND: "Gallery Not Found",
        PICTURE_DELETE_GALLERY: "Picture successfully deleted from Gallery",
        ALL_GALLERY_USERS: "All Gallery users fetched",
    },
    sharedUserMessage: {
        SHARED_USER_CREATED: "SharedUser Created Successfully",
        SHARED_USER_FETCHED: "SharedUser Fetched Successfully",
        SHARED_USER_UPDATED: "SharedUser Updated Successfully",
        SHARED_USER_DELETED: "SharedUser Deleted Successfully",
        SHARED_USER_NOT_FOUND: "SharedUser Not Found",
        ERROR:  "An error occured while deleting user"
    },
    sharedMessage: {
        SHARED_FOUND_SUCESS: "Shared Fetched Successfully",
        GALLERY_BY_OWNER_NOT_FOUND: "Gallery Not Found",
        SHARED_NOT_FOUND: "Shared Not Found",
        GALLERY_BY_OWNER_FOUND_SUCCESS: "Gallery by Owner Fetched Successfully"
    },
    userMessage: {
        SIGNUP_SUCCESS: "Signup Success",
        LOGIN_SUCCESS: "Login Success",
        DUPLICATE_EMAIL: "User already exist with given username",
        USER_NOT_FOUND: "User not found",
        INVALID_PASSWORD: "Incorrect Password",
        USER_FETCHED: "User Fetched Successfully",
    },
    requestValidationMessage: {
        BAD_REQUEST: "Invalid fields",
        TOKEN_MISSING: "Token missing from header",
    },
    databaseMessage: {
        INVALID_ID: "Invalid Id",
    },
    tagMessage: {
        TAG_CREATED: "Tag Created Successfully",
        TAG_FETCHED: "Tag Fetched Successfully",
        TAG_UPDATED: "Tag Updated Successfully",
        TAG_DELETED: "Tag Deleted Successfully",
        TAG_NOT_FOUND: "Tag Not Found",
    },
};