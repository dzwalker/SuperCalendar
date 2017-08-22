Template.oneActivity.helpers
    queryString:()->
        query = {}
        _.extend(query,Template.parentData(5).data.query)
        $.param(query)
    isVisable:()->
        exam = Session.get("_exam")

        if this.status is 0
            return true
        else
            if Roles.userIsInRole(Meteor.user(),'admin',exam)
                return true
            else
                return false
        null
    cssStyle:()->
        temp = ""
        if this.status is 1
            temp = "temp"
        temp
    activityQuery:()->
        exam = Session.get("_exam")
        {_id:this._id, _exam:exam}
    activityID:()->
        this._id
    teachers:()->
        teachers = []
        exam = Session.get("_exam")
        settingTeachers = Settings.findOne({name:'teachers'}).value

        for t in this.teachers
            teachers.push {id:t, shortName: settingTeachers[t].shortName}
        teachers
    title:()->
        exam = Session.get("_exam")
        teachers = []
        settingTeachers = Settings.findOne({name:'teachers'}).value
        settingActivityTypes = Settings.findOne({name:'activityTypes'}).value

        for t in this.teachers
            teachers.push settingTeachers[t].shortName
        title = ""
        # if this.status is 1
        #     title += "(待定)"
        title += "#{teachers.join()}：#{settingActivityTypes[this.type]}"
        if this.title isnt ''
            title += "-" + this.title
        if "note" of this
            if this.note isnt ''
                title += "｜" +this.note
        title
    detail:()->
        this.detail
    duetime:()->
        this.duetime
    type:()->
        settingActivityTypes = Settings.findOne({name:'activityTypes'}).value

        settingActivityTypes[this.type]
