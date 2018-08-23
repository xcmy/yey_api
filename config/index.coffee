module.exports =
  port:3002
  init:true
  dbUrl:'postgres://xcmy:liuyang123@localhost:5432/yee'
  customMethodPrefix:
    get:'__get'
    list:'__list'
    simpleList:'__simpleList'
    create:'__create'
    update:'__update'
    delete:'__delete'
    login:'__login'
    logout:'__logout'
