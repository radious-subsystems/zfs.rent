<?php
session_start();
include("../includes/header.php");
?>

<style>
</style>

<h2>Management Portal</h2>
<hr>

<form action="#" method="POST">
    <label>
        email:<br>
        <input type="email" id="email">
    </label>

    <label>
        password:<br>
        <input type="password" id="password">
    </label>

    <label>
        <input type="submit" value="login">
    </label>
</form>

<?php include("../includes/footer.php"); ?>
