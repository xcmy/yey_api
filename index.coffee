Koa = require('koa')
bodyParser = require('koa-bodyparser')
Router = require('koa-router')
Config = require('./config')
cors = require('kcors')

app = new Koa()

app.use bodyParser()
#跨域
app.use(cors())

router = new Router()
router.prefix '/api/yee'
api = require('./router')
router.use  api.routes(), api.allowedMethods()
app.use router.routes()

app.use (ctx)->
  console.log('body=>'+JSON.stringify(ctx.request.body,null,2))
#  console.log('query=>'+JSON.stringify(ctx.request.quer,null,2))



require("./lib")
app.listen Config.port,(err)->
  console.log("Server Start #{err or Config.port}")

