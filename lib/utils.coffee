root = exports ? this


root.FormOption = {
    teachers:(exam, nameType, teachersSelected)->
        teachers = []
        order = Settings.findOne({name:'configureIndex'}).value.teachers
        settingTeachers = Settings.findOne({name:'teachers'}).value
        if exam is 'all'
            exams = ['toefl','gre','gmat','ielts']
        else
            exams = [exam]
        for e in exams
            for t in order[e]
                if t in teachersSelected
                    teachers.push {t: t , n: settingTeachers[t][nameType], isSelected:true}
                else
                    teachers.push {t: t , n: settingTeachers[t][nameType], isSelected:false}
        return teachers
    activityTypes:()->
        order = Settings.findOne({name:'configureIndex'}).value.activityTypes
        activityTypes = []
        settingActivityTypes = Settings.findOne({name:'activityTypes'}).value
        for type in order
            activityTypes.push {t:type, n: settingActivityTypes[type]}
        return activityTypes
    courseTypes:(exam,courseTypesSelected)->
        courseTypes = []
        order = Settings.findOne({name:'configureIndex'}).value.courseTypes
        settingCourseTypes = Settings.findOne({name:'courseTypes'}).value
        if exam is 'all'
            exams = ['toefl','gre','gmat','ielts']
        else
            exams = [exam]
        for e in exams
            for type in order[e]
                if type in courseTypesSelected
                    courseTypes.push {t:type, n : settingCourseTypes[type],isSelected:true}
                else
                    courseTypes.push {t:type, n : settingCourseTypes[type],isSelected:false}
        return courseTypes
    examSubjects:(exam, subjectsSelected)->
        examSubjects = []
        order = Settings.findOne({name:'configureIndex'}).value.examSubjects
        settingSubjectsTypes = Settings.findOne({name:'subjects'}).value
        if exam is 'all'
            exams = ['toefl','gre','gmat','ielts']
        else
            exams = [exam]
        for e in exams
            for subject in order[e]
                if subject in subjectsSelected
                    examSubjects.push {s: subject, n: settingSubjectsTypes[subject]["name"], isSelected:true}
                else
                    examSubjects.push {s: subject, n: settingSubjectsTypes[subject]["name"], isSelected:false}
        return examSubjects
    liveDays:(exam,courseType)->
        liveDays = []
        settingLiveDays = Settings.findOne({name:'liveDays'}).value

        for liveDaysTypes,liveDaysValues of settingLiveDays[exam][courseType]
            liveDays.push {t: liveDaysTypes, v : liveDaysValues }
        return liveDays
    liveTimes : ()->
        liveTimes = []
        settingLiveTimes = Settings.findOne({name:'configureIndex'}).value.liveTimes
        for liveTime in settingLiveTimes
            liveTimes.push {int:liveTime, str:Utils.getLiveTimeString(liveTime)}
        liveTimes

    roles:()->
        ['user','admin','superAdmin']
    todoCatagories:(exam,catagoriesSelected)->
        todoCatagories = []
        settingTodo = Settings.findOne({name:'todo'}).value
        order = Settings.findOne({name:'configureIndex'}).value.todoCatagories
        for catagory in order[exam]
            if catagory in catagoriesSelected
                todoCatagories.push {t:catagory, n:settingTodo["catagories"][catagory], isSelected:true}
            else
                todoCatagories.push {t:catagory, n:settingTodo["catagories"][catagory], isSelected:false}
        todoCatagories
    pmCatagories:(catagoriesSelected)->
        pmCatagories = []
        settingPm = Settings.findOne({name:'pm'}).value
        for t,n of settingPm.catagories
            if t in catagoriesSelected
                pmCatagories.push {t:t,n:n,isSelected:true}
            else
                pmCatagories.push {t:t,n:n,isSelected:false}
        pmCatagories
}

root.Utils =
    getLiveTimeString:(liveTimeInt)->
        liveTimeString = ""
        if liveTimeInt%100 is 0
            liveTimeString = parseInt(liveTimeInt/100) + "点"
        else
            minute = Math.round(liveTimeInt%100)
            if minute > 9
                liveTimeString = parseInt(liveTimeInt/100) + ":" + minute
            else
                liveTimeString = parseInt(liveTimeInt/100) + ":0" + minute
        liveTimeString


