<?php
  if(null !== $$installer_defaults) {
    $$installer_defaults['setup_db_host_name']            = '$db_host_name';
    $$installer_defaults['setup_db_database_name']        = '$database_name';
    $$installer_defaults['setup_db_admin_user_name']      = '$db_user_name';
    $$installer_defaults['setup_db_admin_password']       = '$db_password';
    $$installer_defaults['db_type']                       = '$db_type';
  }

  if(null !== $$sugar_config) {
    $$sugar_config['dbconfig']['db_port'] = '$db_tcp_port';
    $$sugar_config['dbconfig']['db_manager'] = '$db_manager';
  }
?>
