Config = require("../../config")
module.exports = (sequelize, DataTypes)->
  model = sequelize.define("announcement",
    {
      title:
        type: DataTypes.STRING
        comment: "标题"
      subtitle:
        type: DataTypes.STRING
        comment: "副标题"
      content:
        type: DataTypes.TEXT
        comment: "内容"
      promulgator:
        type: DataTypes.STRING
        comment: "发布单位"
      publish_time:
        type: DataTypes.DATE
        comment: "发布时间"
      remarks:
        type: DataTypes.STRING
        comment: "备注"
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
      tableName:"announcement"
      comment:"公告通知管理"
      validate:
        checkParams: ()->
          throw new Error("名称不能为空") if not this.name
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

