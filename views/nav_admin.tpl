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
                            <a class="currentMenuItem" href="/admin">New Quests</a>
                        %else:
                            <a href="/admin">New Quests</a>
                        %end
                    </li>
                    <li>
                        %if request.path == '/handle_users':
                            <a class="currentMenuItem" href="/handle_users">Users</a>
                        %else:
                            <a href="/handle_users">Users</a>
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
