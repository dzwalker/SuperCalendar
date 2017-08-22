
Template.eventsList.helpers
	events: ()->
		Events.find({},{sort: {duetime: 1}})	 
	
Template.eventsList.events
	'click #load': (e) ->
		# alert 'hi'
		# $("#table").load('http://c.kmf.com/crm/coursepackage')
		null
