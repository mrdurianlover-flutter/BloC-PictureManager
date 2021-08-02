const { date } = require('@hapi/joi');
const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const sharedPictureSchema = new Schema({
    owner_id: { type: Schema.Types.ObjectId, ref: "User" },
    user_id: { type: Schema.Types.ObjectId, ref: "User" },
    picture_id: { type: Schema.Types.ObjectId, ref: "Picture" },
}, {
    timestamps: true,
    toObject: {
        transform: function(doc, ret, options) {
            ret.id = ret._id;
            delete ret._id;
            delete ret.id;
            delete ret.__v;
            return ret;
        },
    },
});

module.exports = mongoose.model("SharedPicture", sharedPictureSchema);