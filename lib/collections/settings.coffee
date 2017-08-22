root = exports ? this
root.Settings = new Mongo.Collection('settings')
Meteor.methods
    updateSettings: (name, updateProperties)->
        setting = Settings.findOne({name:name})
        if setting

            Settings.update({_id:setting._id},{$set:{value:updateProperties}},(error)->
                if error
                    console.log error
            )
        else
            Settings.insert({name:name, value: updateProperties})
        null
