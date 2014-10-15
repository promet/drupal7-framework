<?php

$enable = array(
  //The initial default theme on a Promet project is Omega. A subtheme needs to be created.
  'theme_default' => 'omega',
  'admin_theme' => 'seven',
);
theme_enable($enable);

foreach ($enable as $var => $theme) {
  if (!is_numeric($var)) {
    variable_set($var, $theme);
    if ($theme == 'omega') {
      $settings =  variable_get('theme_'. $theme .'_settings');

      // Configure settings for conceptual theme.
      variable_set('theme_'. $theme .'_settings', $settings);

      // Disable default blocks.
      db_update('block')
        ->fields(array('status' => 0))
        ->condition('theme', $theme)
        ->condition('delta', 'main', '!=')
        ->execute();
    }
  }
}

// Disable the default Bartik.
theme_disable(array('bartik'));
