<!DOCTYPE html>
<html>

	<head>
		<title>Logga in</title>
		<meta charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1.0, user-scalable=no">
		<link rel="stylesheet" type="text/css" href="/static/main.css">
	</head>
	<body>
        <header>
            <nav>
                <a class="menuButtons">Start</a>
                <a class="menuButtons"></a>
                <a class="menuButtons"></a>
            </nav>
        </header>
		<content>
            <h1>Admin, {{user}}</h1>
            <h2>You are loged in as {{level}}</h2>
            <a href="/log_out">Logga ut</a>
            <a href="/">Home</a>
        </content>
	</body>
</html>
