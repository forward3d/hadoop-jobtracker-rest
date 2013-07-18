# Hadoop JobTracker REST interface

This a *very* simple JRuby Sinatra app that talks to the Hadoop MR1 JobTracker
via the Hadoop Java libraries, and exposes a list of jobs in JSON format for
easy consumption.

## Requirements

JRuby
Maven (for jbundler)

## Instructions

First run `bundler` to get `jbundler`:

    bundle install

Now run `jbundler`:

    jbundle install

You need to configure the hostname and port your jobtracker runs on;
edit `config/config.yml` to set this.

Now start the app:

    jbundle exec ./app.rb

## API description

There's only three implemented endpoints:

### Get a list of all jobs the jobtracker knows about

    $ curl -sX GET localhost:4567/jobs/all | python -mjson.tool
    [
      {
          "job_id": "job_201307151313_0003",
          "job_name": "bananas",
          "priority": "NORMAL",
          "start_time": 1374154944193,
          "status": "SUCCEEDED"
      },
      {
          "job_id": "job_201307151313_0004",
          "job_name": "bananas",
          "priority": "NORMAL",
          "start_time": 1374154974307,
          "status": "SUCCEEDED"
      },
      {
          "job_id": "job_201307151313_0005",
          "job_name": "bananas",
          "priority": "NORMAL",
          "start_time": 1374155109432,
          "status": "SUCCEEDED"
      },
      {
          "job_id": "job_201307151313_0006",
          "job_name": "bananas",
          "priority": "NORMAL",
          "start_time": 1374155304857,
          "status": "KILLED"
      }
    ]

### Get a list of all the running jobs

    $ curl -sX GET localhost:4567/jobs/running | python -mjson.tool
    [
      {
          "job_id": "job_201307151313_0007",
          "job_name": "bananas",
          "map_progress": 1.0,
          "priority": "NORMAL",
          "reduce_progress": 0.0
      }
    ] 

`map_progress` and `reduce_progress` will be a number between 0.0 and 1.0
(0% to 100%). It's not always updated particularly quickly.

### Kill a running job

You need to supply the `job_name` of the job you want to kill.

    $ curl -sX DELETE localhost:4567/jobs/bananas | python -mjson.tool
    {"message": "job killed"}
    
If the job can't be found, you'll get a 404, and this output:

    $ curl -sX DELETE localhost:4567/jobs/bananas | python -mjson.tool
    {"error": "job not found"}

After sending a job a kill message, it won't immediately exit, and will continue
to be displayed in the jobtracker for a few seconds while it gets cleaned up.

## Improvements

* be able to kill a job by job ID
* try to figure out some way to get more information about jobs (job conf); the
  API docs are super unhelpful on this front
* get/list counters for the job
* provide some information about available mappers/reducers, cluster stats, etc.

Pull requests welcomed!
