Config = require("../../config")

module.exports = (sequelize, DataTypes)->
  model = sequelize.define("user",
    {
      nick_name:
        type: DataTypes.STRING
        comment: "昵称"
      account:
        type: DataTypes.STRING
        comment: "账号"
        unique:true
      password:
        type: DataTypes.STRING
        comment: "密码"
      headImg:
        type: DataTypes.STRING
        comment: "头像"
      role_id:
        type: DataTypes.INTEGER
        comment:"角色"
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
      tableName:"user"
      comment:"用户管理"
      validate:
        checkParams: ()->
          throw new Error("账号密码不能为空") if not this.account or not this.password
          throw new Error("权限不能为空") if not this.role_id
    }
  )


  #自定义方法
  model[Config.customMethodPrefix.login] = (params)->
    @.findOne({
      where:{account: params.account, password: params.password,status:"ENABLED"},
    })

  model[Config.customMethodPrefix.list] = (params)->
    params.include = [
      {model: sequelize.model('user'), as: 'created_by', attributes:['id','account'],paranoid:false},
      {model: sequelize.model('role'), as: 'role', attributes:['id','name'],paranoid:false}
    ]
    @.findAndCountAll(params)

  model[Config.customMethodPrefix.get] = (params)->
    params.include = [
      {model: sequelize.model('user'), as: 'created_by', attributes:['id','account'],paranoid:false},
      {model: sequelize.model('role'), as: 'role', attributes:['id','name'],paranoid:false}
    ]
    @.findOne(params)

  model[Config.customMethodPrefix.create] = (data)->
    instance = await @.create(data)
    return instance

  model[Config.customMethodPrefix.update] = (id, data)->
    instance = await @.findById(id)
    if data.password
      throw new Error('参数不完整') if not data.old_password
      throw new Error('原密码不正确') if data.old_password != instance.password
    instance.update(data)

  model[Config.customMethodPrefix.delete] = (id)->
    instance = await @.findById(id)
    instance.destroy()

  return model

