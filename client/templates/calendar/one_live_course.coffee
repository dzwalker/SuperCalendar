Template.oneLiveCourse.helpers
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
    courseId:()->
        this._id
    teachers:()->
        teachers = []
        exam = Session.get("_exam")
        settingTeachers = Settings.findOne({name:'teachers'}).value

        for t in this.teachers
            teachers.push {id:t, shortName: settingTeachers[t].shortName}
        teachers
    type:()->
        this.type
    liveNumber:()->
        this.liveDates.indexOf(this.dateString)+1
    title:()->
        exam = Session.get("_exam")
        teachers = []
        # console.log "exam",this.dateString,exam, this.teachers

        dateString = moment(this.dateBegin).format("MM/DD")
        liveIndex = this.liveIndex
        liveTeachersIsEmpty = false
        if "liveTeachers" not of this
            liveTeachersIsEmpty = true
        else if this.liveTeachers is []
            liveTeachersIsEmpty = true
        settingTeachers = Settings.findOne({name:'teachers'}).value

        if liveTeachersIsEmpty
            for t in this.teachers
                teachers.push settingTeachers[t].shortName
        else
            if this.liveTeachers[liveIndex]
                teachers.push settingTeachers[this.liveTeachers[liveIndex]].shortName
            else
                for t in this.teachers
                    teachers.push settingTeachers[t].shortName
        liveNumber = liveIndex + 1
        settingSubjects = Settings.findOne({name:'subjects'}).value

        subject = settingSubjects[this.subject]["shortName"]
        liveTimeString = ""
        liveTimeInt = this.specialLiveTime[liveIndex]
        if "markedLiveTime" of this
            isMarked = this.markedLiveTime[liveIndex]
        else
            isMarked = 0
        cssSpecialLiveTime = ""
        if isMarked
            cssSpecialLiveTime = "cssSpecialLiveTime"
        if not liveTimeInt>0
            liveTimeInt = this.liveTimes
        # else
        #     cssSpecialLiveTime = "cssSpecialLiveTime"
        if liveTimeInt%100 is 0
            liveTimeString = parseInt(liveTimeInt/100) + "点"
        else
            minute = Math.round(liveTimeInt%100)
            if minute > 9
                liveTimeString = parseInt(liveTimeInt/100) + ":" + minute
            else
                liveTimeString = parseInt(liveTimeInt/100) + ":0" + minute
        title = ""
        settingCourseTypes = Settings.findOne({name:'courseTypes'}).value

        title += "#{teachers.join()}：#{settingCourseTypes[this.type]}-#{subject} #{dateString} #{liveTimeString}"
        if "note" of this
            if this.note isnt ''
                title += "｜" +this.note
        title += "-#{liveNumber}"
        {title : title, cssSpecialLiveTime: cssSpecialLiveTime}
