Template.statisticsExamTable.helpers
    months:()->
        months = []
        for i in [0...this.dateByMonth.length-1]
            date = this.dateByMonth[i]
            months.push {dateString:date.format("YYYY/MM")}
        months
    results:()->
        settingTeachers = Settings.findOne({name:'teachers'}).value
        settingSubjects = Settings.findOne({name:'subjects'}).value

        resultByTeachers = []
        resultSumSubject = []
        resultSumAll = []
        months = this.dateByMonth
        queryExam = this.queryExam
        courseTypes = this.courseTypes
        countSubject = {}
        countMonths=[]
        for n in [0...months.length-1]
            countMonths.push 0
        for subject in this.subjects
            countSubject[subject] = []
            for n in [0...months.length-1]
                countSubject[subject].push 0
            # console.log subject
            for teacher in this.teachers
                # console.log teacher
                oneLine = []
                oneLine.push {string:settingSubjects[subject]['name']+"："+settingTeachers[teacher]['name']}
                countTeacher = 0
                showSubjectTeacher = false
                for i in [0...months.length-1]
                    queryCourse =
                        dateBegin:
                            $gte: months[i].toDate()
                            $lt: months[i+1].toDate()
                        teachers: teacher
                        subject: subject
                        type : courseTypes
                        exam : queryExam
                    c = Courses.find(queryCourse).count()
                    # console.log c
                    oneLine.push {string:c}
                    countTeacher += c
                    # countSubject[subject][i] ?= 0
                    countSubject[subject][i] += c
                    if c > 0
                        showSubjectTeacher = true
                        countMonths[i]+=c
                oneLine.push {string:countTeacher}
                if showSubjectTeacher
                    resultByTeachers.push {oneLine:oneLine}

        for subject in this.subjects
            oneLine = []
            oneLine.push {string:settingSubjects[subject]['name']+"汇总"}
            countSubjectTotal = 0
            for countBySubjectMonth in countSubject[subject]
                oneLine.push {string:countBySubjectMonth}
                countSubjectTotal += countBySubjectMonth
            oneLine.push {string:countSubjectTotal}
            resultSumSubject.push {oneLine:oneLine}
        lineSum = []
        lineSum.push {string:"全部汇总"}
        countAllTotal = 0
        for countMonth in countMonths
            lineSum.push {string:countMonth}
            countAllTotal += countMonth
        lineSum.push {string:countAllTotal}
        # resultByTeachers.push {oneLine:lineSum}
        {resultByTeachers:resultByTeachers,resultSumSubject:resultSumSubject,lineSum:lineSum}
