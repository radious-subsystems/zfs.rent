<?php include("../includes/header.php"); ?>

<style>
li.question {
    font-weight: bold;
    margin-bottom: 1em;
}
li.question li {
    font-weight: normal;
}
</style>

<h2>updates</h2>
<p>
A changelog-ish journal of what's going on.
</p>
<hr>

<h3>Schema Finalized - Nov. 20th, 2020 [<a id=u2 href="#u2">permalink</a>]</h3>
<section style="background: lightyellow">
<u>Author: Ryan Jacobs</u>
<p>
Eh... I thought this ER diagram generator made the DB schema look slick, so
I'd might as well post it. All of our base entities are tracked in the database.
It records their power usage, bandwidth consumption, temperature, etc.
<img src="../img/schema-v1.png" alt="Diagram of the SQL schema in production.">
</p>
<p>
I'm going to port over a project that I've been working on to plot lightweight
.png graphs of the systems.
(<a href="//notryan.com/vast">example 1</a>, <a href="//notryan.com/status">example 2</a>)
Look ma! No JS!
</p>
<p>
(Axes labels will be added to the zfs.rent graphs of course.)
</p>


<?php include("../includes/footer.php"); ?>
