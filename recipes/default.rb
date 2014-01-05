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

execute "Install Strider NPM Package" do
  command "npm install"
  cwd "/opt/strider"
  creates "/opt/strider/node_modules"
  action :run
end
