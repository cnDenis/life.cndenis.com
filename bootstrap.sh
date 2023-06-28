#!/bin/sh
pip install -r requirements.txt

cd ..
git clone https://github.com/getpelican/pelican-plugins.git
git clone git@github.com:cnDenis/pelican-themes.git
cd pelican-themes
git checkout denis
