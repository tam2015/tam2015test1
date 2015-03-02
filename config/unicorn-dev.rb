# config/unicorn-dev.rb

worker_processes 2
listen 3000
timeout 30
preload_app false
