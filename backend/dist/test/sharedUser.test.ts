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


// test("GET /api/v1/sharedUser/getByOwner without token", async () => {
//     await supertest(app).post("/api/v1/sharedUser/getByOwner/")
//         .expect(401)
//         .then((response) => {
//             expect(Object.keys(response.body.body).length).toEqual(0);
//         });
// });

test("POST /api/v1/sharedUser/createSharedUser Should work", async () => {
    const signupData = { username: "bob2", fullname: "bob2", password: "bob2" };

    await supertest(app).post("/api/v1/user/signup/")
        .send(signupData)
        .then(async (resSignup) => {
            const userLoggedData = await supertest(app).post("/api/v1/user/login/")
                .send({ username: signupData.username, password: signupData.password })
                .then(async (resLogin) => {
                    const sharedUserData = { shared_id: "60e8c4a0ac52c52048167336", owner_id: "60e966fca318ec0a70b484be" };

                    await supertest(app)
                        .post("/api/v1/sharedUser/createSharedUser/")
                        .set('Authorization', 'Bearer ' + resLogin.body.body.token) // Works.
                        .send(sharedUserData)
                        .expect(200);
                });

        })
});


// test("GET /api/v1/sharedUser/getByOwner with token - Should work", async () => {
//     const signupData = { username: "bob2", fullname: "bob2", password: "bob2" };

//     await supertest(app).post("/api/v1/user/login/")
//         .send({ username: signupData.username, password: signupData.password })
//         .then(async (resLogin) => {
//             const filePath = './media/sun.jpg';
//             const pictsData = { owner: resLogin.body.body.user.id, name: "pict name", tags: "a,b,c" };

//             await supertest(app)
//                 .get("/api/v1/sharedUser/getByOwner/")
//                 // .attach('photo', filePath)
//                 .set('Authorization', 'Bearer ' + resLogin.body.body.token) // Works.
//                 .expect(200)
//                 .then((response) => {
//                     expect(Object.keys(response.body.body).length).toBeGreaterThan(0);
//                     expect(response.body.body).toHaveProperty('mySharedUsers');
//                     expect(response.body.body).toHaveProperty('sharedUserSharedUsers');
//                 });
//         });
// });

// test("DELETE /api/v1/sharedUser/:id with token - Should work", async () => {
//     const signupData = { username: "bob2", fullname: "bob2", password: "bob2" };

//     await supertest(app).post("/api/v1/user/login/")
//         .send({ username: signupData.username, password: signupData.password })
//         .then(async (resLogin) => {
//             const pictsData = { owner: resLogin.body.body.user.id, name: "pict name", tags: "a,b,c" };

//             await supertest(app)
//                 .get("/api/v1/sharedUser/")
//                 // .attach('photo', filePath)
//                 .set('Authorization', 'Bearer ' + resLogin.body.body.token) // Works.
//                 .expect(200)
//                 .then(async (response) => {
//                     await supertest(app)
//                         .delete("/api/v1/sharedUser/" + response.body.body.mySharedUsers[0].id)
//                         .set('Authorization', 'Bearer ' + resLogin.body.body.token) // Works.
//                         .expect(200)
//                         .then((r) => {
//                             expect(Object.keys(r.body.body).length).toBeGreaterThan(0);
//                         });
//                 });
//         });
// });

// test("DELETE /api/v1/sharedUser/:id with token - Should not work", async () => {
//     const signupData = { username: "bob2", fullname: "bob2", password: "bob2" };

//     await supertest(app).post("/api/v1/user/login/")
//         .send({ username: signupData.username, password: signupData.password })
//         .then(async (resLogin) => {
//             const pictsData = { owner: resLogin.body.body.user.id, name: "pict name", tags: "a,b,c" };

//             await supertest(app)
//                 .get("/api/v1/sharedUser/")
//                 // .attach('photo', filePath)
//                 .set('Authorization', 'Bearer ' + resLogin.body.body.token) // Works.
//                 .expect(200)
//                 .then(async (response) => {
//                     await supertest(app)
//                         .delete("/api/v1/sharedUser/60e61d319d66e84ed8dddddd")
//                         .set('Authorization', 'Bearer ' + resLogin.body.body.token) // Works.
//                         .expect(400)
//                         .then((r) => {
//                             expect(Object.keys(r.body.body).length).toEqual(0);
//                         });
//                 });
//         });
// });

