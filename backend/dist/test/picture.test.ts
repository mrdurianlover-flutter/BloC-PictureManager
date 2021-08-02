const User = require("../../database/models/UserModel");
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


test("GET /api/v1/picture/ without token", async () => {
    const user = await User.create({ url: "bdjkhuh", owner: "hdbuhk" });

    await supertest(app).get("/api/v1/picture/")
        .expect(401)
        .then((response) => {
            expect(Object.keys(response.body.body).length).toEqual(0);
        });
});


test("GET /api/v1/picture/ without token", async () => {
    const user = await User.create({ url: "bdjkhuh", owner: "hdbuhk" });

    await supertest(app).get("/api/v1/picture/")
        .expect(401)
        .then((response) => {
            expect(Object.keys(response.body.body).length).toEqual(0);
        });
});

test("POST /api/v1/picture/ Should work", async () => {
    const signupData = { username: "bob", fullname: "bob", password: "bob" };

    await supertest(app).post("/api/v1/user/signup/")
        .send(signupData)
        .then(async (resSignup) => {
            const userLoggedData = await supertest(app).post("/api/v1/user/login/")
                .send({ username: signupData.username, password: signupData.password })
                .then(async (resLogin) => {
                    const filePath = 'dist/test/media/sun.jpg';
                    const pictsData = { owner: resLogin.body.body.user.id, name: "pict name", tags: "a,b,c" };

                    await supertest(app)
                        .post("/api/v1/picture/")
                        .set('Authorization', 'Bearer ' + resLogin.body.body.token) // Works.
                        .attach('photo', filePath)
                        .field('owner', pictsData.owner)
                        .field('name', pictsData.name)
                        .field('tags', pictsData.tags)
                        .expect(200)
                        .then((response) => {
                            expect(Object.keys(response.body.body).length).toEqual(9);
                            expect(response.body.body).toHaveProperty('owner');
                            expect(response.body.body).toHaveProperty('name');
                            expect(response.body.body).toHaveProperty('tags');
                            expect(response.body.body).toHaveProperty('photo');
                            expect(response.body.body).toHaveProperty('thumbnail');
                        });
                });

        })
});

test("POST /api/v1/picture/ bad file type - Should not work", async () => {
    const signupData = { username: "bob", fullname: "bob", password: "bob" };

    await supertest(app).post("/api/v1/user/signup/")
        .send(signupData)
        .then(async (resSignup) => {
            const userLoggedData = await supertest(app).post("/api/v1/user/login/")
                .send({ username: signupData.username, password: signupData.password })
                .then(async (resLogin) => {
                    const filePath = 'dist/test/media/sun.pdf';
                    const pictsData = { owner: resLogin.body.body.user.id, name: "pict name", tags: "a,b,c" };

                    await supertest(app)
                        .post("/api/v1/picture/")
                        .set('Authorization', 'Bearer ' + resLogin.body.body.token) // Works.
                        .attach('photo', filePath)
                        .field('owner', pictsData.owner)
                        .field('name', pictsData.name)
                        .field('tags', pictsData.tags)
                        .expect(500)
                        .then((response) => {
                            expect(Object.keys(response.body.body).length).toEqual(0);
                        });
                });

        })
});

test("GET /api/v1/picture/ with token - Should work", async () => {
    const signupData = { username: "bob", fullname: "bob", password: "bob" };

    await supertest(app).post("/api/v1/user/login/")
        .send({ username: signupData.username, password: signupData.password })
        .then(async (resLogin) => {
            const filePath = './media/sun.jpg';
            const pictsData = { owner: resLogin.body.body.user.id, name: "pict name", tags: "a,b,c" };

            await supertest(app)
                .get("/api/v1/picture/")
                // .attach('photo', filePath)
                .set('Authorization', 'Bearer ' + resLogin.body.body.token) // Works.
                .expect(200)
                .then((response) => {
                    expect(Object.keys(response.body.body).length).toBeGreaterThan(0);
                    expect(response.body.body).toHaveProperty('myPictures');
                    expect(response.body.body).toHaveProperty('sharedPictures');
                });
        });
});


test("GET /api/v1/picture/search with token - Should work", async () => {
    const signupData = { username: "bob", fullname: "bob", password: "bob" };

    await supertest(app).post("/api/v1/user/login/")
        .send({ username: signupData.username, password: signupData.password })
        .then(async (resLogin) => {
            const filePath = './media/sun.jpg';
            const pictsData = { owner: resLogin.body.body.id, name: "pict name", tags: "a,b,c" };

            await supertest(app)
                .get("/api/v1/picture/search/keayword")
                .set('Authorization', 'Bearer ' + resLogin.body.body.token) // Works.
                .expect(200)
                .then((response) => {
                    // expect(Object.keys(response.body.body).length).toBeGreaterThan(0);
                });
        });
});

