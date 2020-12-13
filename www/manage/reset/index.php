<?php
session_start();
include('../../includes/header.php');
?>

<style>
label {
    margin: 0;
    display: inline-block;
}
</style>

<h2>Management Portal</h2>
<h3>PASSWORD RESET</h3>
<hr>

<?php
    if (!$_GET['uuid']) {
        echo('error: invalid reset link (uuid is not present in URL)');
        include('../../includes/footer.php');
        die();
    }
?>

<?php
$uuid = $_GET['uuid'];
$pg   = pg_connect('REDACTED');
$res  = pg_query_params('
    SELECT *
    FROM reset_passwd
    JOIN user_login
        ON user_login_uid = user_login.uid
    WHERE
        (reset_passwd.id::TEXT) = $1 AND
        (CURRENT_TIMESTAMP < expires_at);',
    [$uuid]);
$row  = pg_fetch_assoc($res);
if (!$row) {
    echo('error: reset link does not exist -- or is expired');
    include('../../includes/footer.php');
    die();
}
?>

<pre>
    uid : <?= $row['uid'] ?>

  email : <?= $row['email'] ?>
</pre>
<hr>

<form action="/manage/reset/submit" method="POST">
    <input hidden type="text" name="uuid" value="<?= $row['id'] ?>">

    <label>
        new password:
        <input type="password" name="password">
    </label>

    <label>
        <input type="submit" value="submit">
    </label>
</form>

<?php include("../../includes/footer.php"); ?>