root.DefaultConfigure =
    exams :
        toefl : "T50"
        t6 : "T6"
        gre : "GRE"
        gmat : "GMAT"
        ielts : "IELTS"
        all: "全部科目"
    otherApps:
        todo: "TODO"
        statisticsExam: "排课统计"
        pmCal: "小本本"
        allData: "全部数据操作"

    liveDays :
        toefl : {
            aio : {
                basic:[1,4,6,9,14]
                new:[1,4,7,9,13]
            }
            six : {
                basic:[1,4,7,9,13]
            }

            specialB : {
                basic:[1,2]
            }

            jj : {
                basic:[1,1,2,2]
            }
        }

        gre : {
            aio : {
                basic:[1,4,8,11,15,18]
                friday:[1,5,8,12,15,19]
            }
            q:{
                basic:[1,8,15]
            }
            dailian : {
                basic:[1,2]
            }

            jj : {
                basic:[1,2,3]
            }
        }
        gmat : {
            aio : {
                basic:[1,3,5,8,10,14]
            }

            specialB : {
                basic:[1,2]
            }

            jj : {
                basic:[1]
            }
            q : {
                basic:[1,4,8,10]
            }
            one : {
                basic:[1]
            }
        }
        ielts : {
            aio : {
                basic:[1,4,7,11,14]
            }
            specialB : {
                basic:[1,2]
            }
            jj : {
                basic:[1]
            }
        }

    subjects :
        r:{
            name : "阅读"
            shortName : "读"
        }
        l:{
            name : "听力"
            shortName : "听"
        }
        s:{
            name : "口语"
            shortName : "说"
        }
        w:{
            name : "写作"
            shortName : "写"
        }

        t:{
            name : "填空"
            shortName : "填"
        }
        q:{
            name : "数学"
            shortName : "数"
        }
        rc:{
            name : "阅读"
            shortName : "读"
        }
        sc:{
            name : "语法"
            shortName : "SC"
        }
        cr:{
            name : "逻辑"
            shortName : "CR"
        }
        ir:{
            name : "IR"
            shortName : "IR"
        }
        all : {
            name : "全科"
            shortName : "全"
        }
    teachers :
        # toefl:{
        daiding:{
            name:"待定"
            nickName:"待定"
            shortName:"待定"
        }
        hefanfan: {
            name : "何凡凡"
            nickName: "凡姐"
            shortName: "凡"
        }
        linjianwu: {
            name : "林坚武"
            nickName: "阿武"
            shortName: "武"
        }
        zhouzhou: {
            name : "周舟"
            nickName: "周舟"
            shortName: "舟"
        }
        wangbo: {
            name : "王博"
            nickName: "Bobo"
            shortName: "博"
        }
        feiyang: {
            name : "费扬"
            nickName: "费扬"
            shortName: "费"
        }
        wangyanna: {
            name : "王妍娜"
            nickName: "娜姑姑"
            shortName: "娜"
        }
        zhaochun: {
            name : "赵纯"
            nickName: "赵纯"
            shortName: "纯"
        }
        lvruitong: {
            name : "吕芮同"
            nickName: "叨叨"
            shortName: "叨"
        }
        yinmengcong: {
            name : "尹梦琮"
            nickName: "二胖"
            shortName: "胖"
        }
        luoqiyu: {
            name : "罗其珏"
            nickName: "方丈"
            shortName: "丈"
        }

        # }
        # gre:{
        taorui:{
            name : "陶睿"
            nickName : "陶睿"
            shortName : "睿"
        }
        zhangwei:{
            name : "张巍"
            nickName : "张巍"
            shortName : "巍"
        }
        shibaojing:{
            name : "史保婧"
            nickName : "史保婧"
            shortName : "婧"
        }
        liruiyang:{
            name : "李瑞阳"
            nickName : "李瑞阳"
            shortName : "阳"
        }
        wangtao:{
            name : "王涛"
            nickName : "王涛"
            shortName : "涛"
        }
        limeng:{
            name : "李猛"
            nickName : "李猛"
            shortName : "虎"
        }
        # }
        # gmat:{
        huangheqing:{
            name : "黄河清"
            nickName : "黄河"
            shortName : "河"
        }
        huyong:{
            name : "胡勇"
            nickName : "勇哥"
            shortName : "勇"
        }
        yunshiqing:{
            name : "云诗晴"
            nickName : "云诗晴"
            shortName : "云"
        }
        liyaodong:{
            name : "李耀东"
            nickName : "东哥"
            shortName : "东"
        }
        zhoufan:{
            name : "周帆"
            nickName : "周帆"
            shortName : "帆"
        }
        huhaixiao:{
            name : "胡海潇"
            nickName : "胡海潇"
            shortName : "潇"
        }
        liushuo:{
            name : "刘硕"
            nickName : "硕硕"
            shortName : "硕"
        }
        xiaoshu:{
            name : "小树老师"
            nickName : "小树"
            shortName : "树"
        }
        # }
        # ielts:{
        haoyan:{
            name : "郝妍"
            nickName : "郝妍"
            shortName : "郝"
        }
        liuyanjiang:{
            name : "刘彦江"
            nickName : "刘彦江"
            shortName : "莎"
        }
        zhangyang:{
            name : "张杨"
            nickName : "张杨"
            shortName : "羊"
        }
        tianyibing:{
            name : "田逸冰"
            nickName : "田逸冰"
            shortName : "冰"
        }

    courseTypes :
        aio: 'AiO'
        jj: '点题'
        specialB : '特训'
        six: '6人班'
        one: '1v1'
        dailian : '带练'
        q: "数学"


    activityTypes :
        c : "C类活动"
        o0 :"上午公开课"
        o1 :"下午公开课"
        o2 :"晚上公开课"
        g :"学习小组"
        b :"大型活动"


    configureIndex :
        exams : ["toefl","gre" ,"gmat", "ielts"]
        teachers:
            toefl : ["zhouzhou","feiyang","wangyanna","hefanfan","zhaochun","wangbo","lvruitong","luoqiyu","linjianwu","yinmengcong","daiding"]
            gre : ["taorui","zhangwei","shibaojing","liruiyang","wangtao","limeng","daiding"]
            gmat : ["huangheqing","daiding"]
            ielts : ["haoyan","daiding"]
        activityTypes: ["c","o0","o1","o2","g","b"]
        courseTypes:
            toefl : ["aio","six", "specialB","jj"]
            gmat : ["aio","one",'q',"jj"]
            gre : ["aio","q","dailian","jj"]
            ielts : ["aio","specialB","jj"]
        examSubjects:
            toefl : ['r','l','s','w','all']
            ielts : ['r','l','s','w','all']
            gre : ['t','r','w','q','all']
            gmat : ['sc','cr','rc','ir','q','all']
        liveTimes: [800, 900,1000,1330,1500, 1600,1800,1830, 1900,2000]
        eventTypes :
            personal:['wa','life','work','dev','other','habit','hobby']

    roles: ['user','admin', 'superAdmin']

    eventTypes :
        wa: "娃"
        life: "生活"
        work: "工作"
        dev: "开发"
        habit: "习惯"
        hobby: "爱好"
        other: "其他"

    pm :
        catagories :
            yanfa : "研发"
            zhaosheng : "招生"
            jiaoxue : "教学"
            zhineng : "职能"
        groups : ["研发","学科","运营","推广","品牌","销售","教学"]
        persons : []
        topics : []


