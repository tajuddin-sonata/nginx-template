copy_file_to_minion:
  file.managed:
    - name: /opt/dev.conf  # Destination path on the minion
    - source: salt://dev.conf  # Source path on the master
    - user: root
    - group: root
    - mode: 644
    - makedirs: true  # Create parent directories if they don't exist

restart_nginx_service:
  cmd.run:
    - name: systemctl restart nginx
    - unless: systemctl is-active nginx
