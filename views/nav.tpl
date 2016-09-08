<script>
    $(document).ready(function() {
        if (document.cookie.indexOf('accepting_cookies_from_questway')== -1 ){
            $('.cookie_message').show()
            $('.accept_cookie').click(function(){
                var d = new Date();
                d.setTime(d.getTime() + (365*24*60*60*1000));
                var expires = "expires="+ d.toUTCString();
                document.cookie = 'accepting_cookies_from_questway' + "=" + true + "; " + expires;
                $('.cookie_message').slideUp(800)
            })
        }
        else{
            $('.cookie_message').hide()
        }
    });
</script>
<div class="cookie_message container">
    <h4>Cookies</h4>
    <p>By using this site you accept our terms of service and our use of cookies. You can read more about it <a href="#">here.</a></p>
    <div class="btn accept_cookie">Ok, I got it</div>
</div>
<header>
    <div class="container" style="padding:0px;">
    <div class="logo_container">
        <a href="/">
            <img src="/static/img/logo.svg" alt="questway_logo" />
        </a>
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
