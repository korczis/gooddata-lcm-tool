# encoding: utf-8

require 'gooddata'

require_relative '../config'

GoodData.with_connection($CONFIG[:username], $CONFIG[:password], :server => $CONFIG[:server], :verify_ssl => false) do |client|
  timestamp = DateTime.now.strftime('%Y%m%d%H%M%S')

  blueprint = GoodData::Model::ProjectBlueprint.build("LCM Master project - #{timestamp}") do |p|
    p.add_date_dimension('committed_on')
    p.add_dataset('devs') do |d|
      d.add_anchor('attr.dev')
      d.add_label('label.dev_id', :reference => 'attr.dev')
      d.add_label('label.dev_email', :reference => 'attr.dev')
    end
    p.add_dataset('commits') do |d|
      d.add_anchor('attr.commits_id')
      d.add_fact('fact.lines_changed')
      d.add_date('committed_on')
      d.add_reference('devs')
    end
  end

  project = GoodData::Project.create_from_blueprint(blueprint, auth_token: $CONFIG[:token])
  puts "Created project #{project.pid}"

  # Load data
  commits_data = [
    ['fact.lines_changed', 'committed_on', 'devs'],
    [1, '01/01/2014', 1],
    [3, '01/02/2014', 2],
    [5, '05/02/2014', 3]]
  project.upload(commits_data, blueprint, 'commits')

  devs_data = [
    ['label.dev_id', 'label.dev_email'],
    [1, 'tomas@gooddata.com'],
    [2, 'petr@gooddata.com'],
    [3, 'jirka@gooddata.com']]
  project.upload(devs_data, blueprint, 'devs')

  # create a metric
  metric = project.facts('fact.lines_changed').create_metric
  metric.save
  report = project.create_report(title: 'Awesome_report', top: [metric], left: ['label.dev_email'])
  report.save
  ['tomas.korcak@gooddata.com'].each do |email|
    project.invite(email, 'admin', "Guys checkout this report #{report.browser_uri}")
  end

  # Delete project
  # project.delete
end
