const { date } = require('@hapi/joi');
const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const sharedUserSchema = new Schema({
    shared_id: [{ type: Schema.Types.ObjectId, ref: "Shared" }],
    owner_id: [{ type: Schema.Types.ObjectId, ref: "User" }],

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

module.exports = mongoose.model("SharedUser", sharedUserSchema);