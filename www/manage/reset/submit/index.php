<?php
$uuid     = $_POST['uuid'];
$password = $_POST['password'];

$cmd  = '/home/ryan/zfs-rent/api/internal/php_set_password_via_uuid.rb';
$ecmd = escapeshellcmd(implode(' ', array($cmd, $uuid, $password)));

system($ecmd);
?>
