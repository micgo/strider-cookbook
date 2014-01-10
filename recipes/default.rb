#
# Cookbook Name:: strider-cd
# Recipe:: default
#
# Copyright (C) 2013 Michael Goetz
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
include_recipe "nodejs::npm"
include_recipe "mongodb"

git "/opt/strider" do
  repository "git://github.com/Strider-CD/strider.git"
  reference "master"
  action :sync
end

ENV['DB_URI'] = node['strider-cd']['db-uri']
ENV['SERVER_NAME'] = node['strider-cd']['server-name']
ENV['PLUGIN_GITHUB_APP_ID'] = node['strider-cd']['plugin-github-app-id']
ENV['PLUGIN_GITHUB_APP_SECRET'] = node['strider-cd']['plugin-github-app-secret']

if node['strider-cd']['smtp-host']
  ENV['SMTP_HOST'] = node['strider-cd']['smtp-host']
  ENV['SMTP_PORT'] = node['strider-cd']['smtp-port']
  ENV['SMTP_USER'] = node['strider-cd']['smtp-user']
  ENV['SMTP_PASS'] = node['strider-cd']['smtp-pass']
  ENV['SMTP_FROM'] = node['strider-cd']['smtp-from']
else
  log 'SMTP not configured. Skipping setup'
end

execute "Install Strider NPM Package" do
  command "npm install"
  cwd "/opt/strider"
  creates "/opt/strider/node_modules"
  action :run
end

execute "Install Forever Package" do
  command "npm install forever -g"
  creates "/usr/local/bin/forever"
  action :run
end

execute "Add initial admin user" do
  command "bin/strider addUser -l #{node['strider-cd']['admin-email']} -p #{node['strider-cd']['admin-password']} -a true"
  cwd "/opt/strider"
  only_if "mongo strider-foss --eval 'printjson(db.users.count())' --quiet | grep 0"
end

execute "Start Strider with Forever" do
  command "forever start --pidFile /var/run/strider.pid -l /var/log/forever.log -o /var/log/strider-out.log -e /var/log/strider-error.log /opt/strider/bin/strider"
  cwd "/opt/strider"
  creates "/var/run/strider.pid"
end