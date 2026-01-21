# Install Python2
wget https://www.python.org/ftp/python/2.7.18/Python-2.7.18.tgz
tar xzf Python-2.7.18.tgz
cd Python-2.7.18
sudo ./configure --enable-optimizations
sudo make altinstall
sudo ln -s "/usr/local/bin/python2.7" "/usr/bin/python"