Router.configure
    layoutTemplate: 'layout'
    loadingTemplate: 'loading'
    notFoundTemplate: 'notFound'
    waitOn : ()->
        Meteor.subscribe('settings')
        # Meteor.subscribe('events')

        Meteor.subscribe('users')
        if Roles.userIsInRole(Meteor.userId(),'admin', 'pmCal')
            Meteor.subscribe('projectsList','allData')
            Meteor.subscribe('projectCheckpoints','allData')
            Meteor.subscribe('projectObjects','allData')
        isTodoAdmin = false
        subscribeMode = null
        if Roles.userIsInRole(Meteor.userId(),'admin', 'todo')
            isTodoAdmin = true
        if Roles.userIsInRole(Meteor.userId(),'admin', 'allData')
            subscribeMode = 'allData'
        Meteor.subscribe('todosWeekly',subscribeMode, isTodoAdmin)



Router.route('/:_exam/newactivity',{name:'activityNew', data:()->this.params})
Router.route('/:_exam/newcourse',{name:'courseNew', data:()->this.params})
Router.route('/:_exam/newevent',{name:'todoEventNew', data:()->this.params})
Router.route('/pm/newproject',{name:'pmNewProject', data:()->this.params})
Router.route('/todo/create',{name:'todoCreate', data:()->this.params})


Router.route('/setting/exams',{name:'settingExam'})
Router.route('/setting/subject',{name:'settingSubject'})
Router.route('/setting/order',{name:'settingOrder'})
Router.route('/setting/course',{name:'settingCourse'})
Router.route('/setting/activity',{name:'settingActivity'})
Router.route('/setting/teacher',{name:'settingTeacher'})
Router.route('/setting/todo',{name:'settingTodo'})
Router.route('/setting/pm',{name:'settingPm'})
Router.route('/setting/users',{name:'usersList'})
Router.route('/setting/more',{name:'settingMore'})


Router.route('/cal/:_exam',
    {
        name:'superCalendar'

        data:()->
            Session.set("_exam", this.params._exam)
            data = this.params
            _.extend(data, {app:'superCalendar'})
            data
    }
)

Router.route('/examCal/:_exam',
    {
        name:'examCal'
        waitOn:()->
            if Roles.userIsInRole(Meteor.userId(),'admin', 'allData')
                return [
                    Meteor.subscribe('courses','allData',this.params._exam)
                    Meteor.subscribe('activities','allData',this.params._exam)
                    Meteor.subscribe('todoEvents','allData',this.params._exam)
                ]
            else
                return [
                    Meteor.subscribe('courses',null,this.params._exam)
                    Meteor.subscribe('activities',null,this.params._exam)
                    Meteor.subscribe('todoEvents',null,this.params._exam)
                ]

        data:()->
            Session.set("_exam", this.params._exam)
            data = this.params
            _.extend(data, {app:'examCal'})
            data
    }
)
Router.route('/examStatistic/:_exam',
    {
        waitOn:()->
            Meteor.subscribe('courses','allData',this.params._exam)
        name:'statisticsExam'
        data:()->
            Session.set("_exam", this.params._exam)
            data = this.params
            _.extend(data, {app:'statisticsExam'})
            data
    }
)


Router.route('/todo/list',
    {
        name:'todoList'
        data:()->
            this.params
    }
)
Router.route('/todo/mySettings',
    {
        name:'todoMySettings'
        data:()->
            this.params
    }
)

Router.route('/todo/myweeklytodo',
    {
        name:'todoWeekly'


        data:()->
            # Session.set("todoViewMode", this.params.vm)
            data = this.params
            _.extend(data, {app:'todoWeekly'})
            data
    }
)

Router.route('/pm/cal',
    {
        name:'pmCal'

        data:()->
            # Session.set("todoViewMode", this.params.vm)
            data = this.params
            _.extend(data, {app:'pmCal'})
            data
    }
)

