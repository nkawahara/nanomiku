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

mkdir -p ./canopy/core
cp $ORIG_MIKUTTER_PATH/Gemfile ./canopy/
cp $ORIG_MIKUTTER_PATH/mikutter.rb ./canopy/
cp $ORIG_MIKUTTER_PATH/core/environment.rb ./canopy/core/
cp $ORIG_MIKUTTER_PATH/core/config.rb ./canopy/core/
cp $ORIG_MIKUTTER_PATH/core/service.rb ./canopy/core/
cp $ORIG_MIKUTTER_PATH/core/user.rb ./canopy/core/
cp $ORIG_MIKUTTER_PATH/core/retriever.rb ./canopy/core/
cp $ORIG_MIKUTTER_PATH/core/skin.rb ./canopy/core/
cp $ORIG_MIKUTTER_PATH/core/userconfig.rb ./canopy/core/
cp $ORIG_MIKUTTER_PATH/core/configloader.rb ./canopy/core/
cp $ORIG_MIKUTTER_PATH/core/serialthread.rb ./canopy/core/
cp $ORIG_MIKUTTER_PATH/core/plugin.rb ./canopy/core/
cp $ORIG_MIKUTTER_PATH/core/event.rb ./canopy/core/
cp $ORIG_MIKUTTER_PATH/core/event_listener.rb ./canopy/core/
cp $ORIG_MIKUTTER_PATH/core/event_filter.rb ./canopy/core/
cp $ORIG_MIKUTTER_PATH/core/message.rb ./canopy/core/
cp $ORIG_MIKUTTER_PATH/core/entity.rb ./canopy/core/
cp $ORIG_MIKUTTER_PATH/core/userlist.rb ./canopy/core/
cp $ORIG_MIKUTTER_PATH/core/service_keeper.rb ./canopy/core/
cp $ORIG_MIKUTTER_PATH/core/miquire_plugin.rb ./canopy/core/
cp $ORIG_MIKUTTER_PATH/core/utils.rb ./canopy/core/
cp $ORIG_MIKUTTER_PATH/core/miquire.rb  ./canopy/core/

cp $ORIG_MIKUTTER_PATH/core/boot -r ./canopy/core
cp $ORIG_MIKUTTER_PATH/core/lib -r ./canopy/core
cp $ORIG_MIKUTTER_PATH/core/miku -r ./canopy/core
cp $ORIG_MIKUTTER_PATH/core/plugin -r ./canopy/core
rm -r ./canopy/core/plugin/gtk

####
#### touch nanomiku
####
####

sed -i -e "s/.mikutter/.nanomiku/g" ./canopy/Gemfile

cat <<EOF > nanomiku.sh
#! /bin/bash
ruby canopy/mikutter.rb --confroot=~/.nanomiku --debug
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

mkdir -p ~/.nanomiku/plugin/daemon_auth_log
cat << EOF > ~/.nanomiku/plugin/daemon_auth_log/daemon_auth_log.rb

#-*- coding: utf-8 -*-

require 'fileutils'
require 'logger'

Plugin.create(:daemon_sample) do
 DAEMON_LOGDIR = File.join(CHIConfig::LOGDIR, 'daemon_sample')
 DAEMON_LOGFILE = File.join(DAEMON_LOGDIR, 'daemon_sample.log')

 def request_token()
  twitter = MikuTwitter.new
  twitter.consumer_key =  ""
  twitter.consumer_secret =  ""
  req = twitter.request_oauth_token
  puts req.authorize_url
  print "code: "
  code = STDIN.gets.chomp
  access_token = req.get_access_token(oauth_token: req.token, oauth_verifier: code)
  Service.add_service(access_token.token, access_token.secret)
 end


 request_token if Service.services.empty?

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

emacs -nw  ~/.nanomiku/plugin/daemon_auth_log/daemon_auth_log.rb
rm -rf ./tmp_mikutter


####
#### Many tanks from mikutter users
####
####   git clone plugins

cd ~/.nanomiku/plugin
git clone https://github.com/syusui-s/mikutterm
git clone https://github.com/nkawahara/wings
