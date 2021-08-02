const mongoose = require("mongoose");
const Schema = mongoose.Schema;

const pictureSchema = new Schema(
  {
    url: String,
    owner: { type: Schema.Types.ObjectId, ref: "User" },
    name: String,
    photo: String,
    thumbnail: String,
    tags: String,
  },
  {
    timestamps: true,
    toObject: {
      transform: function (doc, ret, options) {
        ret.id = ret._id;
        delete ret._id;
        delete ret.__v;
        return ret;
      },
    },
  }
);

module.exports = mongoose.model("Picture", pictureSchema);