Router.route('/pm/calMo',
    {
        name:'pmCalMobile'

        data:()->
            # Session.set("todoViewMode", this.params.vm)
            data = this.params
            _.extend(data, {app:'pmCalMobile'})
            data
    }
)

Router.route('/pm/pool',
    {
        name:'pmPool'

        data:()->
            # Session.set("todoViewMode", this.params.vm)
            data = this.params
            _.extend(data, {app:'pmPool'})
            data
    }
)

Router.route('/todo/myCal',
    {
        name:'todoMyCal'
        data:()->
            # Session.set("todoViewMode", this.params.vm)
            data = this.params
            _.extend(data, {app:'todoMyCal'})
            data
    }
)

Router.route('/personalCalendar/p',
    {
        name:'personalCalendar'
        data:()->
            console.log "personalCalendar"
            # Session.set("_exam", this.params._exam)
            this.params
    }
)



Router.route(
    '/todo/:_exam/:_id'
    {
        waitOn:()->
            Meteor.subscribe('todoItem',this.params._id)
        name:'todoItem'
        data : ()->
            Session.set("_exam", this.params._exam)
            thisItem = Todos.findOne({_id:this.params._id})
            data = this.params
            _.extend(data,{thisItem:thisItem,app:'superCalendar'})
            data
    }
)
Router.route(
    '/pm/project/:_id'
    {
        waitOn:()->
            Meteor.subscribe('projectItem',this.params._id)

        name:'projectItem'
        data : ()->
            thisItem = Projects.findOne({_id:this.params._id})
            data = this.params
            _.extend(data,{thisItem:thisItem,app:'projectItem'})
            data
    }
)

Router.route(
    '/course/:_exam/:_id'
    {
        waitOn:()->
            Meteor.subscribe('courseItem',this.params._id)
        name:'courseItem'
        data : ()->
            Session.set("_exam", this.params._exam)
            thisCourse = Courses.findOne({_id:this.params._id})
            data = this.params
            _.extend(data,{thisCourse:thisCourse,app:'superCalendar'})
            data
            # Courses.findOne(this.params._id)
    }
)
Router.route(
    '/activity/:_exam/:_id'
    {
        waitOn:()->
            Meteor.subscribe('activityItem',this.params._id)
        name:'activityItem'

        data : ()->
            Session.set("_exam", this.params._exam)

            this.params
            # Courses.findOne(this.params._id)
    }
)
Router.route(
    '/events/:_id'
    {
        name:'eventPage'
        data : ()->
            Events.findOne(this.params._id)
    }
)

Router.route(
    '/search/:_tag'
    {
        name:'eventsSearch'
        data : ()->
            regSearch = new RegExp this.params._tag
            Events.find({title: regSearch})
    }

)

Router.route('/submit',{name:'eventSubmit'})
Router.route('/',{name:'home'})

requireLogin = ()->
    if not Meteor.user()
        if Meteor.loggingIn()
            this.render(this.loadingTemplate)
        else
            this.render('accessDenied')
    else
        this.next()
    null


requireAdmin = ()->
    if not Meteor.user()
        if Meteor.loggingIn()
            this.render(this.loadingTemplate)
        else
            this.render('accessDenied')
    else
        if Roles.userIsInRole(Meteor.user(),"admin",'adminGroup')
            this.next()
        else
            this.render('accessDenied')
    null

requireSuperAdmin = ()->
    if not Meteor.user()
        if Meteor.loggingIn()
            this.render(this.loadingTemplate)
        else
            this.render('accessDenied')
    else
        if Roles.userIsInRole(Meteor.user(),"superAdmin",'adminGroup')
            this.next()
        else
            this.render('accessDenied')
    null

Router.onBeforeAction('dataNotFound', {only: 'eventPage'})
Router.onBeforeAction(requireLogin, {only: ['todoWeekly']})
Router.onBeforeAction(requireSuperAdmin, {only: 'usersList'})
Router.onBeforeAction(
    requireAdmin,
    {only:['activityNew','courseNew','examStatistic','pmCal','projectItem']}
)
