
### Routes

```coffeescript
  '/demographics/:zip'
  '/details/:zpid'
  '/homes/:zip'
  '/trends/:state'
  '/walk_score/:address/:lat/:lon'
  POST => '/score'
```

### Home Energy Score data format
```coffeescript
$.post("http://localhost:3333/score", {zip: '02906', details: [{
  inputTableName: 'whole_house_input',
  inputColumnName: 'floorArea',
  s_value: '1800'
}]}, (d) -> console.log(d) })
```
### Dev

* npm install -g supervisor coffeescript
* set the following API keys
  * ZILLOW_ID
  * EIA_KEY
  * HES_ID
  * WALK_SCORE_KEY
* npm install
* supervisor -x coffee app.coffee
