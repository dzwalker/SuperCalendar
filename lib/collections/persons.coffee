root = exports ? this
root.Persons = new Mongo.Collection('persons')
Meteor.methods({
    personInsert: (personAttributes)->
        check(Meteor.userId(), String)
        check(personAttributes,{personName: String, status: String}) 
        personWithSameLink = Persons.findOne({url: personAttributes.url})
        if personWithSameLink
            return {
                eventExists : true
                _id : personWithSameLink
            }
        person = _.extend(personAttributes,{
            submitted : new Date()
        })
        personId = Persons.insert(person)
        return {_id : personId}
})
