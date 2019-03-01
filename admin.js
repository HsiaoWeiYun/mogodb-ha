admin = db.getSiblingDB('admin');

admin.createUser({
  user: 'victor',
  pwd: '123123',
  roles: [{ role: 'userAdminAnyDatabase', db: 'admin' }],
  mechanisms : ["SCRAM-SHA-1"]
});

db.getSiblingDB('admin').auth('victor', '123123');

db.getSiblingDB('admin').createUser({
  user: 'victorAdmin',
  pwd: '123123',
  roles: [{ role: 'clusterAdmin', db: 'admin' }],
  mechanisms : ["SCRAM-SHA-1"]
});

db.createUser(
 {
   user: "op",
   pwd: "123123",
   roles: [
      { role: "readWrite", db: "test" }
   ],
   mechanisms : ["SCRAM-SHA-1"],
   passwordDigestor : "server"
 });