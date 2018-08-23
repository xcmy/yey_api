router = require('koa-router')()
db = require("../lib").db
Config = require("../config")

router.post '/login',(ctx)->

  console.log('登陆接口=>'+JSON.stringify(ctx.request.body,null,2))

  data = await db.model('user')[Config.customMethodPrefix.login](ctx.request.body)
  console.log("++>"+JSON.stringify(data,null,2))
  ctx.body =
    code:200
    data:data
    msg:'OK'


router.post '/:resource/create',(ctx)->
  resource = ctx.params.resource
  console.log('bodu=>'+JSON.stringify(ctx.request.body,null,2))
  data = await db.model(resource)[Config.customMethodPrefix.create](ctx.request.body)
  ctx.body =
    code:200
    data:data
    msg:'OK'


router.get '/:resource/list',(ctx)->
  console.log(ctx.params.resource)
  resource = ctx.params.resource
  data = await db.model(resource)[Config.customMethodPrefix.list]({})
  ctx.body =
    code:200
    data:data
    msg:'OK'

router.get '/:resource/simpleList',(ctx)->
  resource = ctx.params.resource
  data = await db.model(resource)[Config.customMethodPrefix.simpleList]({})
  ctx.body =
    code:200
    data:data.rows
    msg:'OK'


router.get '/:resource/:id',(ctx)->
  resource = ctx.params.resource
  id = ctx.params.id

  data = await db.model(resource)[Config.customMethodPrefix.get]({where:{id:id}})

  ctx.body =
    code:200
    data:data
    msg:'OK'

router.post '/:resource/:id',(ctx)->
  resource = ctx.params.resource
  id = ctx.params.id

  data = await db.model(resource)[Config.customMethodPrefix.get]({where:{id:id}})

  ctx.body =
    code:200
    data:data
    msg:'OK'


router.all '*', (ctx)->
  ctx.body = {code: '1004', msg: '访问不存在'}

module.exports = router
