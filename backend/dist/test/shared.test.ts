const User = require("../../database/models/UserModel");
const app = require("../../server");
const mongoose = require("mongoose");
const supertest = require("supertest");

// beforeAll((done) => {
//     mongoose.connect("mongodb://localhost/pictsMDB",
//         { useNewUrlParser: true, useUnifiedTopology: true },
//         () => done());
// });

// afterAll((done) => {
//     mongoose.connection.db.dropDatabase(() => {
//         mongoose.connection.close(() => done())
//     });
// });


// test("GET /api/v1/shared/getByOwner without token", async () => {
//     await supertest(app).post("/api/v1/shared/getByOwner/")
//         .expect(401)
//         .then((response) => {
//             expect(Object.keys(response.body.body).length).toEqual(0);
//         });
// });

test("POST /api/v1/shared/createShared Should work", async () => {
    const signupData = { username: "bob2", fullname: "bob2", password: "bob2" };

    await supertest(app).post("/api/v1/user/signup/")
        .send(signupData)
        .then(async (resSignup) => {
            const userLoggedData = await supertest(app).post("/api/v1/user/login/")
                .send({ username: signupData.username, password: signupData.password })
                .then(async (resLogin) => {
                    const sharedData = { picture_id: "60e8c4a0ac52c52048167336", main_user_id: "60e966fca318ec0a70b484be" };

                    await supertest(app)
                        .post("/api/v1/shared/createShared/")
                        .set('Authorization', 'Bearer ' + resLogin.body.body.token) // Works.
                        .send(sharedData)
                        .expect(200);
                });

        })
});


// test("GET /api/v1/shared/getByOwner with token - Should work", async () => {
//     const signupData = { username: "bob2", fullname: "bob2", password: "bob2" };

//     await supertest(app).post("/api/v1/user/login/")
//         .send({ username: signupData.username, password: signupData.password })
//         .then(async (resLogin) => {
//             const filePath = './media/sun.jpg';
//             const pictsData = { owner: resLogin.body.body.user.id, name: "pict name", tags: "a,b,c" };

//             await supertest(app)
//                 .get("/api/v1/shared/getByOwner/")
//                 // .attach('photo', filePath)
//                 .set('Authorization', 'Bearer ' + resLogin.body.body.token) // Works.
//                 .expect(200)
//                 .then((response) => {
//                     expect(Object.keys(response.body.body).length).toBeGreaterThan(0);
//                     expect(response.body.body).toHaveProperty('myShareds');
//                     expect(response.body.body).toHaveProperty('sharedShareds');
//                 });
//         });
// });

// test("DELETE /api/v1/shared/:id with token - Should work", async () => {
//     const signupData = { username: "bob2", fullname: "bob2", password: "bob2" };

//     await supertest(app).post("/api/v1/user/login/")
//         .send({ username: signupData.username, password: signupData.password })
//         .then(async (resLogin) => {
//             const pictsData = { owner: resLogin.body.body.user.id, name: "pict name", tags: "a,b,c" };

//             await supertest(app)
//                 .get("/api/v1/shared/")
//                 // .attach('photo', filePath)
//                 .set('Authorization', 'Bearer ' + resLogin.body.body.token) // Works.
//                 .expect(200)
//                 .then(async (response) => {
//                     await supertest(app)
//                         .delete("/api/v1/shared/" + response.body.body.myShareds[0].id)
//                         .set('Authorization', 'Bearer ' + resLogin.body.body.token) // Works.
//                         .expect(200)
//                         .then((r) => {
//                             expect(Object.keys(r.body.body).length).toBeGreaterThan(0);
//                         });
//                 });
//         });
// });

// test("DELETE /api/v1/shared/:id with token - Should not work", async () => {
//     const signupData = { username: "bob2", fullname: "bob2", password: "bob2" };

//     await supertest(app).post("/api/v1/user/login/")
//         .send({ username: signupData.username, password: signupData.password })
//         .then(async (resLogin) => {
//             const pictsData = { owner: resLogin.body.body.user.id, name: "pict name", tags: "a,b,c" };

//             await supertest(app)
//                 .get("/api/v1/shared/")
//                 // .attach('photo', filePath)
//                 .set('Authorization', 'Bearer ' + resLogin.body.body.token) // Works.
//                 .expect(200)
//                 .then(async (response) => {
//                     await supertest(app)
//                         .delete("/api/v1/shared/60e61d319d66e84ed8dddddd")
//                         .set('Authorization', 'Bearer ' + resLogin.body.body.token) // Works.
//                         .expect(400)
//                         .then((r) => {
//                             expect(Object.keys(r.body.body).length).toEqual(0);
//                         });
//                 });
//         });
// });

