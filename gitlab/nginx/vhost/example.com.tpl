server {
  listen *:443 ssl http2;

  server_name ~dev\.example\.com$;
  server_tokens off; ## Don't show the nginx version number, a security best practice

  ## Increase this if you want to upload large attachments
  ## Or if you want to accept large git objects over http
  client_max_body_size 0;

  ## Strong SSL Security
  ## https://raymii.org/s/tutorials/Strong_SSL_Security_On_nginx.html & https://cipherli.st/
  ssl on;
  ssl_certificate /var/opt/gitlab/nginx/letsencrypt/live/example.com/fullchain.pem;
  ssl_certificate_key /var/opt/gitlab/nginx/letsencrypt/live/example.com/privkey.pem;

  ## Backwards compatible ciphers to retain compatibility with Java IDEs
  ssl_ciphers 'ECDHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-SHA384:ECDHE-RSA-AES128-SHA256:ECDHE-RSA-AES256-SHA:ECDHE-RSA-AES128-SHA:AES256-GCM-SHA384:AES128-GCM-SHA256:AES256-SHA256:AES128-SHA256:AES256-SHA:AES128-SHA:!aNULL:!eNULL:!EXPORT:!DES:!MD5:!PSK:!RC4';
  ssl_protocols  TLSv1.1 TLSv1.2;
  ssl_prefer_server_ciphers on;
  ssl_session_cache  builtin:1000  shared:SSL:10m;
  ssl_session_timeout  5m;


  ## Real IP Module Config
  ## http://nginx.org/en/docs/http/ngx_http_realip_module.html

  ## HSTS Config
  ## https://www.nginx.com/blog/http-strict-transport-security-hsts-and-nginx/
  add_header Strict-Transport-Security "max-age=31536000";

  ## Individual nginx logs for this GitLab vhost
  access_log  /var/log/gitlab/nginx/example_com_access.log;
  error_log   /var/log/gitlab/nginx/example_com_error.log;

  gzip on;
  gzip_static on;
  gzip_comp_level 2;
  gzip_http_version 1.1;
  gzip_vary on;
  gzip_disable "msie6";
  gzip_min_length 10240;
  gzip_proxied no-cache no-store private expired auth;
  gzip_types text/plain text/css text/xml text/javascript application/x-javascript application/json application/xml application/rss+xml;

  proxy_set_header Host $http_host;
  proxy_set_header X-Real-IP $remote_addr;
  proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
  proxy_set_header Upgrade $http_upgrade;
  proxy_set_header Connection $connection_upgrade;
  proxy_set_header X-Forwarded-Proto https;
  proxy_set_header X-Forwarded-Ssl on;

  location / {
    if ($sub ~ ^dev) {
      proxy_pass http://dev-container;
    }
    root /var/opt/gitlab/nginx/html/$host;
  }
}

# server {
# 	listen 80 default_server;
# 	listen [::]:80 default_server;
# 	server_name _;
# 	return 301 https://$host$request_uri;
# }