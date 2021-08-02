const express = require("express");
const dotEnv = require("dotenv");
const cors = require("cors");
const path = require("path");
const swaggerUi = require("swagger-ui-express");
const YAML = require("yamljs");
const swaggerDocument = YAML.load("./swagger.yaml");
const dbConnection = require("./database/connection");

dotEnv.config();

const app = express();

// db connectivity
dbConnection();

// cors
app.use(cors());

// request payload middleware
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.use("/api/v1/picture", require("./routes/pictureRoutes"));
app.use("/api/v1/user", require("./routes/userRoutes"));
app.use("/api/v1/gallery", require("./routes/galleryRoutes"));
app.use("/api/v1/shared", require("./routes/sharedRoutes"));
app.use("/api/v1/sharedUser", require("./routes/sharedUserRoutes"));
app.use("/api/v1/sharedPicture", require("./routes/sharedPictureRoutes"));

// API Documentation
if (process.env.NODE_ENV != "production") {
    app.use("/api-docs", swaggerUi.serve, swaggerUi.setup(swaggerDocument));
}
app.get("/", (req, res, next) => {
    if (process.env.NODE_ENV != "production") {
        res.sendFile(path.join(__dirname + "/render/welcome.html"));
    } else {
        res.sendFile(path.join(__dirname + "/render/welcome_prod.html"));
    }
});


// error handler middleware
app.use(function(err, req, res, next) {
    console.error(err.stack);
    res.status(500).send({
        status: 500,
        message: err.message,
        body: {},
    });
});

module.exports = app;