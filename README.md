Tutorial Code
=============
This code is based on the chef tutorial http://gettingstartedwithchef.com/first-steps-with-chef.html

However this code has been updated to the latest mysql (6.1.0) recipes. 

Installation
============
First install chef-solo on the target machine: 

    curl -L https://www.opscode.com/chef/install.sh | bash

Then install git:

    apt-get install git

And clone this repo into /root/chef-repo and run

    cd chef-repo; chef-solo -c solo.rb -j web.json

Finally, edit /etc/apache2/apache2.conf and add: 

    <Directory /var/www/phpapp>
        Options Indexes FollowSymLinks
        AllowOverride None
        Require all granted
    </Directory>

Then from a web browser go to `http://youripaddr/phpapp/index.php`