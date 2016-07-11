<header>
    <div class="container" style="padding:0px;">
    <div class="logo_container">
        <a href="/">Questway</a>
    </div>
    <div class="hide_show_menu_container">
        <div>
            <div class="menu_line"></div>
            <div class="menu_line"></div>
            <div class="menu_line"></div>
        </div>
    </div>
    <nav class="main_menu">
            %from bottle import request
            <ul>
                <li>
                    %if request.path == "/":
                        <a class="currentMenuItem" href="/">Start</a>
                    %else:
                        <a href="/">Start</a>
                    %end
                </li>
                <li>
                    %if request.path == '/about_us':
                        <a class="currentMenuItem" href="/about_us">About us</a>
                    %else:
                        <a href="/about_us">About us</a>
                    %end
                </li>
                <li>
                    %if request.path == "/create_employer":
                        <a class="currentMenuItem" href="/create_employer">Join us</a>
                    %else:
                        <a href="/create_employer">Join us</a>
                    %end
                </li>
                <li>
                    %if request.path == "/login":
                        <a class="currentMenuItem" href="/login">Log in</a>
                    %else:
                        <a href="/login">Log in</a>
                    %end
                </li>
            </ul>
    </nav>
</div>
</header>
