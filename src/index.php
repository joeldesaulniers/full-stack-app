
<html>
<head>
    <title>Welcome to my website!</title>
</head>
<body>
    <h1>Hello World from Docker!</h1>

    <a href="exercise.txt">
        <img src="logo.png" alt="Click me!" width="125" height="125">
    </a>

    <br><br>

    <form method="post">
        <input type="submit" name="query" value="Query MongoDB"/>
    </form>

    <?php
    use MongoDB\Driver\Manager;
    use MongoDB\Driver\Command;
    use MongoDB\Driver\Query;
    use MongoDB\Driver\Cursor;

    // MongoDB connection
    $pw = file_get_contents('/etc/secret-volume/password');
    $client = new MongoDB\Driver\Manager("mongodb://[username]:".$pw."@[hostname]:27017?authSource=[database_name]");

    // Query setup
    $filter = [];
    $options = [];
    $query = new MongoDB\Driver\Query($filter, $options);
    
    // Execute query and display results
    $cursor = $client->executeQuery('[database_name].[collection]', $query);
    if(isset($_POST['query'])) {
        foreach ($cursor as $document) {
            echo "========<br />".PHP_EOL;
            var_dump($document);
            echo "<br />".PHP_EOL;
        }
    }
    ?>
</body>
</html>
