# Setting Path
export ANDROID_BUILD_TOP=$(pwd)

# Install Python2
cd /usr/src
wget https://www.python.org/ftp/python/2.7.18/Python-2.7.18.tgz
tar xzf Python-2.7.18.tgz
cd Python-2.7.18
./configure --prefix=/usr/local/python2.7
make -j16
sudo make install
/usr/local/python2.7/bin/python2.7 -V
echo 'export PATH="/usr/local/python2.7/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
python2.7 -V

sudo ln -sf /usr/local/python2.7/bin/python2.7 /usr/local/bin/python

cd ${ANDROID_BUILD_TOP}