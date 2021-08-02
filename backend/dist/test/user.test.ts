const app = require("../../server");
const mongoose = require("mongoose");
const supertest = require("supertest");

beforeAll((done) => {
    mongoose.connect("mongodb://localhost/pictsMDB",
        { useNewUrlParser: true, useUnifiedTopology: true },
        () => done());
});

afterAll((done) => {
    mongoose.connection.db.dropDatabase(() => {
        mongoose.connection.close(() => done())
    });
});

test("POST /api/v1/user/login/ User Not exist", async () => {
    const loginData = { username: "bobbdkvchdg", password: "bobgidyueg" };

    await supertest(app)
        .post("/api/v1/user/login/")
        .send(loginData)
        .expect(400)
        .then((response) => {
            expect(Object.keys(response.body.body).length).toEqual(0);
        });
});

test("POST /api/v1/user/signup/ Should work", async () => {
    const loginData = { username: "bob1", fullname: "bob1", password: "bob1" };

    await supertest(app)
        .post("/api/v1/user/signup/")
        .send(loginData)
        .expect(200)
        .then((response) => {
            expect(Object.keys(response.body.body).length).toBeGreaterThan(0);
            expect(response.body.body).toHaveProperty('pictures');
            expect(response.body.body).toHaveProperty('username');
            expect(response.body.body).toHaveProperty('fullname');
            expect(response.body.body).toHaveProperty('createdAt');
            expect(response.body.body).toHaveProperty('updatedAt');
            expect(response.body.body).toHaveProperty('id');
        });
});

test("POST /api/v1/user/signup/ Invalid Data", async () => {
    const loginData = { username: "bob1", fullname: "bob1" };

    await supertest(app)
        .post("/api/v1/user/signup/")
        .send(loginData)
        .expect(400)
        .then((response) => {
            expect(Object.keys(response.body.body).length).toEqual(1)
            expect(response.body.body[0]).toHaveProperty('path');
        });
});
