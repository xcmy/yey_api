Sequelize = require('sequelize');
Config = require("../config")
fs = require("fs")
path = require("path")

#sequelize = new Sequelize(Config.dbUrl,{logging:false})
#postgres://:@localhost:5432/yee
sequelize = new Sequelize('yee','xcmy','liuyang123',{
  dialect:'postgres',
  operatorsAliases: false,
  logging:true,
  pool: {
    max: 5,
    min: 0,
    acquire: 30000,
    idle: 10000
  },
})


sequelize.authenticate()
  .then ()->
    console.log('db connected success')
    #批量导入
#    await fs.readdir path.join(__dirname,'/models'),(err,files)->
#      for filename in files
#        sequelize.import("./models/#{filename}")

    #model 导入
    User = await sequelize.import("./models/user")
    Role = await sequelize.import("./models/role")
    Student = await sequelize.import("./models/student")
    Teacher = await sequelize.import("./models/teacher")
    Course = await sequelize.import("./models/course")
    Comment = await sequelize.import("./models/comment")
    Class = await sequelize.import("./models/class")
    Announcement = await sequelize.import("./models/announcement")


    #user
    User.belongsTo User, {foreignKey: 'user_id', as: 'created_by',constraints:false}
    User.belongsTo Role, {foreignKey: 'role_id', as: 'role',constraints:false}

    #role
    Role.belongsTo User, {foreignKey: 'user_id', as: 'created_by',constraints:false}

    #student
    Student.belongsTo User, {foreignKey: 'user_id', as: 'created_by',constraints:false}
    Student.belongsTo Class, {foreignKey: 'class_id', as: '_class',constraints:false}

    #teacher
    Teacher.belongsTo User, {foreignKey: 'user_id', as: 'created_by',constraints:false}

    #course
    Course.belongsTo User, {foreignKey: 'user_id', as: 'created_by',constraints:false}

    #class
    Class.belongsTo User, {foreignKey: 'user_id', as: 'created_by',constraints:false}

    #comment
    Comment.belongsTo User, {foreignKey: 'user_id', as: 'created_by',constraints:false}

    #announcement
    Announcement.belongsTo User, {foreignKey: 'user_id', as: 'created_by',constraints:false}


    if Config.init
          await sequelize.sync({force:true})
          dataInit(sequelize)

  .catch (err)->
    console.log('db connected fail =>'+err)




dataInit = (seq)->
  await seq.model('user').create(
    {
      nick_name:'管理员',
      account:'admin',
      headImg:'http://img.jrzj.com/uploadfile/2017/0518/20170518101106552.jpg'
      password:'123456',
      role_id:1,
      status:'ENABLED',
    }
  )
  await seq.model('role').create(
    {
      name:'管理员',
      user_id:1,
      status:'ENABLED',
    }
  )




exports.db = db = sequelize
