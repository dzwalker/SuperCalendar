Template.oneCourse.helpers
    queryString:()->
        query = {}
        _.extend(query,Template.parentData(5).data.query)
        $.param(query)
    isVisable:()->
        exam = Session.get("_exam")

        if this.status is 0
            return true
        else
            if Roles.userIsInRole(Meteor.user(),'admin', exam)
                return true
            else
                return false
        null
    cssStyle:()->
        temp = ""
        if this.status is 1
            temp = "temp"
        temp
    courseQuery:()->
        exam = Session.get("_exam")
        {_id:this._id, _exam:exam}
    subject:()->
        this.subject
    type:()->
        this.type
    title:()->
        exam = Session.get("_exam")
        teachers = []
        settingTeachers = Settings.findOne({name:'teachers'}).value

        for t in this.teachers
            teachers.push settingTeachers[t].shortName
        # dateString = moment(this.dateBegin).format("MM/DD")
        settingSubjects = Settings.findOne({name:'subjects'}).value

        subject = settingSubjects[this.subject]["shortName"]
        minute = Math.round(this.liveTimes%100)
        liveTimes = ""
        if this.liveTimes%100 is 0
            liveTimes = parseInt(this.liveTimes/100) + "点"
        else
            if minute > 9
                liveTimes = parseInt(this.liveTimes/100) + ":" + minute
            else
                liveTimes = parseInt(this.liveTimes/100) + ":0" + minute
        title = ""
        # if this.status is 1
        #     title += "(待定)"
        settingCourseTypes = Settings.findOne({name:'courseTypes'}).value

        title += "#{teachers.join()}：#{settingCourseTypes[this.type]}-#{subject} #{liveTimes}"
        if "note" of this
            if this.note isnt ''
                title += "｜" +this.note
        title
