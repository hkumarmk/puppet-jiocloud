Listen *:8774
<VirtualHost *:8774>
  ServerName compute.jiocloud.com
  ServerAdmin cloud.devops@ril.com

  ## Vhost docroot
  DocumentRoot /var/www



  ## Directories, there should at least be a declaration for /var/www

  <Directory /var/www>
    Options Indexes FollowSymLinks MultiViews
    AllowOverride None
    Order allow,deny
    Allow from all
  </Directory>

WSGIScriptAlias / /var/www/compute/osapi-compute.wsgi
WSGIDaemonProcess nova-osapi user=nova group=openstack processes=3 threads=10 python-path=/usr/share/pyshared/nova
WSGIProcessGroup nova-osapi

  ## Load additional static includes


  ## Logging
  ErrorLog /var/log/nova/osapi-compute.log
  ServerSignature Off
  CustomLog /var/log/nova/osapi-compute.log combined
SSLEngine on
SSLCertificateFile    /etc/apache2/certs/jiocloud.com.crt
SSLCertificateKeyFile /etc/apache2/certs/jiocloud.com.key
SSLCertificateChainFile /etc/apache2/certs/gd_bundle-g2-g1.crt
<FilesMatch "\.(cgi|shtml|phtml|php)$">
                SSLOptions +StdEnvVars
        </FilesMatch>
        <Directory /usr/lib/cgi-bin>
                SSLOptions +StdEnvVars
        </Directory>

BrowserMatch "MSIE [2-6]" \
                nokeepalive ssl-unclean-shutdown \
                downgrade-1.0 force-response-1.0
        # MSIE 7 and newer should be able to use keepalive
        BrowserMatch "MSIE [17-9]" ssl-unclean-shutdown

</VirtualHost>
