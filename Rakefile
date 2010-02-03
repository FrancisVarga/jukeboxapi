require 'sprout'
require 'pp'
# Optionally load gems from a server other than rubyforge:
# set_sources 'http://gems.projectsprouts.org'
sprout 'as3'

############################################
# Configure your Project Model
project_model :model do |m|
  m.project_name            = 'JukeboxAPIExample'
  m.language                = 'mxml'
  m.background_color        = '#FFFFFF'
  m.width                   = 970
  m.height                  = 550
  m.compiler_gem_name     = 'sprout-flex4sdk-tool'
  m.compiler_gem_version  = '>= 4.0.0'
  # m.src_dir               = 'src'
  m.lib_dir               = 'libs'
  m.swc_dir               = 'libs'
  # m.bin_dir               = 'bin'
  # m.test_dir              = 'test'
  # m.doc_dir               = 'doc'
  # m.asset_dir             = 'assets'
  m.libraries             << :corelib
end

desc 'Compile and debug the application'
compile :debug => :model do |m|
  m.debug = true
  m.source_path << "libs/as3HttpClient/src/"
  m.include_libraries << "libs/as3HttpClient/lib/as3crypto-1_3_patched.swc"
end

desc 'Compile run the test harness'
unit :test

desc 'Compile the optimized deployment'
deploy :deploy

desc 'Create documentation'
document :doc

desc "Debug the App"
fdb :app => :model do |t|
  t.file = "bin/JukeboxAPIExample-debug.swf"
  t.run
  #t.break = 'SomeFile:23'
  #t.continue
end

desc 'Compile a SWC file'
swc :swc do |m|
  m.include_classes << "cc.varga.api.jukebox.JukeboxAPI"
end

desc 'Compile and run the test harness for Ci'
ci :cruise

# set up the default rake task
task :default => :debug

desc "to Shell"
task :shell do
  tasks = Rake::Task.tasks.map do |t|
    begin
      t.to_shell
    rescue
    end
  end.compact

  pp tasks
end
#mxmlc -debug=true -default-background-color=#FFFFFF -default-frame-rate=24 -default-size 970 550 -library-path+=libs/corelib.swc -source-path+=libs/as3HttpClient/src -output=bin/JukeboxAPIExample-debug.swf -source-path+=src -verbose-stacktraces=true -warnings=true src/JukeboxAPIExample.mxml
