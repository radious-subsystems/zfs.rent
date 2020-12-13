<?php include("../includes/header.php"); ?>

<h2>beta:</h2>
<p>This service is in beta.</p>
<p>We <a href="https://news.ycombinator.com/item?id=25148000">soft launched</a>
   on November 19th, 2020.
</p>

<p>
<b>PLEASE EMAIL <a href="mailto:zfs@radious.co">zfs@radious.co</a>
if you are interested.</b> We want this service to become a reality. We believe
in creating products with sustainable pricing models that we, ourselves,
would enjoy.
</p>
<p>Beta slots are sold on a "first come, first served" basis.
<ol>
    <li>Email <a href="mailto:zfs@radious.co">zfs@radious.co</a>
        to secure a position in the queue.</li>
    <li>Pay your first invoice to secure a slot.</li>
</ol>
</p>
<hr>

<p>
beta invites issued: 26<br>
beta invites accepted: 5<br><br>
beta requests received:<br>
<?php
$pg  = pg_connect('REDACTED');
$res = pg_query('SELECT * FROM zfsrent._beta_inquiry_count');
while ($data = pg_fetch_object($res)) {
  echo "&nbsp; ", $data->date  . ": ";
  echo $data->count . "<br>";
}
?>
</p>

<?php include("../includes/footer.php"); ?>
