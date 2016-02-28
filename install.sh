ORIG_MIKUTTER_PATH=./tmp_mikutter

mkdir ./tmp_mikutter
git clone git://toshia.dip.jp/mikutter.git ./tmp_mikutter

if [ ! -e $ORIG_MIKUTTER_PATH/mikutter.rb ]; then
    echo "mikutter is not found"
    echo "l1:you redit mikutter path"
    exit 1
fi

cat << EOF

  This is to make nano miku 

  nano miku is twitter agent server


  Purpose : To use completely daemon-mode + web_api.


EOF

####
#### Cloning from mikutter
####
####

mkdir canopy
cp -r $ORIG_MIKUTTER_PATH/* ./canopy/

####
#### touch nanomiku
####
####

#sed -i -e "s/.mikutter/.nanomiku/g" ./canopy/Gemfile

cat <<EOF > nanomiku.sh
#! /bin/bash
ruby canopy/mikutter.rb --confroot=~/.nanomiku --debug --plugin=streaming,daemon_log,humming_ui,wings
EOF

chmod +x nanomiku.sh

cat <<EOF

To launc nanomiku

$./nanomiku.sh


EOF

####
#### Many thank for @Phenomer
####
#### make authrization step and logger

mkdir -p ~/.nanomiku/plugin/daemon_log
cat << EOF > ~/.nanomiku/plugin/daemon_log/daemon_log.rb

#-*- coding: utf-8 -*-

require 'fileutils'
require 'logger'

Plugin.create(:daemon_sample) do
 DAEMON_LOGDIR = File.join(CHIConfig::LOGDIR, 'daemon_sample')
 DAEMON_LOGFILE = File.join(DAEMON_LOGDIR, 'daemon_sample.log')

 FileUtils.mkpath(DAEMON_LOGDIR) unless File.exist? (DAEMON_LOGDIR)
 log = Logger.new(DAEMON_LOGFILE)
 log.info('DAEMON_START')

 onupdate {|svc,msgs|
   msgs.each{|msg|
    log.info(sprintf("[%s:%s] %s", svc.idname, msg.user[:idname], msg[:message].gsub("\n",' ')))
   }
 }
end

EOF

#
# atho 
#
ruby canopy/mikutter.rb --confroot=~/.nanomiku --debug account



mkdir -p ~/.nanomiku/plugin/humming_ui
cat << EOF > ~/.nanomiku/plugin/humming_ui/humming_ui.rb
Plugin.create(:update) do
  onupdate do |s,m|
    notice m
  end
end

EOF



rm -rf ./tmp_mikutter


####
#### Many tanks from mikutter users
####
####   git clone plugins

cd ~/.nanomiku/plugin
git clone https://github.com/nkawahara/wings
