<!--
Skriven av: Alla
-->
    <head>
        <title>{{pageTitle}}</title>
        <link rel="shortcut icon" type="image/png" href="../static/img/custom_icon.png"/>
        <link rel="shortcut icon" type="image/png" href="../static/img/custom_icon.png"/>

        <link rel="apple-touch-icon" href="../static/img/custom_icon.png">

        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1.0, user-scalable=no">
        <meta name="google-site-verification" content="n3CQ5vTUv0AwBD2OhRbbeWOJNkun0SG14w1b5zwcFrY" />
        <link rel="stylesheet" type="text/css" href="/static/fonts/stylesheet.css">
        <link rel="stylesheet" type="text/css" href="/static/css/main.css">
        <!--<link href='https://fonts.googleapis.com/css?family=Pacifico' rel='stylesheet' type='text/css'>-->
        <!--<link rel="stylesheet" type="text/css" href="/static/css/bootstrap/bootstrap.min.css">-->
        <script src="/static/js/jquery.js"></script>
        <script src="/static/js/main.js" type="text/javascript"></script>
        <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
        %try:
            %ogs
            <meta property="og:title" content="{{ogs['title']}}" />
            <meta property="og:image" content="https://questway.se/{{ogs['img']}}" />
            <meta property="og:image:type" content="image/jpeg" />
            <meta property ="og:description " content="Connects start-ups with students in Southern Sweden. Created to improve the innovation system in southern Sweden."/>
        %except NameError:
            <meta property="og:title" content="Questway.se" />
            <meta property="og:image" content="https://questway.se/static/img/og_cover.png" />
            <meta property="og:image:type" content="image/png" />
            <meta property ="og:description " content="Connects start-ups with students in Southern Sweden. Created to improve the innovation system in southern Sweden."/>
    </head>
