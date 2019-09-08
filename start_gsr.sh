#!/usr/bin/env bash

sudo apt-get -y install git
sudo apt-get -y install cmake
sudo apt-get -y install unzip

git clone https://github.com/ahmorsi/darknet.git

cd darknet
cmake . && make

cd gsr/

wget https://sid.erda.dk/public/archives/ff17dc924eba88d5d01a807357d6614c/TrainIJCNN2013.zip .
wget https://sid.erda.dk/public/archives/ff17dc924eba88d5d01a807357d6614c/TestIJCNN2013.zip .
wget https://sid.erda.dk/public/archives/ff17dc924eba88d5d01a807357d6614c/gt.txt
unzip TrainIJCNN2013.zip
unzip TestIJCNN2013
mv gt.txt TestIJCNN2013/
python prepare_data_yolo.py

mkdir -p backup
cd ..
wget https://pjreddie.com/media/files/darknet53.conv.74 .

./darknet detector train gsr/gsr.data gsr/yolov3_gsr.cfg darknet53.conv.74 -dont_show -mjpeg_port 8090 -map
aws s3 sync /local/dir s3://ai-projects-ahmorsi/yolo-gsr/

shutdown -h now
