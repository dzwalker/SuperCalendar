root = exports ? this
root.Logs = new Mongo.Collection('logs')
Meteor.methods
    logInsert:(logAttributes)->
        check(Meteor.userId(), String)
        check(logAttributes,{type: String, objectId:String,detail:Object})
        log = _.extend(logAttributes,{
            userId:Meteor.userId()
            username:Meteor.user().username
            submitted : new Date()
            status : 0

            })
        logId = Logs.insert(log)
        {_id:logId}
