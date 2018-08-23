Config = require("../../config")
module.exports = (sequelize, DataTypes)->
  model = sequelize.define("teacher",
    {
      real_name:
        type: DataTypes.STRING,
        comment:"真实姓名"
      department:
        type:DataTypes.STRING
        comment:"部门"
      employee_id:
        type:DataTypes.STRING
        comment:"工号"
      gender:
        type: DataTypes.ENUM
        values: ['男', '女']
        comment: "性别"
        defaultValue: '男'
      email:
        type: DataTypes.STRING,
        comment:"邮箱"
      phone:
        type: DataTypes.STRING,
        comment:"联系方式"
      head_img:
        type: DataTypes.STRING,
        comment:"头像",
      id_no:
        type: DataTypes.STRING,
        comment:"身份证号"
      birthday:
        type:DataTypes.DATE
        comment:"出生年月"
      address:
        type:DataTypes.STRING
        comment:"家庭住址"
      political_status:
        type:DataTypes.STRING
        comment:"政治面貌"
      join_date:
        type:DataTypes.DATE
        comment:"入党时间"
      educational:
        type:DataTypes.STRING
        comment:"学历"
      graduated:
        type:DataTypes.DATE
        comment:"毕业时间"
      graduated_school:
        type:DataTypes.STRING
        comment:"毕业院校"
      profession:
        type:DataTypes.STRING
        comment:"专业"
      remarks:
        type:DataTypes.TEXT
        comment:"备注"
      user_id:
        type: DataTypes.INTEGER
        comment:"创建人"
      status:
        type: DataTypes.ENUM
        values: ["ENABLED","DISABLED","ARCHIVED","DELETED"]
        comment: "状态"
        defaultValue: 'ENABLED'
    },
    {
      timestamps: true
      paranoid: true
      underscored: true
      freezeTableName:true
      tableName:"teacher"
      comment:"老师管理"
      validate:
        checkParams: ()->
          throw new Error("姓名不能为空") if not this.real_name
    }
  )

  #自定义方法
  model[Config.customMethodPrefix.list] = (params)->
    params.include = [
      {model: sequelize.model('user'), as: 'created_by', attributes:['id','account'],paranoid:false}
    ]
    @.findAndCountAll(params)

  model[Config.customMethodPrefix.get] = (params)->
    params.include = [
      {model: sequelize.model('user'), as: 'created_by', attributes:['id','account'],paranoid:false}
    ]
    @.findOne(params)

  model[Config.customMethodPrefix.create] = (data)->
    instance = await @.create(data)
    return instance

  model[Config.customMethodPrefix.update] = (id, data)->
    instance = await @.findById(id)
    instance.update(data)

  model[Config.customMethodPrefix.delete] = (id)->
    instance = await @.findById(id)
    instance.destroy()

  return model

