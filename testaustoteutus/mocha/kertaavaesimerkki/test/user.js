let mongoose = require('mongoose');
let User = require('../models/user');
let chai = require('chai');
let chaiHttp = require('chai-http');
let server = require('../index');
let should = chai.should();

chai.use(chaiHttp);

describe('Users', () => {
  beforeEach((done) => {
    User.remove({}, (err) => {
      done();
    });
  });

  describe('/POST user', () => {
    it('it should not create a user without email address', (done) => {
      let user = {
        firstName: 'John',
        lastName: 'Doe',
        username: 'user',
        password: 'pass',
      };
      chai.request(server).post('/user').send(user).end((err, res) => {
        res.should.have.status(200);
        res.body.should.be.a('object');
        res.body.should.have.property('errors');
        res.body.errors.emailAddress.should.have.property('kind').
            eql('required');
        done();
      });
    });

    it('it should create a user ', (done) => {
      let user = {
        firstName: 'John',
        lastName: 'Doe',
        emailAddress: 'doe@email.com',
        username: 'me',
        password: 'pass',
      };
      chai.request(server).post('/user').send(user).end((err, res) => {
        res.should.have.status(200);
        res.body.should.be.a('object');
        res.body.should.have.property('message').
            eql('User successfully created');
        res.body.user.should.have.property('firstName');
        res.body.user.should.have.property('lastName');
        res.body.user.should.have.property('emailAddress');
        res.body.user.should.have.property('username');
        done();
      });
    });
  });

  describe('/GET user', () => {
    it('it should GET all the users', (done) => {
      chai.request(server).get('/user').end((err, res) => {
        res.should.have.status(200);
        res.body.should.be.a('array');
        res.body.length.should.be.eql(0);
        done();
      });
    });
  });

  describe('/PUT/:id user', () => {
    it('it should update a user given an id', (done) => {
      let user = new User({
        firstName: 'John',
        lastName: 'Doe',
        emailAddress: 'doe@email.com',
        username: 'user',
        password: 'pass',
      });
      user.save((err, user) => {
        chai.request(server).
            put('/user/' + user.id).
            send({
              firstName: 'John',
              lastName: 'Doe',
              emailAddress: 'john@email.com',
              username: 'user',
              password: 'pass',
            }).
            end((err, res) => {
              res.should.have.status(200);
              res.body.should.be.a('object');
              res.body.should.have.property('message').eql('User updated');
              res.body.user.should.have.property('emailAddress').
                  eql('john@email.com');
              done();
            });
      });
    });
  });

  describe('/DELETE/:id user', () => {
    it('it should delete a user given an id', (done) => {
      let user = new User({
        firstName: 'John',
        lastName: 'Doe',
        emailAddress: 'doe@email.com',
        username: 'user',
        password: 'pass',
      });
      user.save((err, user) => {
        chai.request(server).delete('/user/' + user.id).end((err, res) => {
          res.should.have.status(200);
          res.body.should.be.a('object');
          res.body.should.have.property('message').eql('User deleted');
          done();
        });
      });
    });
  });
});