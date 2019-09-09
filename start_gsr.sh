#!/usr/bin/env bash

sudo su
sudo apt-get -y install git
sudo apt-get -y install cmake
sudo apt-get -y install unzip

export PATH=$PATH:/usr/local/cuda/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/lib:/usr/local/lib
export CPLUS_INCLUDE_PATH=/usr/local/cuda/include

git clone https://github.com/opencv/opencv.git
cd opencv/

cmake -D CMAKE_BUILD_TYPE=RELEASE ..
make
sudo make install

cd ..

cd darknet
cmake . && make

cd gsr/

wget https://sid.erda.dk/public/archives/ff17dc924eba88d5d01a807357d6614c/TrainIJCNN2013.zip .
wget https://sid.erda.dk/public/archives/ff17dc924eba88d5d01a807357d6614c/TestIJCNN2013.zip .
wget https://sid.erda.dk/public/archives/ff17dc924eba88d5d01a807357d6614c/gt.txt .
unzip -q TrainIJCNN2013.zip -d ./TrainIJCNN2013/
unzip -q TestIJCNN2013.zip -d ./TestIJCNN2013/
mv gt.txt ./TestIJCNN2013/

mkdir -p backup
cd ..
python gsr/prepare_data_yolo.py
wget https://pjreddie.com/media/files/darknet53.conv.74 .

./darknet detector train gsr/gsr.data gsr/yolov3_gsr.cfg darknet53.conv.74 -dont_show -mjpeg_port 8090 -map
aws s3 sync ./gsr/backup s3://ai-projects-ahmorsi/yolo-gsr/

shutdown -h now