Meteor.methods
    updateTodosType:(v)->
        # weekly->5 weeklySummary->6
        if v is 2
            # Todos.update({type:"weekly"}, {$set: {type: 5}},{ multi: true })
            # Todos.update({type:"weeklySummary"}, {$set: {type: 6}},{ multi: true })
            Todos.update({type:"calExamEvent"}, {$set: {type: 7}},{ multi: true })
        else
            # Todos.updateMany({type:"weekly"}, {$set: {type: 5}})
            # Todos.updateMany({type:"weeklySummary"}, {$set: {type: 6}})
            Todos.updateMany({type:"calExamEvent"}, {$set: {type: 7}})
        null

    resetConfigure:()->
        Meteor.call('updateSettings','exams',DefaultConfigure.exams,(error,result)->
            if error
                return alert(error.reason)
            else
                console.log "init exams"
        )
        Meteor.call('updateSettings','liveDays',DefaultConfigure.liveDays,(error,result)->
            if error
                return alert(error.reason)
            else
                console.log "init liveDays"
        )
        Meteor.call('updateSettings','subjects',DefaultConfigure.subjects,(error,result)->
            if error
                return alert(error.reason)
            else
                console.log "init subjects"
        )
        Meteor.call('updateSettings','teachers',DefaultConfigure.teachers,(error,result)->
            if error
                return alert(error.reason)
            else
                console.log "init teachers"
        )
        Meteor.call('updateSettings','courseTypes',DefaultConfigure.courseTypes,(error,result)->
            if error
                return alert(error.reason)
            else
                console.log "init courseTypes"
        )
        Meteor.call('updateSettings','activityTypes',DefaultConfigure.activityTypes,(error,result)->
            if error
                return alert(error.reason)
            else
                console.log "init activityTypes"
        )
        Meteor.call('updateSettings','configureIndex',DefaultConfigure.configureIndex,(error,result)->
            if error
                return alert(error.reason)
            else
                console.log "init configureIndex"
        )
        Meteor.call('updateSettings','eventTypes',DefaultConfigure.eventTypes,(error,result)->
            if error
                return alert(error.reason)
            else
                console.log "init eventTypes"
        )
    sendEmail:(to, from, subject, text)->
        check([to, from, subject, text], [String])
        this.unblock()
        Email.send({
            to: to,
            from: from,
            subject: subject,
            text: text
        })
        null