test("GET /api/v1/picture/img/:url with token - Should work", async () => {
    const signupData = { username: "bob", fullname: "bob", password: "bob" };

    await supertest(app).post("/api/v1/user/login/")
        .send({ username: signupData.username, password: signupData.password })
        .then(async (resLogin) => {
            await supertest(app)
                .get("/api/v1/picture/")
                .set('Authorization', 'Bearer ' + resLogin.body.body.token) // Works.
                .expect(200)
                .then(async (res) => {
                    await supertest(app)
                        .get("/api/v1/picture/img/" + res.body.body.myPictures[0].photo)
                        .set('Authorization', 'Bearer ' + resLogin.body.body.token) // Works.
                        .expect(200)
                        .then((response) => {
                            // expect(Object.keys(response.body.body).length).toBeGreaterThan(0);
                        });
                });

        });
});

test("PUT /api/v1/picture/ Should work", async () => {
    const signupData = { username: "bob", fullname: "bob", password: "bob" };

    await supertest(app).post("/api/v1/user/login/")
        .send({ username: signupData.username, password: signupData.password })
        .then(async (resLogin) => {
            const pictsData = { owner: resLogin.body.body.id, name: "pict name 2", tags: "a,b,c" };

            await supertest(app)
                .get("/api/v1/picture/")
                // .attach('photo', filePath)
                .set('Authorization', 'Bearer ' + resLogin.body.body.token) // Works.
                .expect(200)
                .then(async (response) => {
                    await supertest(app)
                        .put("/api/v1/picture/" + response.body.body.myPictures[0].id)
                        .set('Authorization', 'Bearer ' + resLogin.body.body.token) // Works.
                        .send(pictsData)
                        .expect(200)
                        .then((r) => {
                            expect(Object.keys(response.body.body).length).toBeGreaterThan(0);
                            // expect(response.body.body).toHaveProperty('owner');
                            // expect(response.body.body).toHaveProperty('name');
                            // expect(response.body.body).toHaveProperty('tags');
                            // expect(response.body.body).toHaveProperty('photo');
                            // expect(response.body.body).toHaveProperty('thumbnail');
                        });
                });
        });
});

test("DELETE /api/v1/picture/:id with token - Should work", async () => {
    const signupData = { username: "bob", fullname: "bob", password: "bob" };

    await supertest(app).post("/api/v1/user/login/")
        .send({ username: signupData.username, password: signupData.password })
        .then(async (resLogin) => {
            const pictsData = { owner: resLogin.body.body.user.id, name: "pict name", tags: "a,b,c" };

            await supertest(app)
                .get("/api/v1/picture/")
                // .attach('photo', filePath)
                .set('Authorization', 'Bearer ' + resLogin.body.body.token) // Works.
                .expect(200)
                .then(async (response) => {
                    await supertest(app)
                        .delete("/api/v1/picture/" + response.body.body.myPictures[0].id)
                        .set('Authorization', 'Bearer ' + resLogin.body.body.token) // Works.
                        .expect(200)
                        .then((r) => {
                            expect(Object.keys(r.body.body).length).toBeGreaterThan(0);
                        });
                });
        });
});


test("PUT /api/v1/picture/ Should not work", async () => {
    const signupData = { username: "bob", fullname: "bob", password: "bob" };

    await supertest(app).post("/api/v1/user/login/")
        .send({ username: signupData.username, password: signupData.password })
        .then(async (resLogin) => {
            const pictsData = { owner: resLogin.body.body.user.id, name: "pict name 2", tags: "a,b,c" };

            await supertest(app)
                .put("/api/v1/picture/60e61d319d66e84ed8dddddd")
                .set('Authorization', 'Bearer ' + resLogin.body.body.token) // Works.
                .send(pictsData)
                .expect(400)
                .then((r) => {
                    expect(Object.keys(r.body.body).length).toEqual(0);
                });
        });
});

test("DELETE /api/v1/picture/:id with token - Should not work", async () => {
    const signupData = { username: "bob", fullname: "bob", password: "bob" };

    await supertest(app).post("/api/v1/user/login/")
        .send({ username: signupData.username, password: signupData.password })
        .then(async (resLogin) => {
            const pictsData = { owner: resLogin.body.body.user.id, name: "pict name", tags: "a,b,c" };

            await supertest(app)
                .get("/api/v1/picture/")
                // .attach('photo', filePath)
                .set('Authorization', 'Bearer ' + resLogin.body.body.token) // Works.
                .expect(200)
                .then(async (response) => {
                    await supertest(app)
                        .delete("/api/v1/picture/60e61d319d66e84ed8dddddd")
                        .set('Authorization', 'Bearer ' + resLogin.body.body.token) // Works.
                        .expect(400)
                        .then((r) => {
                            expect(Object.keys(r.body.body).length).toEqual(0);
                        });
                });
        });
});

