#!/usr/bin/env ruby

require 'jbundler'
require 'java'
require 'json'
require 'multi_json'
require 'sinatra'
require 'sinatra/config_file'
require 'sinatra/json'
require 'sinatra/reloader'

# Import Java classes to local namespace
java_import org.apache.hadoop.conf.Configuration
java_import org.apache.hadoop.mapred.JobClient
java_import org.apache.hadoop.mapred.JobStatus
java_import org.apache.hadoop.mapred.JobConf

config_file "#{File.expand_path("../config/config.yml", __FILE__)}"

configuration = Configuration.new
configuration.set("mapred.job.tracker", settings.jobtracker)

client = JobClient.new(JobConf.new(configuration))

before do
  content_type 'application/json'
end

get '/jobs/running' do
  jobs = client.jobsToComplete.map do |job_status|
    running_job = client.getJob(job_status.jobId)
    {
      :job_id           => job_status.jobId,
      :job_name         => running_job.getJobName,
      :map_progress     => running_job.mapProgress,
      :reduce_progress  => running_job.reduceProgress,
      :priority         => job_status.getJobPriority,
    }
  end.to_json
end

get '/jobs/all' do
  jobs = client.getAllJobs.map do |job_status|
    running_job = client.getJob(job_status.jobId) 
    {
      :job_id           => job_status.jobId,
      :job_name         => running_job.getJobName,
      :status           => JobStatus.getJobRunState(job_status.getRunState),
      :start_time       => job_status.getStartTime,
      :priority         => job_status.getJobPriority
    }
  end.to_json
end

delete '/jobs/:id' do
  target_job = client.jobsToComplete.detect do |job_status|
    running_job = client.getJob(job_status.jobId)
    running_job.getJobName == params[:id]
  end
  if target_job.nil?
    status 404
    {:error => "job not found"}.to_json
  else
    running_job = client.getJob(target_job.jobId)
    running_job.killJob
    status 200
    {:message => "job killed"}.to_json
  end
end
