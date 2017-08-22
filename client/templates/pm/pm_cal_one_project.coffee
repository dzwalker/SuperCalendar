Template.pmCalOneProject.helpers
    queryString:()->
        query = {}
        _.extend(query,Template.parentData(5).data.query)
        $.param(query)

    cssStyle:()->
        done = "projectNotCompleted"
        if this.status is 1
            done = "projectCompleted"
        done
    _id:()->
        this._id

    isWithoutObjectCSS:()->
        isWithoutObjectCSS = "projectWithoutObject"
        projectId = this._id
        countObject = ProjectObjects.find({projectId:projectId}).count()
        if countObject > 0
            isWithoutObjectCSS = ""
        isWithoutObjectCSS
    title:()->
        titleString = ""
        if this.title is ""
            titleString += "空白内容"
        titleString += this.title
        for person in this.persons
            titleString += " @" + person
        for topic in this.topics
            titleString += " #" + topic
        titleString
