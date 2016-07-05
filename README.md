## Weekly event calendar

Setup:

```
$ bundle install
$ rake db:migrate
```

Run:

```
$ rails s
```

### Implementation notes:

* More test would be needed! Especially on the JavaScript side.
* I normally like to use a service-oriented architecture, but would have been a bit overkill here.
* Normally, I would have either used Turbolinks to reload the calendar section, or
  structured the JS frontend with some kind of framework (I'm partial to Cycle.js these days).

