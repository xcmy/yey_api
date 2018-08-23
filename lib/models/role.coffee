Config = require("../../config")
module.exports = (sequelize, DataTypes)->
  model = sequelize.define("role",
    {
      name:
        type: DataTypes.STRING
        comment: "角色名称"
      permission:
        type: DataTypes.JSON
        comment: "权限"
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
      tableName:"role"
      comment:"角色管理"
      validate:
        checkParams: ()->
          throw new Error("角色不能为空") if not this.name
    }
  )

  #自定义方法
  model[Config.customMethodPrefix.list] = (params)->
    params.include = [
      {model: sequelize.model('user'), as: 'created_by', attributes:['id','account'],paranoid:false}
    ]
    @.findAndCountAll(params)

  model[Config.customMethodPrefix.simpleList] = (params)->
    params.attributes = ['id','name']
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

