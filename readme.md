
### Routes

```coffeescript
  '/demographics/:zip'
  '/homes/:zip'
  '/trends/:state'
```

* npm install -g supervisor coffeescript
* set the following API keys
  * ZILLOW_ID
  * EIA_KEY
* npm install
* supervisor -x coffee app.coffee