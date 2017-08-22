Template.eventItem.helpers
    brief: () ->
    	if this.detail
	        detail = this.detail
	        return detail[0..10]
	    else
	    	return "[无简介]"
	    


