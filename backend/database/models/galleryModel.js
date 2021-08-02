const { date } = require('@hapi/joi');
const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const gallerySchema = new Schema({
    galleryname: String,
    owner: { type: Schema.Types.ObjectId, ref: "Users" }
}, {
    timestamps: true,
    toObject: {
        transform: function(doc, ret, options) {
            ret.id = ret._id;
            delete ret._id;
            delete ret.shared_pictures;
            delete ret.__v;
            return ret;
        },
    },
});

module.exports = mongoose.model("Gallery", gallerySchema);