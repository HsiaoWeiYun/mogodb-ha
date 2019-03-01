config = {

    "_id" : "mongodb-cluster",
    "writeConcernMajorityJournalDefault" : true,
    "members" : [
      {
        "_id" : 0,
        "host" : "mongo-primary:27017",
        "hidden" : false,
        "priority" : 1,
        "votes" : 1
      },
      {
        "_id" : 1,
        "host" : "mongo-slave:27017",
        "hidden" : false,
        "priority" : 1,
        "votes" : 1
      },
      {
        "_id" : 2,
        "host" : "mongo-arbiter:27017",
        "hidden" : false,
        "arbiterOnly" : true,
        "priority" : 0,
        "votes" : 1
      }
    ]
  };


  rs.initiate(config);
