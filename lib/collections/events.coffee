root = exports ? this
root.Events = new Mongo.Collection('events')
Meteor.methods
	eventInsert: (eventAttributes)->
		check(Meteor.userId(), String)
		check(eventAttributes,{title: String, url:String, detail:String, duetime:Date}) #所有插入的内容都要在这里声名
		user = Meteor.user()
		event = _.extend(eventAttributes,{
			userId : user._id
			author : user.username
			submitted : new Date()
			# eventPersons : eventPersons
		})
		eventId = Events.insert(event)
		return {_id : eventId}
	eventAddDate:(eventId, date)->
		check date, Date
		Events.update({id:eventId}, {eventDate:date})
