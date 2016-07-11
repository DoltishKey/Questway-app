<header>
        <div class="logo_container">
            <a href="/admin">Questway</a>
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
                    %if request.path == '/admin':
                        <a class="currentMenuItem" href="/admin">Ads</a>
                    %else:
                        <a href="/admin">Ads</a>
                    %end
                </li>
                <li>
                    %if request.path == '/edith_profile':
                        <a class="currentMenuItem" href="/edith_profile">Profile</a>
                    %else:
                        <a href="/edith_profile">Profile</a>
                    %end
                </li>
                <li>
                    %if request.path == '/log_out':
                        <a class="currentMenuItem" href="/log_out">Log out</a>
                    %else:
                        <a href="/log_out">Log out</a>
                    %end
                </li>
            </ul>
        </nav>
</header>
