const { date } = require("@hapi/joi");
const mongoose = require("mongoose");
const Schema = mongoose.Schema;

const sharedSchema = new Schema(
  {
    picture_id: [{ type: Schema.Types.ObjectId, ref: "Picture" }],
    main_user_id: [{ type: Schema.Types.ObjectId, ref: "User" }],
    // shared_user_id: [{ type: Schema.Types.ObjectId, ref: "SharedUser" }],
    album_id: [{ type: Schema.Types.ObjectId, ref: "Gallery" }],
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

module.exports = mongoose.model("Shared", sharedSchema);
