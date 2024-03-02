copy_file_to_minion:
  file.managed:
    - name: /opt/dev.conf  # Destination path on the minion
    - source: salt://dev.conf  # Source path on the master
    - user: root
    - group: root
    - mode: 644
    - makedirs: true  # Create parent directories if they don't exist

copy_sample_script_to_minion:
  file.managed:
    - name: /opt/sample.sh
    - source: salt://sample.sh
    - user: root
    - group: root
    - mode: 755  # Set executable permission
    - makedirs: true

run_shell_script:
  cmd.run:
    - name: /opt/sample.sh  # Path to your shell script on the minion
    - user: root

    
restart_nginx_service:
  cmd.run:
    - name: systemctl restart nginx
    - unless: systemctl is-active nginx
