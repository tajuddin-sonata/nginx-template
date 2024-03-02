copy_file_to_minion:
  file.managed:
    - name: /opt/$TARGET_FILE_NAME  # Destination path on the minion
    - source: salt://$TARGET_FILE_NAME  # Source path on the master
    - user: root
    - group: root
    - mode: 644
    - makedirs: true  # Create parent directories if they don't exist