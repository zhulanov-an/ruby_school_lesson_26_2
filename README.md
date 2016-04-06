# RubySchool, Lesson 26

### Useful commands

```
Output from db as hash
db = SQLite3::Database.new 'barbershop.sqlite'
db.results_as_hash = true
```