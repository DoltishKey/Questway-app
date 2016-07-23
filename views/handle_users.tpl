<!DOCTYPE html>
<html>
    % include('head.tpl')
    <body>
        %include('nav_admin.tpl')
        <main class="handle_users">
            <div class="container">
                <div class="users">
                    <h2>Users</h2>
                    %if users:
                        %for user in users:
                            <a class="user flexer_parent" href="/admin_ads/{{user[0]}}">
                                <div class="content flexer">
                                    <div>
                                        <div class="user_icon red"></div>
                                        <div class="text">
                                            <h4>{{user[1]}} {{user[2]}}</h4>
                                            <p>{{user[5]}} <span>ads</span></p>
                                        </div>
                                    </div>
                                    <div class="go"></div>
                                </div>
                            </a>
                        %end
                    %else:
                        <p>There is no users</p>
                    %end
                    <div class="new_user overlay_open">
                        <div class="btn red">Create new user +</div>
                    </div>
                </div>
                <div class="shadow"></div>
                <div class="new_user_form overlay">
                    <div class="close close_icon"></div>
                    <hr>
                    <div class="container">
                        <h2>Create new user</h2>
                        <form action="/do_create_user" method="post">
                            <label for="firstname">Förnamn</label>
                            <input id="firstname" name="first_name" type="text">
                            <br>
                            <label for="lastname">Efternamn</label>
                            <input id="lastname" name="last_name" type="text">
                            <br>
                            <label for="phone">Tele</label>
                            <input id="phone" name="phone" type="text">
                            <br>
                            <label for="mail">Mail</label>
                            <input id="mail" name="email" type="text">
                            <br>
                            <label for="password">Lösenord</label>
                            <input id="password" name="password" type="text">
                            <br>
                            <input class="btn submit red" type="submit" value="Create">
                        </form>
                    </div>
                </div>
            </div>
        </main>
        %include('footer.tpl')
    </body>
</html>
